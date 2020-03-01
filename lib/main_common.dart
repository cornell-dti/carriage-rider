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

authenticationRequest(String baseUrl, String token) async {
  var endpoint = baseUrl + '/auth';
  Response response = await post(endpoint, body: {"token": token});
  return response.body;
}