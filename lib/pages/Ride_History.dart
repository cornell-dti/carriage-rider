import 'package:flutter/material.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:intl/intl.dart';
import 'package:humanize/humanize.dart' as humanize;

class RideHistory extends StatefulWidget {
  @override
  _RideHistoryState createState() => _RideHistoryState();
}

class _RideHistoryState extends State<RideHistory> {
  Widget _emptyRideHist(context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 15),
        Text("You have no ride history!")
      ],
    );
  }

  Widget _mainHist(context, List<Ride> rides) {
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

    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: rides.length,
          itemBuilder: (c, int index) => RideHistoryCard(
            timeDateWidget: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: RichText(
                text: TextSpan(
                    text:
                        DateFormat('MMM').format(rides[index].startTime) + ' ',
                    style: monthStyle,
                    children: [
                      TextSpan(
                          text: humanize.ordinal(int.parse(DateFormat('d')
                                  .format(rides[index].startTime))) +
                              ' ',
                          style: dayStyle),
                      TextSpan(
                          text: DateFormat('jm').format(rides[index].startTime),
                          style: timeStyle)
                    ]),
              ),
            ),
            infoRowWidget: InformationRow(
                start: rides[index].startLocation,
                end: rides[index].endLocation),
          ),
        )
      ],
    );
  }

  @override
  Widget build(context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    AppConfig appConfig = AppConfig.of(context);

    return FutureBuilder<List<Ride>>(
        future: ridesProvider.fetchPastRides(context, appConfig, authProvider),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return _emptyRideHist(context);
            } else {
              return _mainHist(context, snapshot.data);
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
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
