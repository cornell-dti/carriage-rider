import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carriage_rider/RidesProvider.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/Ride.dart';

import 'PopButton.dart';

class RideHistory extends StatefulWidget {
  @override
  _RideHistoryState createState() => _RideHistoryState();
}

class _RideHistoryState extends State<RideHistory> {
  Widget _emptyRideHist() {
    return Row(
      children: <Widget>[
        SizedBox(width: 15),
        Text("You have no ride history!")
      ],
    );
  }

  Widget _mainHist(List<Ride> rides) {
    List<Widget> rideCards = [];
    for (int i = 0; i < rides.length; i++) {
      if (i == 0) {
        rideCards.add(SizedBox(width: 16));
      }
      rideCards.add(Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: RideCard(rides[i],
            showConfirmation: false, showCallDriver: false, showArrow: false),
      ));
      rideCards.add(SizedBox(width: 16));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: rideCards),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    List<Ride> pastRides = ridesProvider.pastRides;
    if (pastRides.length == 0) {
      return _emptyRideHist();
    } else {
      return _mainHist(pastRides.sublist(0, min(5, pastRides.length)));
    }
  }
}

class TimeDateHeader extends StatelessWidget {
  const TimeDateHeader({Key key, this.timeDate}) : super(key: key);

  final String timeDate;

  @override
  Widget build(context) {
    final timeDateStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'SFPro',
      fontSize: 22,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 25),
          child: Text(timeDate, style: timeDateStyle),
        )
      ],
    );
  }
}

class InformationRow extends StatelessWidget {
  const InformationRow({Key key, this.start, this.end}) : super(key: key);

  final start;
  final end;

  @override
  Widget build(context) {
    final fromToStyle = TextStyle(
      color: Colors.grey[500],
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    final infoStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    );
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[Text('From', style: fromToStyle)],
                ),
                SizedBox(height: 2),
                Row(
                  children: <Widget>[Text(start, style: infoStyle)],
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[Icon(Icons.arrow_forward)],
                )
              ],
            ),
          ),
          Container(
            width: 100.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[Text('To', style: fromToStyle)],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[Text(end, style: infoStyle)],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RideHistoryCard extends StatelessWidget {
  const RideHistoryCard({Key key, this.timeDateWidget, this.infoRowWidget})
      : super(key: key);

  final Widget timeDateWidget;
  final Widget infoRowWidget;

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.only(left: 17.0, right: 17.0, bottom: 15.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .18,
      child: Card(
        elevation: 3.0,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[timeDateWidget, infoRowWidget],
          ),
        ),
      ),
    );
  }
}

class HistorySeeMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider =
        Provider.of<RidesProvider>(context, listen: false);
    List<Ride> originalRides = ridesProvider.pastRides;
    RecurringRidesGenerator ridesGenerator =
        RecurringRidesGenerator(originalRides);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: PopButton(context, 'Schedule'),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text('Ride History',
              style: Theme.of(context).textTheme.headline1),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ridesGenerator.buildPastRidesList(),
            ),
          ),
        )
      ]),
    )));
  }
}
