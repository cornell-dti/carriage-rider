import 'package:flutter/material.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:intl/intl.dart';
import 'package:humanize/humanize.dart';
import 'PopButton.dart';
import 'Ride.dart';
import 'Current.dart';

Map days = {
  0: 'Sunday',
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday'
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
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 16),
                    child: Row(children: [
                      Icon(Icons.arrow_back_ios, color: Colors.black),
                      Text('Schedule', style: TextStyle(fontSize: 17))
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 8, top: 16),
                  child: Text(
                      DateFormat('MMM')
                              .format(widget.ride.startTime)
                              .toUpperCase() +
                          ' ' +
                          ordinal(int.parse(
                              DateFormat('d').format(widget.ride.startTime))) +
                          ' ' +
                          DateFormat('jm').format(widget.ride.startTime),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
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
                      SizedBox(height: MediaQuery.of(context).size.height / 8),
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
            "Occurrence",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
            text: "Repeat Ride", color: Colors.black, icon: Icons.repeat),
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

class HistorySeeMore extends StatefulWidget {
  @override
  _HistorySeeMoreState createState() => _HistorySeeMoreState();
}

class _HistorySeeMoreState extends State<HistorySeeMore> {
  List<Ride> rides = [
    Ride(
        type: 'active',
        startLocation: 'Uris Hall',
        startAddress:
        '100 Carriage Way, Ithaca, NY 14850',
        endLocation: 'Cascadilla Hall',
        endAddress: '101 DTI St, Ithaca, NY 14850',
        startTime: DateTime(2020, 10, 18, 13, 0),
        requestedEndTime: DateTime(2020, 10, 18, 13, 15),
        endDate: DateTime(2020, 12, 10),
        recurring: true,
        recurringDays: [0, 3, 4]
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: PopButton(context, 'Schedule'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                      child: Text('Ride History', style: Theme.of(context).textTheme.headline1),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rides.length,
                            itemBuilder: (context, index) {
                              return RideCard(
                                rides[index],
                                showConfirmation: false,
                                showCallDriver: false,
                                showArrow: true,
                              );
                            }
                        ),
                      ),
                    )
                  ]
              ),
            )
        )
    );
  }
}

