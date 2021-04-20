import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:carriage_rider/pages/ride-flow/Request_Ride_Loc.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/pages/Notifications.dart';
import 'package:carriage_rider/pages/Profile.dart';
import 'package:carriage_rider/utils/NotificationService.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/widgets/CurrentRideCard.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Ride_History.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/pages/Settings.dart';
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

  @override
  void initState() {
    _totalNotifications = 0;
    initialize();
    getMessage();
    super.initState();
  }

  _registerOnFirebase() async {
    _fcm.subscribeToTopic('all');
    await _fcm.getToken().then((token) => print(token));
  }

  static Future<dynamic> backgroundHandle(
    Map<String, dynamic> message,
  ) {
    print('onBackgroundMessage received: $message');
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

  void getMessage() async {
    PushNotificationMessageAndroid androidNotification;
    PushNotificationMessageIOS iosNotification;

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (Platform.isAndroid) {
          androidNotification =
              PushNotificationMessageAndroid.fromJson(message);
        }
        if (Platform.isIOS) {
          iosNotification = PushNotificationMessageIOS.fromJson(message);
        }
        showSimpleNotification(
          Text(Platform.isIOS
              ? iosNotification.title
              : androidNotification.title),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(
              Platform.isIOS ? iosNotification.body : androidNotification.body),
          background: Colors.cyan[700],
          duration: Duration(seconds: 2),
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
        setState(() {
          _totalNotifications++;
        });
      },
    );
  }

  @override
  Widget build(context) {
    //TODO: change to get name from rider provider
    AuthProvider authProvider = Provider.of(context);
    final String headerName = 'Hi ' +
        authProvider.googleSignIn.currentUser.displayName.split(' ')[0] +
        '! ☀';

    Widget sideBarText(String text, Color color) {
      return Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontFamily: 'SFPro'),
      );
    }

    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    AppConfig appConfig = AppConfig.of(context);

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
                leading: Icon(Icons.settings, color: Colors.black),
                title: sideBarText('Settings', Colors.black),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Settings()));
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
        child: !ridesProvider.hasData()
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  RefreshIndicator(
                      onRefresh: () async {
                        await ridesProvider.fetchAllRides(
                            appConfig, authProvider);
                      },
                      child: CustomScrollView(slivers: [
                        SliverAppBar(
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 23),
                                    child: Text(
                                      headerName,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 23),
                                    child: Builder(builder: (context) {
                                      return IconButton(
                                          icon: Icon(Icons.menu,
                                              color: Colors.black),
                                          onPressed: () => Scaffold.of(context)
                                              .openEndDrawer());
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
                                Text(
                                  'Upcoming Rides',
                                  style: CarriageTheme.subHeading,
                                ),
                                Spacer(),
                                ridesProvider.upcomingRides.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpcomingSeeMore())),
                                        child: Row(children: [
                                          Text('See More',
                                              style:
                                                  CarriageTheme.seeMoreStyle),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_forward, size: 16)
                                        ]))
                                    : Container()
                              ]),
                            ),
                            SizedBox(height: 12),
                            UpcomingRides(),
                            SizedBox(height: 36),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(children: [
                                Text(
                                  'Ride History',
                                  style: CarriageTheme.subHeading,
                                ),
                                Spacer(),
                                ridesProvider.pastRides.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HistorySeeMore())),
                                        child: Row(children: [
                                          Text('See More',
                                              style:
                                                  CarriageTheme.seeMoreStyle),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_forward, size: 16)
                                        ]))
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: RaisedButton.icon(
                                  onPressed: () {
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
