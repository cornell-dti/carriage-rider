//import 'dart:convert';
//import 'package:carriage_rider/pages/Notifications.dart';
//import 'package:flutter/material.dart';
//
//class PushNotificationMessageAndroid {
//  final String title;
//  final String body;
//  final String rideId;
//  final String changedBy;
//
//  PushNotificationMessageAndroid(
//      {@required this.title,
//      @required this.body,
//      @required this.rideId,
//      @required this.changedBy});
//
//  factory PushNotificationMessageAndroid.fromJson(Map<String, dynamic> json) {
//    // temporary parsing for console message
//    String parsed = json['data']['default'];
//    String changedBy = jsonDecode(parsed)['changedBy']['userType'];
//    Map<String, dynamic> change = jsonDecode(parsed)['change'];
//
//    NotifType type;
//    if (changedBy == 'Admin') {
//      if (change['driver'] != null) {
//        type = NotifType.RIDE_CONFIRMED;
//      }
//      else {
//        type = NotifType.RIDE_EDITED;
//      }
//    }
//    else if (changedBy == 'Driver') {
//      String status = change['data']['ride']['status'];
//      print(status);
//      if (status == 'on_the_way') {
//        type = NotifType.DRIVER_ON_THE_WAY;
//      }
//      else if (status == 'arrived') {
//        type = NotifType.DRIVER_ARRIVED;
//      }
//      else if (status == 'no_show') {
//        type = NotifType.DRIVER_CANCELLED;
//      }
//    }
//
//    print(jsonDecode(parsed)['ride']['id']);
//    return PushNotificationMessageAndroid(
//      title: parsed,
//      body: parsed,
//      rideId: jsonDecode(parsed)['ride']['id'],
//      changedBy: jsonDecode(parsed)['changedBy']['userType'],
//    );
//  }
//}
//
//class PushNotificationMessageIOS {
//  final String title;
//  final String body;
//  final String rideId;
//  final String changedBy;
//
//  PushNotificationMessageIOS(
//      {@required this.title,
//      @required this.body,
//      @required this.rideId,
//      @required this.changedBy});
//
//  factory PushNotificationMessageIOS.fromJson(Map<String, dynamic> json) {
//    String parsed = json['default'];
//    return PushNotificationMessageIOS(
//      title: parsed,
//      body: parsed,
//      rideId: jsonDecode(parsed)['ride']['id'],
//      changedBy: jsonDecode(parsed)['changedBy']['userType'],
//    );
//  }
//}
