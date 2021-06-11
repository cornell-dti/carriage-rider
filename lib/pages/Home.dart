import 'dart:async';
import 'dart:io';
import 'package:carriage_rider/providers/NotificationsProvider.dart';
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
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/widgets/CurrentRideCard.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Ride_History.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/semantics.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/pages/Contact.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'Upcoming.dart';

void main() {
  MaterialApp(routes: {
    '/': (context) => Home(),
  });
}

class HomeHeader extends StatefulWidget {
  final ScrollController homeScrollCtrl;
  final double height;
  final Function refreshCallback;

  HomeHeader(this.homeScrollCtrl, this.height, this.refreshCallback);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool scrollAtTop;

  @override
  void initState() {
    super.initState();
    scrollAtTop = true;
    widget.homeScrollCtrl.addListener(() {
      setState(() {
        scrollAtTop = widget.homeScrollCtrl.position.pixels == 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    NotificationsProvider notifsProvider = Provider.of<NotificationsProvider>(context, listen: false);

    double iconButtonSize = 48;
    double iconButtonSpacing = 8;
    double horizPadding = 16;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: scrollAtTop
              ? []
              : [
            BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 11,
                color: Colors.black.withOpacity(0.15))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                sortKey: OrdinalSortKey(0),
                header: true,
                label: 'Hi ' + riderProvider.info.firstName,
                child: Container(
                  width: MediaQuery.of(context).size.width -
                      (2 * iconButtonSize) -
                      (2 * horizPadding) -
                      iconButtonSpacing,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: EdgeInsets.only(left: horizPadding, right: 16),
                      child: ExcludeSemantics(
                        child: Text(
                          'Hi ${riderProvider.info.firstName}!',
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
              Semantics(
                  button: true,
                  sortKey: OrdinalSortKey(1),
                  label: 'Refresh rides',
                  child: Container(
                    width: iconButtonSize,
                    height: iconButtonSize,
                    child: Material(
                      child: InkWell(
                          onTap: () async => widget.refreshCallback(),
                          customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(Icons.refresh, color: Colors.black)),
                    ),
                  )),
              SizedBox(width: iconButtonSpacing),
              Padding(
                padding: EdgeInsets.only(right: horizPadding),
                child: Semantics(
                    button: true,
                    sortKey: OrdinalSortKey(2),
                    label: 'Menu',
                    child: Container(
                      width: iconButtonSize,
                      height: iconButtonSize,
                      child: Material(
                        child: InkWell(
                            onTap: () {
                              Scaffold.of(context).openEndDrawer();
                              SemanticsService.announce(
                                  'Swipe right to close drawer',
                                  TextDirection.ltr);
                            },
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            child: notifsProvider.hasNewNotif ? Stack(children: [
                              Center(child: Icon(Icons.menu, color: Colors.black)),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                      width: 9,
                                      height: 9,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(100),
                                      )))
                            ]) : Icon(Icons.menu, color: Colors.black)),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  StreamSubscription iosSubscription; // ignore: cancel_subscriptions
  String deviceToken;

  final ScrollController scrollCtrl = ScrollController();
  bool fetchingRides = false;

  @override
  void initState() {
    super.initState();
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings(
        //onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification
    );
    initialize();
    initFirebaseNotifs();
  }

  // flutter local notifs callback when selecting a background notification
  Future<void> onSelectNotification(String payload) async {
    print('onSelectNotification payload: ' + payload);
    Map<String, dynamic> json = jsonDecode(payload);
    Map<String, dynamic> rideJson = jsonDecode(payload)['ride'];
    print(jsonEncode(rideJson));
    Ride ride = Ride.fromJsonLocationIDs(rideJson, context);
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
    ridesProvider.updateRideByID(ride);
    NotificationsProvider notifsProvider = Provider.of<NotificationsProvider>(context, listen: false);
    notifsProvider.addNewNotif(BackendNotification.fromJson(json));
    print(BackendNotification.fromJson(json));
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
  }
//
//  static Future<void> onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
//    print('onDidReceive: id $id, title $title, body $body, payload $payload');
//    //addNotif(BackendNotification.fromJson(jsonDecode(payload)));
//    //Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
//  }

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
  static void showNotification(String message, String payload) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    await getAndroidNotificationDetails(message);
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print('showNotification payload: ' + payload);
    await notificationsPlugin.show(
      0,
      'Carriage Rider',
      message,
      platformChannelSpecifics,
      payload: payload
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
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation('')
    );
  }

  void initFirebaseNotifs() {
    _fcm.configure(
        onBackgroundMessage: Platform.isIOS ? null : backgroundHandle,
        onMessage: onForegroundNotif,
        onLaunch: onNotifPressed,
        onResume: onNotifPressed
    );
  }

  Future<void> onForegroundNotif(Map<String, dynamic> message) async {
    print('onForegroundNotif');
    String data = Platform.isIOS ? message['default'] : message['data']['default'];
    Map<String, dynamic> json = jsonDecode(data);
    Map<String, dynamic> rideJson = json['ride'];
    Ride ride = Ride.fromJsonLocationIDs(rideJson, context);
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
    ridesProvider.updateRideByID(ride);
    NotificationsProvider notifsProvider = Provider.of<NotificationsProvider>(context, listen: false);
    notifsProvider.addNewNotif(BackendNotification.fromJson(json));
  }

  Future<void> onNotifPressed(Map<String, dynamic> message) async {
    print('notifPressed');
    Map<String, dynamic> json = jsonDecode(Platform.isIOS ? message['default'] : message['data']['default']);
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
    ridesProvider.updateRideByID(Ride.fromJson(json['ride']));
    NotificationsProvider notifsProvider = Provider.of<NotificationsProvider>(context, listen: false);
    notifsProvider.addNewNotif(BackendNotification.fromJson(json));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotificationsPage())
    );
  }

  static Future<dynamic> backgroundHandle(Map<String, dynamic> message) async {
    print('backgroundHandle');
    print(message);
    if (message.containsKey('data')) {
      // Handle data message
      Map<String, dynamic> json = jsonDecode(Platform.isIOS ? message['default'] : message['data']['default']);
      NotifType type = typeFromNotifJson(json);

      String notifMessage;
      switch (type) {
        case NotifType.DRIVER_ARRIVED:
          notifMessage = 'Your driver is here! Meet your driver at the pickup point.';
          break;
        case NotifType.DRIVER_ON_THE_WAY:
          notifMessage = 'Your driver is on the way! Wait outside at the pickup point.';
          break;
        case NotifType.DRIVER_CANCELLED:
          notifMessage = 'Your driver cancelled your ride because they were unable to find you.';
          break;
        case NotifType.RIDE_EDITED:
          notifMessage = 'The information for one of your rides has been edited. Please review your ride info.';
          break;
        case NotifType.RIDE_CONFIRMED:
          notifMessage = 'One of your rides has been confirmed.';
          break;
        default:
          throw Exception('Invalid notification type for notifMessage');
      }
      showNotification(notifMessage, jsonEncode(json));
    }
    return Future<void>.value();
  }

  subscribe(String token) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
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
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    NotificationsProvider notifsProvider = Provider.of<NotificationsProvider>(context);
    AppConfig appConfig = AppConfig.of(context);
    double headerHeight = 100;

    Widget sideBarText(String text, Color color) {
      return Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontFamily: 'SFPro'),
      );
    }

    Future<void> refresh() async {
      SemanticsService.announce('Refreshing rides', TextDirection.ltr);
      await ridesProvider.fetchAllRides(appConfig, authProvider);
      SemanticsService.announce('Done refreshing rides', TextDirection.ltr);
    }

    void refreshShowLoading() async {
      setState(() {
        fetchingRides = true;
      });
      await refresh();
      setState(() {
        fetchingRides = false;
      });
    }

    Widget buildPage() {
      return LoadingOverlay(
        color: Colors.white,
        isLoading: fetchingRides,
        child: Stack(children: [
          SingleChildScrollView(
            controller: scrollCtrl,
            child: Column(
              children: [
                SizedBox(height: headerHeight),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          container: true,
                          header: true,
                          sortKey: OrdinalSortKey(3),
                          child: Text(
                            'Current Ride',
                            style: CarriageTheme.subHeading,
                          ),
                        ),
                        SizedBox(height: 12),
                        Semantics(
                          sortKey: OrdinalSortKey(4),
                          child: CurrentRideCard(ridesProvider.currentRide,
                              showCallDriver: true),
                        ),
                      ]),
                ),
                SizedBox(height: 35),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Semantics(
                              sortKey: OrdinalSortKey(5),
                              container: true,
                              header: true,
                              child: Text(
                                'Upcoming Rides',
                                style: CarriageTheme.subHeading,
                              ),
                            ),
                          ],
                        ),
                        ridesProvider.upcomingRides.isNotEmpty
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Semantics(
                              sortKey: OrdinalSortKey(6),
                              button: true,
                              container: true,
                              child: Container(
                                height: 48,
                                child: InkWell(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (context) =>
                                            UpcomingSeeMore())),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8),
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
                                      ]),
                                    )),
                              ),
                            ),
                          ],
                        )
                            : Container()
                      ]),
                ),
                Semantics(sortKey: OrdinalSortKey(7), child: UpcomingRides()),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Semantics(
                              sortKey: OrdinalSortKey(8),
                              container: true,
                              header: true,
                              child: Text(
                                'Ride History',
                                style: CarriageTheme.subHeading,
                              ),
                            ),
                          ],
                        ),
                        ridesProvider.pastRides.isNotEmpty
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Semantics(
                              sortKey: OrdinalSortKey(9),
                              container: true,
                              button: true,
                              child: Container(
                                height: 48,
                                child: InkWell(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (context) =>
                                            HistorySeeMore())),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8),
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
                                      ]),
                                    )),
                              ),
                            ),
                          ],
                        )
                            : Container()
                      ]),
                ),
                SizedBox(height: 12),
                Semantics(sortKey: OrdinalSortKey(10), child: RideHistory()),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 8 + 36,
                )
              ],
            ),
          ),
          Semantics(
              sortKey: OrdinalSortKey(0),
              child: HomeHeader(scrollCtrl, headerHeight, refreshShowLoading))
        ]),
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
                leading: notifsProvider.hasNewNotif
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
            buildPage(),
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
                    Semantics(
                      button: true,
                      sortKey: OrdinalSortKey(11),
                      child: Align(
                          alignment: Alignment.center,
                          child: ButtonTheme(
                            minWidth:
                            MediaQuery.of(context).size.width * 0.8,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: RaisedButton.icon(
                              onPressed: () {
                                rideFlowProvider.setLocControllers(
                                    '', '');
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
                    ),
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
