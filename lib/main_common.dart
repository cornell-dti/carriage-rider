import 'dart:async';

import 'package:carriage_rider/pages/Home.dart';
import 'package:carriage_rider/pages/Login.dart';
import 'package:carriage_rider/pages/OnBoarding.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:carriage_rider/providers/NotificationsProvider.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/app_config.dart';

void mainCommon() {}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(context) {
    AppConfig appConfig = AppConfig.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            return AuthProvider(appConfig);
          },
        ),
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
                      fontFamily: 'Inter',
                      accentColor: Color.fromRGBO(60, 60, 67, 0.6),
                      textTheme: TextTheme(
                        headline4: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.37,
                            color: Colors.black),
                        headline5: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.23,
                            color: Colors.black),
                        headline6: TextStyle(
                            fontFamily: 'Inter',
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
                  home: Main(),
                  debugShowCheckedModeBanner: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Main extends StatelessWidget {
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
  Widget build(context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isAuthenticated) {
      return Login();
    } else {
      return FutureBuilder(
        future: isFirstTime(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            bool firstLogin = snapshot.data;
            return firstLogin ? OnBoarding() : Home();
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}
