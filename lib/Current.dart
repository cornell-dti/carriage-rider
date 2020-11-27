import 'package:carriage_rider/Ride.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:flutter/material.dart';

Map days = {
  0: 'Sunday',
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday'
};

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
                  SizedBox(height: 40),
                  TimeLine(widget.ride, true),
                  SizedBox(height: 30),
                  CustomDivider(),
                  SizedBox(height: 20),
                  widget.ride.recurring ? RecurringRide(widget.ride) : NoRecurringRide(),
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                ],
              ),
            )
          ],
        )));
  }
}

class NoRecurringRide extends StatelessWidget {
  const NoRecurringRide({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "This is not a repeating ride.",
                  style: TextStyle(
                      color: grey, fontWeight: FontWeight.bold, fontSize: 15),
                ))),
      ],
    ));
  }
}

class RecurringRide extends StatefulWidget {
  RecurringRide(this.ride);
  final Ride ride;

  @override
  _RecurringRideState createState() => _RecurringRideState();
}

class _RecurringRideState extends State<RecurringRide> {

  @override
  Widget build(BuildContext context) {
    String repeatedDays = "";
    String recurringDays = "";
    days.forEach((k, v) {
      if (widget.ride.recurringDays.contains(k)) {
        repeatedDays += v + ", ";
      }
    });
    recurringDays = repeatedDays.substring(0, repeatedDays.length - 2);

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'From',
                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      '02/16/2020',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(' ', style: TextStyle(color: Colors.black, fontSize: 14)),
                  Text(
                    '~',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('To', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(
                    '05/16/2020',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  recurringDays,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          )
        ],
      ),
    );
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
