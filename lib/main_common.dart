import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login.dart';
import 'Home.dart';

void mainCommon() {

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (BuildContext context) {
            return AuthProvider();
          }
        )
      ],
    child: MaterialApp(
      title: 'Carriage Rider',
      theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'SFPro',
          accentColor: Color.fromRGBO(60, 60, 67, 0.6),
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            subhead: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          )),
      home: Logic(),
      debugShowCheckedModeBanner: false,
    )
    );
  }
}

class Logic extends StatelessWidget {
  Logic({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);
    return authProvider.isAuthenticated ? Home() : Login();
  }
}