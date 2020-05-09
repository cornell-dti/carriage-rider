import 'package:flutter/material.dart';
import 'package:carriage_rider/Upcoming.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Schedule', style: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: 'SFPro')),
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
                    Header(header: 'Ride History'),
                    SizedBox(height: 10),
                    SubHeader(subHeader1: 'Ride Info' , subHeader2: 'Confirmed'),
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
                                  InformationRow(loc: 'Upson Hall', address: '124 Hoy Rd, Ithaca, NY 14850', action: 'Pickup Passenger 1', time: '3:15 PM'),
                                  SizedBox(height: 20),
                                  InformationRow(loc: 'Gates Hall', address: '107 Hoy Rd, Ithaca, NY 14853', action: 'Pickup Passenger 2', time: '3:20 PM'),
                                  SizedBox(height: 20),
                                  InformationRow(loc: 'Statler Hall', address: '109 Tower Rd, Ithaca, NY 14850', action: 'Dropoff Passenger 1', time: '3:25 PM'),
                                  SizedBox(height: 20),
                                  InformationRow(loc: 'Rhodes Hall', address: '109 Tower Rd, Ithaca, NY 14850', action: 'Dropoff Passenger 2', time: '4:20 PM'),
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
                    RideAction(rideAction: "Repeat Ride", color: Colors.black, icon: Icons.repeat),
                    SizedBox(height: MediaQuery.of(context).size.height/8),
                  ],
                )
              ],
            ),
            EditRide()
          ],
        )
    );
  }
}
