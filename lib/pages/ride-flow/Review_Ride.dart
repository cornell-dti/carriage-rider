import 'package:carriage_rider/pages/ride-flow/Ride_Confirmation.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/models/RideObject.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/utils/app_config.dart';
import '../../providers/RidesProvider.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/pages/ride-flow/Request_Ride_Loc.dart';
import 'package:carriage_rider/models/Location.dart';

class ReviewRide extends StatefulWidget {
  final RideObject ride;

  ReviewRide({Key key, this.ride}) : super(key: key);

  @override
  _ReviewRideState createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {
  Widget _reviewPage(BuildContext context, List<Location> locations) {
    RidesProvider rideProvider = Provider.of<RidesProvider>(context);
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
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
                Text(
                    widget.ride.fromLocation != null
                        ? widget.ride.fromLocation
                        : '',
                    style: CarriageTheme.infoStyle)
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
                Text(
                    widget.ride.toLocation != null
                        ? widget.ride.toLocation
                        : '',
                    style: CarriageTheme.infoStyle)
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Start Date', style: CarriageTheme.labelStyle),
                      SizedBox(height: 5),
                      Text(
                          widget.ride.startDate != null
                              ? widget.ride.startDate
                              : '',
                          style: CarriageTheme.infoStyle)
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('End Date', style: CarriageTheme.labelStyle),
                      SizedBox(height: 5),
                      Text(
                          widget.ride.endDate != null
                              ? widget.ride.endDate
                              : 'None',
                          style: CarriageTheme.infoStyle)
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Pickup Time', style: CarriageTheme.labelStyle),
                      SizedBox(height: 5),
                      Text(
                          widget.ride.pickUpTime != null
                              ? widget.ride.pickUpTime
                              : '',
                          style: CarriageTheme.infoStyle)
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Drop-off Time', style: CarriageTheme.labelStyle),
                      SizedBox(height: 5),
                      Text(
                          widget.ride.dropOffTime != null
                              ? widget.ride.dropOffTime
                              : '',
                          style: CarriageTheme.infoStyle)
                    ],
                  ),
                )
              ],
            ),
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
                Text(
                    widget.ride.every != null
                        ? widget.ride.every
                        : 'No Recurring Days',
                    style: CarriageTheme.infoStyle)
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Accessibility Request', style: CarriageTheme.labelStyle)
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
                          child: RaisedButton(
                            onPressed: () {
                              rideProvider.createRide(
                                  AppConfig.of(context),
                                  context,
                                  riderProvider,
                                  LocationsProvider.locationByName(widget.ride.fromLocation, locations),
                                  LocationsProvider.locationByName(widget.ride.toLocation, locations),
                                  widget.ride.pickUp,
                                  widget.ride.dropOff,
                                  widget.ride.end,
                                  widget.ride.recurring,
                                  widget.ride.recurringDays);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          RideConfirmation()));
                            },
                            elevation: 2.0,
                            color: Colors.black,
                            textColor: Colors.white,
                            child: Text('Send Request'),
                          ),
                        ),
                      ]))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    AppConfig appConfig = AppConfig.of(context);

    return FutureBuilder<List<Location>>(
        future:
            locationsProvider.fetchLocations(context, appConfig, authProvider),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _reviewPage(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
