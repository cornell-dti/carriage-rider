import 'app_config.dart';
import 'main_common.dart';
import 'package:flutter/material.dart';

void main() {
  AppConfig configuredApp = AppConfig(
    baseUrl: "http://10.0.2.2:3001",
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}