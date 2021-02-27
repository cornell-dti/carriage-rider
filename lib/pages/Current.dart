import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/Upcoming.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Map days = {
  0: 'Sun.',
  1: 'Mon.',
  2: 'Tue.',
  3: 'Wed.',
  4: 'Thurs.',
  5: 'Fri.',
  6: 'Sat.'
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
          titleSpacing: 0.0,
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
                      widget: Text('Current Ride',
                          style: TextStyle(
                              fontFamily: 'SFDisplay',
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.37,
                              color: Colors.white))),
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
                  widget.ride.recurring
                      ? RecurringRide(widget.ride)
                      : NoRecurringRide(),
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
    return Container(child: NoRecurringText());
  }
}

class NoRecurringText extends StatelessWidget {
  const NoRecurringText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'This is not a repeating ride.',
                  style: TextStyle(
                      color: grey, fontWeight: FontWeight.bold, fontSize: 15),
                ))),
      ],
    );
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
    String repeatedDays = 'Every ';
    String recurringDays = '';
    days.forEach((k, v) {
      if (widget.ride.recurringDays.contains(k)) {
        repeatedDays += v + ' and ';
      }
    });
    recurringDays = repeatedDays.substring(0, repeatedDays.length - 4);

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              StartDate(ride: widget.ride),
              SizedBox(
                width: 20,
              ),
              DateDivider(),
              SizedBox(
                width: 20,
              ),
              EndDate(ride: widget.ride)
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

class DateDivider extends StatelessWidget {
  const DateDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(' ', style: TextStyle(color: Colors.black, fontSize: 14)),
        Text(
          '~',
          style: TextStyle(color: Colors.black, fontSize: 20),
        )
      ],
    );
  }
}

class StartDate extends StatelessWidget {
  const StartDate({Key key, this.ride}) : super(key: key);
  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'From',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              DateFormat('M').format(ride.startTime) +
                  '/' +
                  DateFormat('d').format(ride.startTime) +
                  '/' +
                  DateFormat('y').format(ride.startTime),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

class EndDate extends StatelessWidget {
  const EndDate({Key key, this.ride}) : super(key: key);
  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('To',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Text(
            DateFormat('M').format(ride.endDate) +
                '/' +
                DateFormat('d').format(ride.endDate) +
                '/' +
                DateFormat('y').format(ride.endDate),
            style: TextStyle(color: Colors.black, fontSize: 16),
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
              child: Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 5.0),
                  child: widget)),
        ],
      ),
    );
  }
}
