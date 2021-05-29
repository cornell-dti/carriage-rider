import 'dart:core';
import 'package:carriage_rider/pages/Notifications.dart';
import 'package:flutter/material.dart';

class NotificationsProvider with ChangeNotifier {
  bool hasNewNotif = false;
  List<BackendNotification> notifs = [];

  void addNewNotif(BackendNotification newNotif) {
    hasNewNotif = true;
    notifs.add(newNotif);
    notifyListeners();
  }

  void notifOpened() {
    hasNewNotif = false;
    notifyListeners();
  }
}
