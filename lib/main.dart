import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'utils/app_config.dart';
import 'main_common.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  String notifId = message.data['id'];
  print('handling a background message $notifId');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AppConfig configuredApp = AppConfig(
    baseUrl: 'https://carriage-web.herokuapp.com/api',
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}
