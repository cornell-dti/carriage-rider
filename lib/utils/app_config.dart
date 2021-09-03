import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  AppConfig({this.baseUrl, Widget child}) : super(child: child);

  final String baseUrl;

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
