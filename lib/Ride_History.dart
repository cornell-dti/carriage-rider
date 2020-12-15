import 'package:flutter/material.dart';
import 'package:carriage_rider/RidesProvider.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/Ride.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:intl/intl.dart';
import 'package:humanize/humanize.dart' as humanize;

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
    final monthStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        fontSize: 22,
        height: 2);

    final dayStyle = TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        fontSize: 22,
        height: 2);

    final timeStyle = TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        fontSize: 22,
        height: 2);

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: rides.map((ride) => RideCard(ride, showConfirmation: false, showCallDriver: false, showArrow: false,)).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    List<Ride> pastRides = ridesProvider.pastRides;
    if (pastRides.length == 0) {
      return _emptyRideHist();
    } else {
      return _mainHist(pastRides);
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
