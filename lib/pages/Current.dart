import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/RidePage.dart';
import 'package:carriage_rider/widgets/DriverCard.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/RecurringRide.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

class Current extends StatelessWidget {
  Current(this.ride);
  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ScheduleBar(Colors.white, Colors.black),
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
                  DriverCard(color: Colors.black, ride: ride, showButtons: true),
                  SizedBox(height: 40),
                  TimeLine(ride, true, true, true),
                  SizedBox(height: 30),
                  CustomDivider(),
                  SizedBox(height: 20),
                  ride.recurring
                      ? RecurringRide(ride)
                      : NoRecurringRide(ride),
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
