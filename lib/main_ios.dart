import 'app_config.dart';
import 'main_common.dart';
import 'package:flutter/material.dart';

void main() {
  AppConfig configuredApp = AppConfig(
    baseUrl: "http://localhost:3000",
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}