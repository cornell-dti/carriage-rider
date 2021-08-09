import 'dart:ui';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/RidePage.dart';
import 'package:carriage_rider/providers/NotificationsProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum NotifType {
  DRIVER_ARRIVED,
  DRIVER_ON_THE_WAY,
  DRIVER_LATE,
  DRIVER_CANCELLED,
  RIDE_EDITED,
  RIDE_CONFIRMED
}


String notifMessage(NotifType type, Ride ride, DateTime time) {
  switch (type) {
    case NotifType.DRIVER_ARRIVED:
      return 'Your driver is here! Meet your driver at the pickup point for ${ride.endLocation}.';
    case NotifType.DRIVER_ON_THE_WAY:
      return 'Your driver is on the way! Wait outside at the pickup point for ${ride.endLocation}.';
    case NotifType.DRIVER_LATE:
      return 'Your driver is running late but will meet you soon at the pickup point for ${ride.endLocation}.';
    case NotifType.DRIVER_CANCELLED:
      return 'Your driver cancelled your ride to ${ride.endLocation} because they were unable to find you.';
    case NotifType.RIDE_EDITED:
      return 'The information for your ride on ${DateFormat('MM/dd/yyyy').format(ride.startTime)} has been edited. Please review your ride info.';
    case NotifType.RIDE_CONFIRMED:
      return 'Your ride on ${DateFormat('MM/dd/yyyy').format(ride.startTime)} has been confirmed.';
    default:
      throw Exception('Invalid notification type for notifMessage');
  }
}

class DriverNotification extends StatelessWidget {
  DriverNotification(this.ride, this.notifTime, this.text);

  final Ride ride;
  final DateTime notifTime;
  final String text;

  @override
  Widget build(BuildContext context) {
    Widget driverImage = ride.driver != null
        ? ride.driver.profilePicture(48)
        : Image.asset('assets/images/person.png', width: 48, height: 48);
    return Notification(ride, notifTime, driverImage, 'Driver', text);
  }
}

class DispatcherNotification extends StatelessWidget {
  DispatcherNotification(
      this.ride, this.notifTime, this.text, this.color, this.iconData);

  final Ride ride;
  final DateTime notifTime;
  final String text;
  final Color color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    Widget icon = CircleAvatar(
        radius: 22,
        child: CircleAvatar(
          radius: 22,
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: Icon(iconData),
        ));
    return Notification(
        this.ride, this.notifTime, icon, 'Dispatcher', this.text);
  }
}

class Notification extends StatelessWidget {
  Notification(this.ride, this.notifTime, this.circularWidget, this.title, this.text);

  final Ride ride;
  final DateTime notifTime;
  final Widget circularWidget;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Duration timeSinceNotif = now.difference(notifTime);
    String time = '';

    bool timeWithin(Duration threshold) {
      return timeSinceNotif.compareTo(threshold) <= 0;
    }

    if (timeWithin(Duration(hours: 1))) {
      time = '${timeSinceNotif.inMinutes} min ago';
    } else if (timeWithin(Duration(days: 1))) {
      int hoursSince = timeSinceNotif.inHours;
      time = '$hoursSince hour${hoursSince == 1 ? '' : 's'} ago';
    } else if (timeWithin(Duration(days: 3))) {
      int daysSince = timeSinceNotif.inDays;
      time = '$daysSince day${daysSince == 1 ? '' : 's'} ago';
    } else {
      time = DateFormat('yMd').format(notifTime);
    }

    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RidePage(ride)));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            circularWidget,
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      time,
                      style:
                      TextStyle(fontSize: 11, color: CarriageTheme.gray2),
                    ),
                  ]),
                  SizedBox(height: 4),
                  Text(text,
                      style: TextStyle(fontSize: 15, color: Colors.black))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

NotifType typeFromNotifJson(Map<String, dynamic> json) {
  print('----Notifications typeFromNotifJson');
  String changedBy = json['changedBy']['userType'];
  Map<String, dynamic> ride = json['ride'];
  if (changedBy == 'Admin') {
    if (ride['driver'] != null) {
      return NotifType.RIDE_CONFIRMED;
    }
    else {
      return NotifType.RIDE_EDITED;
    }
  }
  else if (changedBy == 'Driver') {
    if (ride['late']) {
      return NotifType.DRIVER_LATE;
    }
    String status = ride['status'];
    print(status);
    if (status == 'on_the_way') {
      return NotifType.DRIVER_ON_THE_WAY;
    }
    else if (status == 'arrived') {
      return NotifType.DRIVER_ARRIVED;
    }
    else if (status == 'no_show') {
      return NotifType.DRIVER_CANCELLED;
    }
  }
  throw Exception('No notification type parsed from json in typeFromJson');
}

String rideIDFromNotifJson(Map<String, dynamic> json) {
  return json['ride']['id'];
}

class BackendNotification {
  BackendNotification(this.type, this.rideID, this.timeSent);

  final NotifType type;
  final DateTime timeSent;
  final String rideID;

  factory BackendNotification.fromJson(Map<String, dynamic> json) {
    print('----Notifications factory');
    print(json);
    String rideID = rideIDFromNotifJson(json);
    print('ride ID');
    print(rideID);
    NotifType type = typeFromNotifJson(json);
    print('type');
    print(type);
    return BackendNotification(type, rideID, DateTime.now());
  }

  String toString() => 'Notification $type: $rideID';
}

class NotificationsPage extends StatefulWidget {

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationsProvider notifsProvider = Provider.of<NotificationsProvider>(context, listen: false);
      notifsProvider.notifOpened();
    });
  }

  Widget buildNotification(NotifType type, Ride ride, DateTime time) {
    String message = notifMessage(type, ride, time);
    switch (type) {
      case NotifType.DRIVER_ARRIVED:
      case NotifType.DRIVER_ON_THE_WAY:
        return DriverNotification(ride, time, message);
      case NotifType.DRIVER_CANCELLED:
        return DispatcherNotification(ride, time, message, Colors.red, Icons.close);
      case NotifType.RIDE_EDITED:
        return DispatcherNotification(ride, time, message, Colors.red, Icons.edit);
      case NotifType.RIDE_CONFIRMED:
        return DispatcherNotification(ride, time, message, Colors.green, Icons.check);
      default:
        throw Exception('Notification could not be built: $type, ${ride.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    List<Ride> rides = ridesProvider.upcomingRides;
    if (ridesProvider.currentRide != null) {
      rides.add(ridesProvider.currentRide);
    }

    NotificationsProvider notifsProvider = Provider.of<NotificationsProvider>(context);
    List<BackendNotification> backendNotifs = notifsProvider.notifs;
    List<Widget> notifWidgets = [];

    backendNotifs.forEach((notif) {
      Ride ride = rides.firstWhere((ride) => ride.id == notif.rideID, orElse: () => null);
      if (ride != null) {
        notifWidgets.add(buildNotification(notif.type, ride, notif.timeSent));
      }
    });

    return Scaffold(
        appBar: ScheduleBar(
            Colors.black, Theme.of(context).scaffoldBackgroundColor),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 8.0),
                    child:
                    Text('Notifications', style: CarriageTheme.largeTitle),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: notifWidgets.reversed.toList(),
                  )
                ]
            ),
          ),
        )
    );
  }
}
