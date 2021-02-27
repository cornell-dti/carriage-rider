import 'package:carriage_rider/Request_Ride_Loc.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/Confirmed_Ride.dart';
import 'package:carriage_rider/Current.dart';
import 'package:carriage_rider/History.dart';
import 'package:carriage_rider/Notifications.dart';
import 'package:carriage_rider/Profile.dart';
import 'package:carriage_rider/Ride.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/Ride_History.dart';
import 'package:carriage_rider/Current_Ride.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/Settings.dart';
import 'package:carriage_rider/Help.dart';

void main() {
  MaterialApp(routes: {
    '/': (context) => Home(),
  });
}

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(context) {
    //TODO: change to get name from rider provider
    AuthProvider authProvider = Provider.of(context);
    final String headerName = "Hi " +
        authProvider.googleSignIn.currentUser.displayName.split(" ")[0] +
        "! ☀";

    final subHeadingStyle = TextStyle(
        color: Colors.grey[700], fontWeight: FontWeight.w700, fontSize: 20);

    final seeMoreStyle = TextStyle(fontSize: 14, color: Color(0xFF181818));

    Widget sideBarText(String text, Color color) {
      return Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontFamily: 'SFPro'),
      );
    }

    return Scaffold(
        endDrawer: SafeArea(
          child: Drawer(
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
                  title: sideBarText("Settings", Colors.black),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Settings()));
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
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Current(Ride(
                                type: 'active',
                                startLocation: 'Uris Hall',
                                startAddress:
                                    '100 Carriage Way, Ithaca, NY 14850',
                                endLocation: 'Cascadilla Hall',
                                endAddress: '101 DTI St, Ithaca, NY 14850',
                                startTime: DateTime(2020, 10, 18, 13, 0),
                                endTime: DateTime(2020, 10, 18, 13, 15),
                                endDate: DateTime(2020, 12, 10),
                                recurring: true,
                                recurringDays: [0, 3, 4]))));
                  },
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                ListTile(
                  leading: Icon(Icons.trending_up, color: Colors.black),
                  title: sideBarText("Upcoming Ride", Colors.black),
                  onTap: () {
                    Navigator.push(
                        context,
                        //TODO: remove temporary ride
                        new MaterialPageRoute(
                            builder: (context) => UpcomingRidePage(Ride(
                                  type: 'active',
                                  startLocation: 'Uris Hall',
                                  startAddress:
                                      '100 Carriage Way, Ithaca, NY 14850',
                                  endLocation: 'Cascadilla Hall',
                                  endAddress: '101 DTI St, Ithaca, NY 14850',
                                  startTime: DateTime(2020, 10, 18, 13, 0),
                                  endTime: DateTime(2020, 10, 18, 13, 15),
                                ))));
                  },
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Colors.black),
                  title: sideBarText("Ride History", Colors.black),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => History(Ride(
                                type: 'active',
                                startLocation: 'Uris Hall',
                                startAddress:
                                    '100 Carriage Way, Ithaca, NY 14850',
                                endLocation: 'Cascadilla Hall',
                                endAddress: '101 DTI St, Ithaca, NY 14850',
                                startTime: DateTime(2020, 10, 18, 13, 0),
                                endTime: DateTime(2020, 10, 18, 13, 15),
                                endDate: DateTime(2020, 12, 10),
                                recurring: false,
                                recurringDays: [0, 3, 4]))));
                  },
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                ListTile(
                  leading: Icon(Icons.check, color: Colors.black),
                  title: sideBarText("Confirmed Ride", Colors.black),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ConfirmedRide()));
                  },
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                ListTile(
                  leading: Icon(Icons.help_outline, color: Colors.black),
                  title: sideBarText('Help', Colors.black),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => Help()));
                  },
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              CustomScrollView(slivers: [
                SliverAppBar(
                  elevation: 11,
                  pinned: true,
                  expandedHeight: 100,
                  collapsedHeight: 100,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                  icon: Icon(Icons.menu, color: Colors.black),
                                  onPressed: () =>
                                      Scaffold.of(context).openEndDrawer());
                            }),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                    [
                      Text(
                        'Current Ride',
                        style: subHeadingStyle,
                      ),
                      SizedBox(height: 12),
                      CurrentRide(),
                      SizedBox(height: 35),
                      Row(children: [
                        Text(
                          'Upcoming Rides',
                          style: subHeadingStyle,
                        ),
                        Spacer(),
                        Text('See More', style: seeMoreStyle),
                        Icon(Icons.arrow_forward, size: 16)
                      ]),
                      SizedBox(height: 12),
                      Container(height: 225, child: UpcomingRide()),
                      SizedBox(height: 35),
                      Row(children: [
                        Text(
                          'Ride History',
                          style: subHeadingStyle,
                        ),
                        Spacer(),
                        Text('See More', style: seeMoreStyle),
                        Icon(Icons.arrow_forward, size: 16)
                      ]),
                      RideHistory(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 8,
                      )
                    ],
                  )),
                ),
              ]),
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
                                        builder: (context) =>
                                            RequestRideLoc()));
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
        ));
  }
}
