import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/Current.dart';
import 'package:carriage_rider/History.dart';
import 'package:carriage_rider/Notifications.dart';
import 'package:carriage_rider/Profile.dart';
import 'package:carriage_rider/Request_Ride_Loc.dart';
import 'package:carriage_rider/Settings.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/Ride_History.dart';
import 'package:carriage_rider/Upcoming_Ride.dart';
import 'package:carriage_rider/Current_Ride.dart';
import 'package:provider/provider.dart';

void main() {
  MaterialApp(routes: {
    '/': (context) => Home(),
  });
}

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);
    final String headerName = "Hi " +
        authProvider.googleSignIn.currentUser.displayName.split(" ")[0] +
        "!";
    final subHeadingStyle = TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        fontSize: 20,
        height: 2);

    Widget sideBarText(String text, Color color) {
      return Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: color,
            fontFamily: 'SFPro'),
      );
    }

    return Scaffold(
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.all(5.0),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person, color: Colors.black),
                title: sideBarText("Profile", Colors.black),
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
                title:  sideBarText("Settings", Colors.black),
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
                title: sideBarText("Notifications", Colors.black),
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
                leading: Icon(Icons.directions_car, color: Colors.black),
                title: sideBarText("Current Ride", Colors.black),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Current()));
                },
              ),
              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                leading: Icon(Icons.trending_up, color: Colors.black),
                title: sideBarText("Upcoming Ride", Colors.black),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Upcoming()));
                },
              ),
              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                leading: Icon(Icons.history, color: Colors.black),
                title: sideBarText("Ride History", Colors.black),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => History()));
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            headerName,
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontFamily: 'SFPro'),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 8,
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 8,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          height: 45.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          child: RaisedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => RequestRideLoc()));
                            },
                            elevation: 3.0,
                            color: Colors.black,
                            textColor: Colors.white,
                            icon: Icon(Icons.add),
                            label: Text('Request Ride',
                            style: TextStyle(
                              fontSize: 18
                            )),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
