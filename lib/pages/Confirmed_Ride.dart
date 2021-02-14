import 'package:carriage_rider/pages/Upcoming.dart';
import 'package:flutter/material.dart';

class ConfirmedRide extends StatefulWidget {
  @override
  _ConfirmedRideState createState() => _ConfirmedRideState();
}

class _ConfirmedRideState extends State<ConfirmedRide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  PageTitle(title: 'Schedule'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Header(header: 'OCT 18th 12:00 PM'),
                    SizedBox(height: 5),
                    SubHeader(subHeader1: 'Ride Info', subHeader2: 'Confirmed'),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          TimeLine(),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  InformationRow(
                                      loc: 'Upson Hall',
                                      address: '109 Tower Rd, Ithaca, NY 14850',
                                      action: 'Pickup',
                                      time: '3:15 PM'),
                                  SizedBox(height: 20),
                                  InformationRow(
                                      loc: 'Gates Hall',
                                      address: '107 Hoy Rd, Ithaca, NY 14850',
                                      action: 'Dropoff',
                                      time: '3:20 PM'),
                                  SizedBox(height: 20)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20)
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    CustomDivider(),
                    SizedBox(height: 15),
                    Contact(),
                    SizedBox(height: 15),
                    CustomDivider(),
                    SizedBox(height: 20),
                    RideAction(
                        text: "Cancel Ride",
                        color: Colors.red,
                        icon: Icons.clear),
                    SizedBox(height: MediaQuery.of(context).size.height / 8),
                  ],
                )
              ],
            ),
            EditRide()
          ],
        ));
  }
}

class TimeLine extends StatelessWidget {
  const TimeLine({Key key}) : super(key: key);

  Widget locationCircle() {
    return Container(
      width: 18,
      height: 18,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: new Border.all(
            color: Colors.white, width: 6.0, style: BorderStyle.solid),
        boxShadow: [
          new BoxShadow(
            color: Colors.grey[900],
            blurRadius: 5.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(left: 6),
                        width: 4,
                        height: 80,
                        color: Colors.black,
                      ),
                      locationCircle(),
                      Positioned(
                        top: 60,
                        child: locationCircle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
