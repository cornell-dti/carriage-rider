import 'package:flutter/material.dart';
import 'utils/app_config.dart';
import 'main_common.dart';

void main() {
  AppConfig configuredApp = AppConfig(
    baseUrl: 'http://localhost:3001/api',
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}