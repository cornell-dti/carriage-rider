import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:carriage_rider/pages/ride-flow/Request_Ride_Loc.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:carriage_rider/pages/Notifications.dart';
import 'package:carriage_rider/pages/Profile.dart';
import 'package:carriage_rider/utils/NotificationService.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/widgets/CurrentRideCard.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Ride_History.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/pages/Contact.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'Upcoming.dart';

void main() {
  MaterialApp(routes: {
    '/': (context) => Home(),
  });
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TODO: figure out if there's been a new notification
  bool hasNewNotification = true;
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  StreamSubscription iosSubscription; // ignore: cancel_subscriptions
  String deviceToken;

  @override
  void initState() {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    initialize();
    getMessage();
    super.initState();
  }

  Future<void> onSelectNotification(String payload) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => NotificationsPage()));
    return Future<void>.value();
  }

  _registerOnFirebase() async {
    //_fcm.subscribeToTopic('all');
    await _fcm.getToken().then((token) => deviceToken = token);

    if (deviceToken != null) {
      subscribe(deviceToken);
    }
    _fcm.onTokenRefresh.listen((newToken) {
      subscribe(newToken);
    });
  }

  void initialize() async {
    _registerOnFirebase();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
        _fcm.subscribeToTopic('all');
      });
      await _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
    }
  }

  // Show notification banner on background and foreground.
  static void showNotification(String notification) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        await getAndroidNotificationDetails(notification);
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await notificationsPlugin.show(
      0,
      'Carriage Rider',
      notification,
      platformChannelSpecifics,
    );
  }

  static Future<AndroidNotificationDetails> getAndroidNotificationDetails(
      dynamic notification) async {
    return AndroidNotificationDetails('general', 'General notifications',
        'General notifications that are not sorted to any specific topics.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        category: 'General',
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'));
  }

  void getMessage() async {
    PushNotificationMessageAndroid androidNotification;
    PushNotificationMessageIOS iosNotification;

    _fcm.configure(
      onBackgroundMessage: Platform.isIOS ? null : backgroundHandle,
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        Platform.isIOS
            ? showNotification(iosNotification.body)
            : showNotification(androidNotification.body);
        setState(() {});
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => NotificationsPage()));
        setState(() {});
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        } else {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => NotificationsPage()));
        setState(() {});
      },
    );
  }

  static Future<dynamic> backgroundHandle(
    Map<String, dynamic> message,
  ) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data']['default'];
      showNotification('$data');
      print("_backgroundMessageHandler data: $data");
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification']['body'];
      showNotification('$notification');
      print("_backgroundMessageHandler notification: $notification");
    }
    return Future<void>.value();
  }

  subscribe(String token) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authToken = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      "${AppConfig.of(context).baseUrl}/notification/subscribe",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },
      body: jsonEncode(<String, String>{
        'userId': authProvider.id,
        'userType': 'Rider',
        'platform': 'android',
        'token': token,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to subscribe.');
    }
  }

  @override
  Widget build(context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    AppConfig appConfig = AppConfig.of(context);

    Widget sideBarText(String text, Color color) {
      return Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontFamily: 'SFPro'),
      );
    }

    double menuButtonSize = 48;
    double headingHorizPadding = 16;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(5.0),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person, color: Colors.black),
                title: sideBarText('Profile', Colors.black),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                leading: hasNewNotification
                    ? Stack(children: [
                        Icon(Icons.notifications, color: Colors.black),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                                width: 9,
                                height: 9,
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(100),
                                )))
                      ])
                    : Icon(Icons.notifications, color: Colors.black),
                title: sideBarText('Notifications', Colors.black),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => NotificationsPage()));
                },
              ),
              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: Colors.black),
                title: sideBarText('Contact', Colors.black),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Contact()));
                },
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: !ridesProvider.hasData() ||
                !locationsProvider.hasLocations() ||
                !riderProvider.hasInfo()
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  RefreshIndicator(
                      semanticsLabel: 'Refreshing rides',
                      onRefresh: () async {
                        await ridesProvider.fetchAllRides(
                            appConfig, authProvider);
                      },
                      child: CustomScrollView(slivers: [
                        SliverAppBar(
                          excludeHeaderSemantics: true,
                          elevation: 11,
                          pinned: true,
                          expandedHeight: 100,
                          collapsedHeight: 100,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          actions: [Container()],
                          flexibleSpace: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Semantics(
                                    header: true,
                                    label: 'Hi ' + riderProvider.info.firstName,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 23),
                                      child: ExcludeSemantics(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              menuButtonSize -
                                              (headingHorizPadding * 2),
                                          child: FittedBox(
                                            alignment: Alignment.centerLeft,
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Hi ' +
                                                  riderProvider.info.firstName +
                                                  '! ☀',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontFamily: 'SFPro',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 23),
                                    child: Builder(builder: (context) {
                                      Widget button = Semantics(
                                          label: 'Menu',
                                          child: IconButton(
                                              icon: Icon(Icons.menu,
                                                  color: Colors.black),
                                              onPressed: () =>
                                                  Scaffold.of(context)
                                                      .openEndDrawer()));
                                      if (hasNewNotification) {
                                        return Stack(children: [
                                          button,
                                          Positioned(
                                              top: 12,
                                              right: 12,
                                              child: Container(
                                                  width: 9,
                                                  height: 9,
                                                  padding: EdgeInsets.all(1),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  )))
                                        ]);
                                      }
                                      return button;
                                    }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Ride',
                                      style: CarriageTheme.subHeading,
                                    ),
                                    SizedBox(height: 12),
                                    CurrentRideCard(ridesProvider.currentRide,
                                        showCallDriver: true),
                                  ]),
                            ),
                            SizedBox(height: 35),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(children: [
                                Semantics(
                                  container: true,
                                  header: true,
                                  child: Text(
                                    'Upcoming Rides',
                                    style: CarriageTheme.subHeading,
                                  ),
                                ),
                                Spacer(),
                                ridesProvider.upcomingRides.isNotEmpty
                                    ? Semantics(
                                        button: true,
                                        container: true,
                                        child: GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpcomingSeeMore())),
                                            child: Row(children: [
                                              Text(
                                                'See More',
                                                style:
                                                    CarriageTheme.seeMoreStyle,
                                                semanticsLabel:
                                                    'See more upcoming rides',
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.arrow_forward,
                                                  size: 16)
                                            ])),
                                      )
                                    : Container()
                              ]),
                            ),
                            SizedBox(height: 12),
                            UpcomingRides(),
                            SizedBox(height: 36),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(children: [
                                Semantics(
                                  container: true,
                                  header: true,
                                  child: Text(
                                    'Ride History',
                                    style: CarriageTheme.subHeading,
                                  ),
                                ),
                                Spacer(),
                                ridesProvider.pastRides.isNotEmpty
                                    ? Semantics(
                                        container: true,
                                        button: true,
                                        child: GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        HistorySeeMore())),
                                            child: Row(children: [
                                              Text(
                                                'See More',
                                                style:
                                                    CarriageTheme.seeMoreStyle,
                                                semanticsLabel:
                                                    'See more past rides',
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.arrow_forward,
                                                  size: 16)
                                            ])),
                                      )
                                    : Container()
                              ]),
                            ),
                            SizedBox(height: 12),
                            RideHistory(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height / 8 + 36,
                            )
                          ],
                        )),
                      ])),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 8,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            offset: Offset(0, -2),
                            blurRadius: 11,
                            spreadRadius: 5,
                            color: Colors.black.withOpacity(0.11))
                      ]),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: ButtonTheme(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                                height: 50.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    rideFlowProvider.setLocControllers('', '');
                                    rideFlowProvider.setEditing(false);
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                RequestRideLoc(
                                                    ride: new Ride())));
                                  },
                                  elevation: 3.0,
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  icon: Icon(Icons.add),
                                  label: Text('Request Ride',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
