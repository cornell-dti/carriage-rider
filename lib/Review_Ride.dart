import 'package:carriage_rider/Ride_Confirmation.dart';
import 'package:carriage_rider/RiderProvider.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/RideObject.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/app_config.dart';
import 'RidesProvider.dart';
import 'package:carriage_rider/Request_Ride_Loc.dart';

class ReviewRide extends StatefulWidget {
  final RideObject ride;

  ReviewRide({Key key, this.ride}) : super(key: key);

  @override
  _ReviewRideState createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {
  @override
  Widget build(BuildContext context) {
    PastRidesProvider rideProvider = Provider.of<PastRidesProvider>(context);
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
                  child: Text("Review",
                      style: RideRequestStyles.question(context)),
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
              Text('From', style: RideRequestStyles.label(context))
            ]),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("", style: RideRequestStyles.info(context))
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('To', style: RideRequestStyles.label(context))
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("", style: RideRequestStyles.info(context))
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
                      Text('Start Date',
                          style: RideRequestStyles.label(context)),
                      SizedBox(height: 5),
                      Text("", style: RideRequestStyles.info(context))
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('End Date',
                          style: RideRequestStyles.label(context)),
                      SizedBox(height: 5),
                      Text("", style: RideRequestStyles.info(context))
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
                      Text('Pickup Time',
                          style: RideRequestStyles.label(context)),
                      SizedBox(height: 5),
                      Text("", style: RideRequestStyles.info(context))
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Drop-off Time',
                          style: RideRequestStyles.label(context)),
                      SizedBox(height: 5),
                      Text("", style: RideRequestStyles.info(context))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Every', style: RideRequestStyles.label(context))
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("", style: RideRequestStyles.info(context))
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Accessibility Request',
                    style: RideRequestStyles.label(context))
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Wheelchair', style: RideRequestStyles.info(context))
              ],
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: 45.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      child: RaisedButton(
                        onPressed: () {
                          rideProvider.createRide(
                              AppConfig.of(context),
                              riderProvider,
                              widget.ride.fromLocation,
                              widget.ride.toLocation,
                              widget.ride.pickUpTime,
                              widget.ride.dropOffTime);
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => RideConfirmation()));
                        },
                        elevation: 3.0,
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text('Send Request'),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
