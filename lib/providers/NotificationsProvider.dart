import 'dart:core';
import 'dart:io';
import 'package:carriage_rider/pages/Notifications.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import '../utils/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:carriage_rider/models/Location.dart';

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
