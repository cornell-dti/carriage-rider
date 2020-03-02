import 'package:flutter/material.dart';
import 'package:carriage_rider/Ride_History.dart';
import 'package:carriage_rider/Upcoming_Ride.dart';
import 'package:carriage_rider/Current_Ride.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subHeadingStyle = TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        fontSize: 20,
        height: 2
    );

    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(5.0),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey[500],
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey[500],
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Hi Aiden!', style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          //subheading Next Ride
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text('Next Ride', style: subHeadingStyle,
            ),
          ),
          CurrentRide(),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text('Upcoming Rides', style: subHeadingStyle,
            ),
          ),
          UpcomingRide(),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text('Ride History', style: subHeadingStyle,
            ),
          ),
          RideHistory(),
        ],
      ),
    );
  }
}