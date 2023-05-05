import 'dart:async';
import 'dart:io';
import 'package:carriage_rider/providers/NotificationsProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:carriage_rider/pages/ride-flow/Request_Ride_Loc.dart';
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
import 'package:carriage_rider/models/Ride.dart';
import 'Upcoming.dart';

void main() async {
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
    NotificationsProvider notifsProvider =
        Provider.of<NotificationsProvider>(context, listen: true);

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
                label: 'Hi ',
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
                              fontFamily: 'Inter',
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
                            child: notifsProvider.hasNewNotif
                                ? Stack(children: [
                                    Center(
                                        child: Icon(Icons.menu,
                                            color: Colors.black)),
                                    Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                            width: 9,
                                            height: 9,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            )))
                                  ])
                                : Icon(Icons.menu, color: Colors.black)),
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
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin notificationsPlugin;
  NotificationSettings notifSettings;
  String deviceToken;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final ScrollController scrollCtrl = ScrollController();
  bool fetchingRides = false;

  @override
  void initState() {
    _initNotifications();
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    super.initState();
  }

  subscribe(String token) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authToken = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      Uri.parse("${AppConfig.of(context).baseUrl}/notification/subscribe"),
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

  _initNotifications() async {
    await _fcm.getToken().then((token) => deviceToken = token);

    if (deviceToken != null) {
      print(deviceToken);
      subscribe(deviceToken);
    }

    _fcm.onTokenRefresh.listen((newToken) {
      subscribe(newToken);
    });

    notifSettings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    notificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  _handleNotification(RemoteNotification notification, String notifId,
      Map<String, dynamic> data) async {
    RidesProvider ridesProvider =
        Provider.of<RidesProvider>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    AppConfig appConfig = AppConfig.of(context);
    NotifEvent notifEvent = getNotifEventEnum(data['notifEvent']);
    Ride ride;
    if (notifEvent != NotifEvent.RIDE_CANCELLED) {
      ride = Ride.fromJson(json.decode(data['ride']));
      try {
        // Check if ride exists
        ridesProvider.getRideByID(ride.id);
      } catch (Exception) {
        // Get most up to date rides from server
        await ridesProvider.fetchAllRides(appConfig, authProvider);
      } finally {
        // Update ride with new information
        ridesProvider.updateRideByID(ride);
      }
    } else {
      // Updating from server will remove cancelled ride
      await ridesProvider.fetchAllRides(appConfig, authProvider);
    }

    NotificationsProvider notifsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    BackendNotification backendNotif = BackendNotification(
        notifId,
        getNotifEventEnum(data['notifEvent']),
        notification.body,
        ride?.id,
        DateTime.parse(data['sentTime']));
    notifsProvider.addNewNotif(backendNotif);
  }

  _onMessage(RemoteMessage message) async {
    Map<String, dynamic> data = message.data;
    String notifId = data['id'];
    print('received message $notifId');

    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    if (notification != null) {
      _handleNotification(notification, notifId, data);
      if (android != null) {
        notificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    }
  }

  _onMessageOpenedApp(RemoteMessage message) async {
    Map<String, dynamic> data = message.data;
    String notifId = data['id'];
    print('app launched from message $notifId');

    RemoteNotification notification = message.notification;

    if (notification != null) {
      _handleNotification(notification, notifId, data);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Notifications()));
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
    double headerHeight = 100;

    Widget sideBarText(String text, Color color) {
      return Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontFamily: 'Inter'),
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
                SizedBox(height: 12),
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

    Widget createDrawerOption(
        BuildContext context, IconData icon, String text, Widget page) {
      return Semantics(
        button: true,
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: sideBarText(text, Colors.black),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(5.0),
            children: <Widget>[
              createDrawerOption(context, Icons.person, 'Profile', Profile()),
              Divider(
                color: Colors.grey[500],
              ),
              createDrawerOption(context, Icons.notifications, 'Notifications',
                  Notifications()),
              Divider(
                color: Colors.grey[500],
              ),
              createDrawerOption(
                  context, Icons.help_outline, 'Contact', Contact()),
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
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    rideFlowProvider.clear();
                                    rideFlowProvider.setCreating();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RequestRideLoc()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3.0,
                                    onPrimary: Colors.white,
                                    primary: Colors.black,
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width * 0.8,
                                        50.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
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
