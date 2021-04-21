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