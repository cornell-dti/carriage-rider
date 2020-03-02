import 'package:flutter/material.dart';
import 'app_config.dart';

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
      home: HomePage(title: 'Carriage Rider'),
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