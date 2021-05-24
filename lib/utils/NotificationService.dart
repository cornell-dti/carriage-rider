import 'dart:convert';
import 'package:flutter/material.dart';

class PushNotificationMessageAndroid {
  final String title;
  final String body;
  final String rideId;
  final String changedBy;

  PushNotificationMessageAndroid(
      {@required this.title,
      @required this.body,
      @required this.rideId,
      @required this.changedBy});

  factory PushNotificationMessageAndroid.fromJson(Map<String, dynamic> json) {
    // temporary parsing for console message
    String parsed = json['data']['default'];

    return PushNotificationMessageAndroid(
      title: parsed,
      body: parsed,
      rideId: jsonDecode(parsed)['ride']['id'],
      changedBy: jsonDecode(parsed)['changedBy']['userType'],
    );
  }
}

class PushNotificationMessageIOS {
  final String title;
  final String body;
  final String rideId;
  final String changedBy;

  PushNotificationMessageIOS(
      {@required this.title,
      @required this.body,
      @required this.rideId,
      @required this.changedBy});

  factory PushNotificationMessageIOS.fromJson(Map<String, dynamic> json) {
    String parsed = json['default'];
    return PushNotificationMessageIOS(
      title: parsed,
      body: parsed,
      rideId: jsonDecode(parsed)['ride']['id'],
      changedBy: jsonDecode(parsed)['changedBy']['userType'],
    );
  }
}
