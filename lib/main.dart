import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert' as convert;
import 'Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carriage Rider',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'SFPro',
          accentColor: Color.fromRGBO(60, 60, 67, 0.6),
          textTheme: TextTheme(headline: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            subhead: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            display1: TextStyle(fontSize: 17.0, color: Colors.black),
          )),
      home: Login()
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the beginning of the app',
            ),
          ],
        ),
      ),
    );
  }
}

String localhost() {
  if(Platform.isAndroid) {
    return 'http://10.0.2.2:3000'; // works for emulator
  } else {
    return 'http://localhost:3000';
  }
}

authenticationRequest(String token) async {
  var endpoint = localhost() + '/verify';
  Response response = await post(endpoint, body: {"token": token});
  return response.body;
}