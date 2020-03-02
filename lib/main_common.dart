import 'package:flutter/material.dart';
import 'app_config.dart';
import 'package:carriage_rider/Home.dart';

void mainCommon() {

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfig.of(context);
    return _build(config.baseUrl);
  }

  Widget _build(String baseUrl) {
    return MaterialApp(
      title: 'Carriage Rider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

