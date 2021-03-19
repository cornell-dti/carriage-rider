import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Upcoming.dart';
import 'package:intl/intl.dart';
import 'package:humanize/humanize.dart';
import '../models/Ride.dart';
import 'package:carriage_rider/pages/RecurringRide.dart';

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
                          ContactCard(color: Colors.grey),
                          SizedBox(height: 20),
                          TimeLine(widget.ride, false, false, false),
                          SizedBox(height: 20),
                          CustomDivider(),
                          SizedBox(height: 10),
                          widget.ride.recurring
                              ? RecurringRide(widget.ride)
                              : NoRecurringRide(widget.ride),
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

