import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {

  final FirebaseMessaging _fcm;

  NotificationService(this._fcm);


  StreamSubscription iosSubscription; // ignore: cancel_subscriptions

  _registerOnFirebase() async {
    _fcm.subscribeToTopic('all');
    await _fcm.getToken().then((token) => print(token));
  }

  void initialize() {
    _registerOnFirebase();
    if (Platform.isIOS) {
      iosSubscription =
          _fcm.onIosSettingsRegistered.listen((data) {
            // save the token  OR subscribe to a topic here
            _fcm.subscribeToTopic('all');
          });

      _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
    }
  }

}

class PushNotificationMessageAndroid {
  final String title;
  final String body;
  PushNotificationMessageAndroid({
    @required this.title,
    @required this.body,
  });

  factory PushNotificationMessageAndroid.fromJson(Map<String, dynamic> json) {
    // temporary parsing
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


class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({@required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}