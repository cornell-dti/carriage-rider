import 'package:carriage_rider/models/Ride.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:intl/intl.dart';
import 'package:carriage_rider/pages/Upcoming.dart';

Map days = {
  1: 'M',
  2: 'T',
  3: 'W',
  4: 'Th',
  5: 'F',
};

class OccurrenceTitle extends StatelessWidget {
  const OccurrenceTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 20, bottom: 15),
          child: Text(
            'Occurrence',
            style: CarriageTheme.title2,
          ),
        ),
      ),
    ]);
  }
}

class NoRecurringRide extends StatefulWidget {
  NoRecurringRide(this.ride);

  final Ride ride;

  @override
  _NoRecurringRideState createState() => _NoRecurringRideState();
}

class _NoRecurringRideState extends State<NoRecurringRide> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        OccurrenceTitle(),
        NoRecurringText(),
        SizedBox(height: 20),
        RideAction(
            text: 'Repeat Ride', color: Colors.black, icon: Icons.repeat),
      ],
    ));
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
  String recurringRides(List<String> days) {
    String repeatedDays = 'Repeats every ';
    String display = '';
    if (days.length == 1) {
      display = days.first;
    } else if (days.length == 2) {
      display = repeatedDays + days.join(' and ');
    } else {
      List<String> newDays = days.sublist(0, days.length - 1);
      display = repeatedDays + newDays.join(', ') + ', and ' + days.last;
    }
    return display;
  }

  @override
  Widget build(BuildContext context) {
    String recurringDays = '';
    List<String> dayList = [];
    days.forEach((k, v) {
      if (widget.ride.recurringDays.contains(k)) {
        dayList.add(v);
      }
    });
    recurringDays = recurringRides(dayList);

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
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
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
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
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
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
          )
        ],
      ),
    );
  }
}
