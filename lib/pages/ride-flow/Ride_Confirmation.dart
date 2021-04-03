import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RideConfirmation extends StatefulWidget {
  @override
  _RideConfirmationState createState() => _RideConfirmationState();
}

class _RideConfirmationState extends State<RideConfirmation> {
  final requestStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 17,
  );

  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Image(image: AssetImage('assets/images/RequestInProgress.png')),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Your request is in progress!', style: requestStyle)
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You\'ll be notified via in-app notification',
                  style: CarriageTheme.descriptionStyle)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('and email when your ride is confirmed',
                  style: CarriageTheme.descriptionStyle)
            ],
          ),
        ],
      ),
    );
  }
}
