import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/RiderProvider.dart';
import 'package:carriage_rider/RidesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login.dart';
import 'Home.dart';
import 'app_config.dart';

void mainCommon() {}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = AppConfig.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (BuildContext context) {
          return AuthProvider(appConfig);
        })
      ],
      child: ChangeNotifierProvider<RiderProvider>(
        create: (BuildContext context) {
          return RiderProvider(
            appConfig,
            Provider.of<AuthProvider>(context, listen: false),
          );
        },
        child: ChangeNotifierProvider<PastRidesProvider>(
          create: (BuildContext context) {
            return PastRidesProvider(
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
                  headline5:
                      TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  subtitle1:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                )),
            home: Logic(),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
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
