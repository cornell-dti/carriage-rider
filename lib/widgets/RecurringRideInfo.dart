import 'package:carriage_rider/models/Ride.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:intl/intl.dart';

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
            style: CarriageTheme.title3,
          ),
        ),
      ),
    ]);
  }
}

class RecurringRideInfo extends StatelessWidget {
  RecurringRideInfo(this.ride);
  final Ride ride;

  final Map<int, String> dayChars = {
    1: 'M',
    2: 'T',
    3: 'W',
    4: 'Th',
    5: 'F',
  };

  final Map<int, String> dayNames = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
  };

  String repetitionInfo(List<String> days) {
    String info = '';
    if (days.length == 1) {
      info = days.first;
    } else if (days.length == 2) {
      info = days.join(' and ');
    } else {
      List<String> newDays = days.sublist(0, days.length - 1);
      info = newDays.join(', ') + ', and ' + days.last;
    }
    return 'Repeats every ' + info;
  }

  @override
  Widget build(BuildContext context) {
    List<String> dayCharList = ride.recurringDays.map((index) => dayChars[index]).toList();
    List<String> dayNameList = ride.recurringDays.map((index) => dayNames[index]).toList();

    String recurringDaysInfo = repetitionInfo(dayCharList);
    String recurringDayNamesInfo = repetitionInfo(dayNameList);

    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Row(
            children: [
              DateInfo(ride: ride, start: true),
              SizedBox(
                width: 8,
              ),
              DateDivider(),
              SizedBox(
                width: 8,
              ),
              DateInfo(ride: ride, start: false)
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Text(
                recurringDaysInfo,
                semanticsLabel: recurringDayNamesInfo,
                style: TextStyle(color: Colors.grey[800], fontSize: 16),
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
    return ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(' ', style: TextStyle(color: Colors.black, fontSize: 14)),
          Text(
            '~',
            style: TextStyle(color: CarriageTheme.gray1, fontSize: 20),
          )
        ],
      ),
    );
  }
}

class DateInfo extends StatelessWidget {
  const DateInfo({Key key, @required this.ride, @required this.start}) : super(key: key);
  final Ride ride;
  final bool start;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              start ? 'From' : 'To',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('MM/dd/yyyy').format(start ? ride.startTime : ride.endDate),
              style: TextStyle(color: CarriageTheme.gray1, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}