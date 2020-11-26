import 'package:carriage_rider/Ride.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:flutter/material.dart';

class Current extends StatefulWidget {
  Current(this.ride);

  final Ride ride;

  @override
  _CurrentState createState() => _CurrentState();
}

class _CurrentState extends State<Current> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Schedule',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'SFPro'),
          ),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  BackgroundHeader(
                      widget: Text("Current Ride",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.bold,
                          ))),
                  BackgroundHeader(
                    widget: SizedBox(height: 10),
                  ),
                  SizedBox(height: 20),
                  Contact(color: Colors.black),
                  SizedBox(height: 20),
                  TimeLine(widget.ride, true),
                  SizedBox(height: 20),
                  CustomDivider(),
                  SizedBox(height: 20),
                  RideAction(
                      text: "Cancel Ride",
                      color: Colors.red,
                      icon: Icons.clear),
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                ],
              ),
            )
          ],
        )));
  }
}

class BackgroundHeader extends StatelessWidget {
  const BackgroundHeader({Key key, this.widget}) : super(key: key);
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Expanded(
              child:
                  Padding(padding: EdgeInsets.only(left: 10), child: widget)),
        ],
      ),
    );
  }
}
