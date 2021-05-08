import 'package:flutter/material.dart';

class PushNotificationMessageAndroid {
  final String title;
  final String body;

  PushNotificationMessageAndroid({
    @required this.title,
    @required this.body,
  });

  factory PushNotificationMessageAndroid.fromJson(Map<String, dynamic> json) {
    // temporary parsing for console messages
    return PushNotificationMessageAndroid(
      title: json["data"]["default"],
      body: json["data"]["default"],
    );
  }
}

class PushNotificationMessageIOS {
  final String title;
  final String body;

  PushNotificationMessageIOS({
    @required this.title,
    @required this.body,
  });

  factory PushNotificationMessageIOS.fromJson(Map<String, dynamic> json) {
    return PushNotificationMessageIOS(
      title: json['aps']['alert']['title'],
      body: json['aps']['alert']['body'],
    );
  }
}
