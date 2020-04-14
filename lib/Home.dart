import 'package:carriage_rider/Notifications.dart';
import 'package:carriage_rider/Profile.dart';
import 'package:carriage_rider/Settings.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/Ride_History.dart';
import 'package:carriage_rider/Upcoming_Ride.dart';
import 'package:carriage_rider/Current_Ride.dart';
import 'package:carriage_rider/Login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String headerName = "Hi " + name.split(" ")[0] + "!";
    final subHeadingStyle = TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        fontSize: 20,
        height: 2);

    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(5.0),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            Divider(
              color: Colors.grey[500],
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
            Divider(
              color: Colors.grey[500],
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => Notifications()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          headerName,
          style:
              TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'SFPro'),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text(
              'Next Ride',
              style: subHeadingStyle,
            ),
          ),
          CurrentRide(),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text(
              'Upcoming Rides',
              style: subHeadingStyle,
            ),
          ),
          UpcomingRide(),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text(
              'Ride History',
              style: subHeadingStyle,
            ),
          ),
          RideHistory(),
        ],
      ),
    );
  }
}
