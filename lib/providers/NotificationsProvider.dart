import 'dart:core';
import 'package:carriage_rider/pages/Notifications.dart';
import 'package:flutter/material.dart';

class NotificationsProvider with ChangeNotifier {
  bool hasNewNotif = false;
  List<BackendNotification> notifs = [];
  // Notification ids and this id set are necessary to prevent duplicate
  // notifications, in the case where user receives foreground notification,
  // leaves app, then taps on notification.
  Set<String> notifIds = new Set();

  void addNewNotif(BackendNotification newNotif) {
    if (!notifIds.contains(newNotif.id)) {
      hasNewNotif = true;
      notifs.add(newNotif);
      notifIds.add(newNotif.id);
      notifyListeners();
    }
  }

  void notifOpened() {
    hasNewNotif = false;
    notifyListeners();
  }
}
