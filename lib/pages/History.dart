import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Upcoming.dart';
import 'package:intl/intl.dart';
import 'package:humanize/humanize.dart';
import '../models/Ride.dart';
import 'Current.dart';

Map days = {
  0: 'Sun.',
  1: 'Mon.',
  2: 'Tue.',
  3: 'Wed.',
  4: 'Thurs.',
  5: 'Fri.',
  6: 'Sat.'
};

class History extends StatefulWidget {
  History(this.ride);

  final Ride ride;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: PageTitle(title: 'Schedule'),
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 8, top: 16),
                      child: Text(
                          DateFormat('MMM')
                                  .format(widget.ride.startTime)
                                  .toUpperCase() +
                              ' ' +
                              ordinal(int.parse(DateFormat('d')
                                  .format(widget.ride.startTime))) +
                              ' ' +
                              DateFormat('jm').format(widget.ride.startTime),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 34,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Contact(color: Colors.grey),
                          SizedBox(height: 20),
                          TimeLine(widget.ride, false),
                          SizedBox(height: 20),
                          CustomDivider(),
                          SizedBox(height: 10),
                          widget.ride.recurring
                              ? RecurringRideHistory(widget.ride)
                              : NoRecurringRideHistory(widget.ride),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 8),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              EditRide(),
            ],
          ),
        ));
  }
}

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
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    ]);
  }
}

class NoRecurringRideHistory extends StatefulWidget {
  NoRecurringRideHistory(this.ride);

  final Ride ride;

  @override
  _NoRecurringRideHistoryState createState() => _NoRecurringRideHistoryState();
}

class _NoRecurringRideHistoryState extends State<NoRecurringRideHistory> {
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

class RecurringRideHistory extends StatefulWidget {
  RecurringRideHistory(this.ride);

  final Ride ride;

  @override
  _RecurringRideHistoryState createState() => _RecurringRideHistoryState();
}

class _RecurringRideHistoryState extends State<RecurringRideHistory> {
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
          OccurrenceTitle(),
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
