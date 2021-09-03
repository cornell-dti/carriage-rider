import 'package:flutter/material.dart';
import 'utils/app_config.dart';
import 'main_common.dart';

void main() {
  AppConfig configuredApp = AppConfig(
    baseUrl: 'https://carriage-web.herokuapp.com/api',
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}
