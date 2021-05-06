import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
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
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription; // ignore: cancel_subscriptions
  int _totalNotifications;
  String deviceToken;

  @override
  void initState() {
    _totalNotifications = 0;
    initialize();
    getMessage();
    super.initState();
  }

  _registerOnFirebase() async {
    _fcm.subscribeToTopic('all');
    await _fcm.getToken().then((token) => deviceToken = token);
    if (deviceToken != null) {
     subscribe(deviceToken);
    }
    _fcm.onTokenRefresh.listen((newToken) {
      subscribe(newToken);
    });
  }

  static Future<dynamic> backgroundHandle(
    Map<String, dynamic> message,
  ) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: $data");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: $notification");
    }
    return Future<void>.value();
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

  subscribe(String token) async {
    print(token);
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
        'platform': 'android',
        'token': token,
      }),
    );
    if (response.statusCode != 200) {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to subscribe.');
    }
  }

  void getMessage() async {
    PushNotificationMessageAndroid androidNotification;
    PushNotificationMessageIOS iosNotification;

    _fcm.configure(
      onBackgroundMessage: backgroundHandle,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        }
        if (Platform.isIOS) {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        print(androidNotification.title);
        showSimpleNotification(
          Text(Platform.isIOS
              ? iosNotification.title
              : androidNotification.title),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(
              Platform.isIOS ? iosNotification.body : androidNotification.body),
          background: Colors.cyan[700],
          duration: Duration(seconds: 5),
        );

        setState(() {
          _totalNotifications++;
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        }
        if (Platform.isIOS) {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => Notifications()));
        setState(() {
          _totalNotifications++;
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        }
        if (Platform.isIOS) {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => Notifications()));
        setState(() {
          _totalNotifications++;
        });
      },
    );
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
                leading: Icon(Icons.notifications, color: Colors.black),
                title: sideBarText('Notifications', Colors.black),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Notifications()));
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
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 23),
                                    child: Builder(builder: (context) {
                                      return Semantics(
                                        label: 'Menu',
                                        child: IconButton(
                                            icon: Icon(Icons.menu,
                                                color: Colors.black),
                                            onPressed: () =>
                                                Scaffold.of(context)
                                                    .openEndDrawer()),
                                      );
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
