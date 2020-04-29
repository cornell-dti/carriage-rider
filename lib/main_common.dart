import 'package:flutter/material.dart';
import 'app_config.dart';
import 'Login.dart';
import 'package:http/http.dart';

void mainCommon() {

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfig.of(context);
    return _buildApp(config.baseUrl);
  }

  Widget _buildApp(String baseUrl) {
    return MaterialApp(
      title: 'Carriage Rider',
      theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'SFPro',
          accentColor: Color.fromRGBO(60, 60, 67, 0.6),
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            subhead: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          )),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

authenticationRequest(String baseUrl, String token, String email) async {
  var endpoint = baseUrl + '/auth';
  var requestBody = {
    "token": token,
    "email": email,
    "clientID": "241748771473-0r3v31qcthi2kj09e5qk96mhsm5omrvr.apps.googleusercontent.com",
    "table": "Riders"
  };
  Response response = await post(endpoint, body: requestBody);
  return response.body;
}
