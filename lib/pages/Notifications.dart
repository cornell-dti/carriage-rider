import 'dart:ui';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/RidePage.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

DriverNotification driverArrivedNotif(Ride ride, DateTime notifTime) {
  return DriverNotification(ride, notifTime,
      'Your driver is here! Meet your driver at the pickup point for ${ride.endLocation}.');
}

DriverNotification driverOnTheWayNotif(Ride ride, DateTime notifTime) {
  return DriverNotification(ride, notifTime,
      'Your driver is on the way! Wait outside at the pickup point for ${ride.endLocation}.');
}

DispatcherNotification driverCancelledNotif(Ride ride, DateTime notifTime) {
  return DispatcherNotification(
      ride,
      notifTime,
      'Your driver cancelled the ride because they were unable to find you.',
      Colors.red,
      Icons.close);
}

DispatcherNotification rideEditedNotif(Ride ride, DateTime notifTime) {
  return DispatcherNotification(
      ride,
      notifTime,
      'The information for your ride on ${DateFormat('MM/dd/yyyy').format(ride.startTime)} has been edited. Please review your ride info.',
      Colors.red,
      Icons.edit);
}

DispatcherNotification rideConfirmedNotif(Ride ride, DateTime notifTime) {
  return DispatcherNotification(
      ride,
      notifTime,
      'Your ride on ${DateFormat('MM/dd/yyyy').format(ride.startTime)} has been confirmed.',
      Colors.green,
      Icons.check);
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
  Notification(
      this.ride, this.notifTime, this.circularWidget, this.title, this.text);

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

    return GestureDetector(
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

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key, this.rideId}) : super(key: key);

  final String rideId;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    Ride ride = new Ride();
    List<Ride> rides =
        Provider.of<RidesProvider>(context, listen: false).upcomingRides;
    if (widget.rideId != null) {
      ride = rides[rides.indexWhere((element) => element.id == widget.rideId)];
    }

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
                  Container(
                    color: Colors.white,
                    child: Column(children: [
                      driverArrivedNotif(
                          ride, DateTime.now().subtract(Duration(days: 1))),
                    ]),
                  )
                ]),
          ),
        ));
  }
}
