import 'package:carriage_rider/Assistance.dart';
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
  Widget build(context) {
    PastRidesProvider rideProvider = Provider.of<PastRidesProvider>(context);
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: InkWell(
                    child: Text("Cancel",
                        style: RideRequestStyles.cancel(context)),
                    onTap: () {
                      Navigator.pop(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Assistance()));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Icon(Icons.check),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Flexible(
                    child: Text("Review your ride",
                        style: RideRequestStyles.question(context)))
              ],
            ),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text('From', style: RideRequestStyles.label(context))
            ]),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                    widget.ride.fromLocation != null
                        ? widget.ride.fromLocation
                        : "",
                    style: RideRequestStyles.info(context))
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
                Text(
                    widget.ride.toLocation != null
                        ? widget.ride.toLocation
                        : "",
                    style: RideRequestStyles.info(context))
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Date', style: RideRequestStyles.label(context))
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(widget.ride.date != null ? widget.ride.date : "",
                    style: RideRequestStyles.info(context))
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
                      Text(
                          widget.ride.pickUpTime != null
                              ? widget.ride.pickUpTime
                              : "",
                          style: RideRequestStyles.info(context))
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
                      Text(
                          widget.ride.dropOffTime != null
                              ? widget.ride.dropOffTime
                              : "",
                          style: RideRequestStyles.info(context))
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
                Text(widget.ride.every, style: RideRequestStyles.info(context))
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
