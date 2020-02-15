import 'package:flutter/material.dart';
import 'app_config.dart';
import 'main_common.dart';


void main() {
  AppConfig configuredApp = AppConfig(
    baseUrl: "http://10.0.2.2:3000",
    child: MyApp(),
  );

  mainCommon();


  runApp(configuredApp);
