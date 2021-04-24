import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Ride_Confirmation.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

class ReviewRide extends StatefulWidget {
  final Ride ride;

  ReviewRide({Key key, this.ride}) : super(key: key);

  @override
  _ReviewRideState createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {
  @override
  Widget build(context) {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text("Review", style: CarriageTheme.title1),
                  )
                ],
              ),
              TabBarTop(
                  colorOne: Colors.black,
                  colorTwo: Colors.black,
                  colorThree: Colors.black),
              TabBarBot(
                  colorOne: Colors.green,
                  colorTwo: Colors.green,
                  colorThree: Colors.black),
              SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                Text('From', style: CarriageTheme.labelStyle)
              ]),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Text(widget.ride.startLocation,
                          style: CarriageTheme.infoStyle))
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[Text('To', style: CarriageTheme.labelStyle)],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Text(widget.ride.endLocation,
                          style: CarriageTheme.infoStyle))
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Start Date', style: CarriageTheme.labelStyle),
                            SizedBox(height: 5),
                            Text(DateFormat.yMd().format(widget.ride.startTime),
                                style: CarriageTheme.infoStyle)
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Pickup Time', style: CarriageTheme.labelStyle),
                          SizedBox(height: 5),
                          Text(DateFormat.jm().format(widget.ride.startTime),
                              style: CarriageTheme.infoStyle)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.ride.endDate != null
                          ? Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('End Date', style: CarriageTheme.labelStyle),
                              SizedBox(height: 5),
                              Text(DateFormat.yMd().format(widget.ride.endDate),
                                  style: CarriageTheme.infoStyle)
                            ],
                          ))
                          : Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(''),
                              SizedBox(height: 5),
                              Text('', style: CarriageTheme.infoStyle)
                            ],
                          )),
                      SizedBox(height: 20),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Drop-off Time',
                                style: CarriageTheme.labelStyle),
                            SizedBox(height: 5),
                            Text(DateFormat.jm().format(widget.ride.endTime),
                                style: CarriageTheme.infoStyle)
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              widget.ride.recurring ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Every', style: CarriageTheme.labelStyle)
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.ride.recurringDays.map((day) {
                            List<String> days = ['M', 'T', 'W', 'Th', 'F'];
                            return days[day-1];
                          }).toList().join(' '),
                              style: CarriageTheme.infoStyle)
                        ],
                      )
                    ],
                  ))
                  : Container(),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Accessibility Requirement',
                      style: CarriageTheme.labelStyle)
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Wheelchair', style: CarriageTheme.infoStyle)
                ],
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(children: <Widget>[
                          FlowBackDuo(),
                          SizedBox(width: 40),
                          ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width * 0.65,
                              height: 50.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Expanded(
                                child: RaisedButton(
                                  onPressed: () async {
                                    rideFlowProvider.clearControllers();
                                    String startLoc = locationsProvider.isPreset(widget.ride.startLocation) ? widget.ride.startLocation
                                        : locationsProvider.locationByName(widget.ride.startLocation).id;
                                    String endLoc = locationsProvider.isPreset(widget.ride.endLocation) ? widget.ride.endLocation
                                        : locationsProvider.locationByName(widget.ride.endLocation).id;
                                    if (rideFlowProvider.editing) {
                                      // fake instance for recurring ride
                                      if (widget.ride.parentRide != null) {
                                        await rideFlowProvider.updateRecurringRide(
                                            AppConfig.of(context),
                                            context,
                                            widget.ride.parentRide.id,
                                            widget.ride.origDate,
                                            startLoc,
                                            endLoc,
                                            widget.ride.startTime,
                                            widget.ride.endTime,
                                            widget.ride.recurring,
                                            recurringDays: widget.ride.recurringDays,
                                            endDate: widget.ride.endDate
                                        );
                                      }
                                      // real instance
                                      else {
                                        await rideFlowProvider.updateRide(
                                            AppConfig.of(context),
                                            context,
                                            widget.ride.id,
                                            startLoc,
                                            endLoc,
                                            widget.ride.startTime,
                                            widget.ride.endTime,
                                            widget.ride.recurring,
                                            recurringDays: widget.ride.recurringDays,
                                            endDate: widget.ride.endDate
                                        );
                                      }
                                    }
                                    else {
                                      await rideFlowProvider.createRide(
                                          AppConfig.of(context),
                                          context,
                                          startLoc,
                                          endLoc,
                                          widget.ride.startTime,
                                          widget.ride.endTime,
                                          widget.ride.recurring,
                                          recurringDays: widget.ride.recurringDays,
                                          endDate: widget.ride.endDate
                                      );
                                    }
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                RideConfirmation()));
                                  },
                                  elevation: 2.0,
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  child: Text(rideFlowProvider.editing ? 'Update Request' : 'Send Request',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ]))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
