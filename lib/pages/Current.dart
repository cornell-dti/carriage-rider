import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/Upcoming.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/RecurringRide.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

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
                          style: CarriageTheme.largeTitle
                              .copyWith(color: Colors.white))),
                  BackgroundHeader(
                    widget: SizedBox(height: 10),
                  ),
                  SizedBox(height: 20),
                  ContactCard(color: Colors.black, ride: widget.ride),
                  SizedBox(height: 40),
                  TimeLine(widget.ride, true, true, true),
                  SizedBox(height: 30),
                  CustomDivider(),
                  SizedBox(height: 20),
                  widget.ride.recurring
                      ? RecurringRide(widget.ride)
                      : NoRecurringRide(widget.ride),
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                ],
              ),
            )
          ],
        )));
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
