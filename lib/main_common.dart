import 'dart:async';
import 'package:carriage_rider/pages/OnBoarding.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/NotificationsProvider.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/Login.dart';
import 'pages/Home.dart';
import 'utils/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void mainCommon() {}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(context) {
    AppConfig appConfig = AppConfig.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (context) {
          return AuthProvider(appConfig);
        })
      ],
      child: ChangeNotifierProvider<RiderProvider>(
        create: (context) {
          return RiderProvider(
            appConfig,
            Provider.of<AuthProvider>(context, listen: false),
          );
        },
        child: ChangeNotifierProvider<RidesProvider>(
          create: (context) {
            return RidesProvider(
              appConfig,
              Provider.of<AuthProvider>(context, listen: false),
            );
          },
          child: ChangeNotifierProvider<LocationsProvider>(
              create: (context) {
                return LocationsProvider(
                  appConfig,
                  Provider.of<AuthProvider>(context, listen: false),
                  Provider.of<RiderProvider>(context, listen: false),
                );
              },
              child: ChangeNotifierProvider<RideFlowProvider>(
                  create: (context) {
                    return RideFlowProvider();
                  },
                  child: ChangeNotifierProvider<NotificationsProvider>(
                    create: (context) {
                      return NotificationsProvider();
                    },
                    child: MaterialApp(
                      title: 'Carriage Rider',
                      theme: ThemeData(
                          primarySwatch: Colors.green,
                          fontFamily: 'SFPro',
                          accentColor: Color.fromRGBO(60, 60, 67, 0.6),
                          textTheme: TextTheme(
                            headline4: TextStyle(
                                fontFamily: 'SFDisplay',
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.37,
                                color: Colors.black),
                            headline5: TextStyle(
                                fontFamily: 'SFDisplay',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.23,
                                color: Colors.black),
                            headline6: TextStyle(
                                fontFamily: 'SFDisplay',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.38,
                                color: Colors.black),
                            subtitle2: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.41),
                            bodyText1: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.normal),
                            bodyText2: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.normal),
                            headline1: TextStyle(
                                color: Colors.black,
                                fontSize: 34,
                                fontWeight: FontWeight.bold),
                            subtitle1: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold),
                          )),
                      home: Logic(),
                      debugShowCheckedModeBanner: false,
                    ),
                  ))),
        ),
      ),
    );
  }
}

class Logic extends StatefulWidget {
  Logic({Key key}) : super(key: key);

  @override
  _LogicState createState() => new _LogicState();
}

class _LogicState extends State<Logic> {
  bool firstTime;

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      prefs.setBool('first_time', false);
      return false;
    } else {
      prefs.setBool('first_time', false);
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      isFirstTime().then((isFirstTime) {
        firstTime = isFirstTime;
      });
    });
  }

  @override
  Widget build(context) {
    AuthProvider authProvider = Provider.of(context);
    return authProvider.isAuthenticated ? HomeOrOnBoarding() : Login();
  }
}

class HomeOrOnBoarding extends StatelessWidget {
  HomeOrOnBoarding({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> isFirstTime() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool firstLogin = prefs.getBool('firstTime') == null;
      if (firstLogin) {
        await prefs.setBool('firstTime', true);
      }
      return firstLogin;
    }

    return FutureBuilder<bool>(
        future: isFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool firstLogin = snapshot.data;
            return firstLogin ? OnBoarding() : Home();
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
