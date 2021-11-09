import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'utils/app_config.dart';
import 'main_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AppConfig configuredApp = AppConfig(
    baseUrl: 'https://carriage-web.herokuapp.com/api',
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}
