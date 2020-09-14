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

                  ],
                )
              ],
            ),

          ],
        )
    );
  }
}

