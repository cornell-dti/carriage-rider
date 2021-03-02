import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/Login.dart';
import 'pages/Home.dart';
import 'utils/app_config.dart';

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
                context,
                appConfig,
                Provider.of<AuthProvider>(context, listen: false),
              );
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
                    subtitle1:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  )),
              home: Logic(),
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
  }
}

class Logic extends StatelessWidget {
  Logic({Key key}) : super(key: key);

  @override
  Widget build(context) {
    AuthProvider authProvider = Provider.of(context);
    return authProvider.isAuthenticated ? Home() : Login();
  }
}
