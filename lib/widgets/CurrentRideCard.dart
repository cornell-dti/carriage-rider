import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/Current.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CurrentRideCard extends StatelessWidget {
  CurrentRideCard(
      this.ride, {
        @required this.showCallDriver,
      });

  final Ride ride;
  final bool showCallDriver;

  Widget onTheWayRide(context, Ride ride) {
    String startLocation = ride.startLocation;
    DateTime startTime = ride.startTime;
    String timeString = DateFormat.jm().format(startTime);
    return Row(children: <Widget>[
      Expanded(
        child: RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: new TextSpan(
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              new TextSpan(text: 'Head to the '),
              new TextSpan(
                  text: 'pickup location\n',
                  style: new TextStyle(fontWeight: FontWeight.bold)),
              new TextSpan(text: 'for @$startLocation by $timeString'),
            ],
          ),
        ),
      )
    ]);
  }

  Widget arrivedRide(context, Ride ride) {
    String startLocation = ride.startLocation;
    return Row(children: <Widget>[
      Expanded(
          child: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: new TextSpan(
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Meet your driver '),
                new TextSpan(
                    text: '@$startLocation',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ))
    ]);
  }

  Widget pickedUpRide(context, Ride ride) {
    String endLocation = ride.endLocation;
    return Row(children: <Widget>[
      Expanded(
          child: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: new TextSpan(
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Your driver will drop you off \n'),
                new TextSpan(
                    text: '@$endLocation',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ))
    ]);
  }

  Widget completeRide(context) {
    return Row(children: <Widget>[
      Expanded(
          child: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: new TextSpan(
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Your ride is '),
                new TextSpan(
                    text: 'complete!',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ))
    ]);
  }

  Widget currentCardInstruction(context, Ride ride) {
    return ride.status == RideStatus.NOT_STARTED ||
        ride.status == RideStatus.ON_THE_WAY
        ? onTheWayRide(context, ride)
        : ride.status == RideStatus.ARRIVED
        ? arrivedRide(context, ride)
        : ride.status == RideStatus.PICKED_UP
        ? pickedUpRide(context, ride)
        : completeRide(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget rideDetails = ride == null ? Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Icon(
            Icons.directions_car_rounded,
            size: 32,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text('No current ride',
              style: CarriageTheme.body
                  .copyWith(color: Colors.grey)),
          SizedBox(height: 20),
        ],
      ),
    ) : Expanded(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            currentCardInstruction(context, ride),
            SizedBox(height: 15),
            showCallDriver
                ? Row(
              children: <Widget>[
                Semantics(
                  label: 'Call driver',
                  button: true,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      onTap: () => UrlLauncher.launch(
                          'tel://${ride.driver.phoneNumber}'),
                      child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(100),
                              border: Border.all(
                                  width: 0.5,
                                  color: Colors.black
                                      .withOpacity(0.25))),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(Icons.phone,
                                size: 24,
                                color: Color(0xFF4CAF50)),
                          )),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Driver',
                        style: TextStyle(fontSize: 11)),
                    Text(ride.driver.fullName(),
                        style:
                        CarriageTheme.rideInfoStyle)
                  ],
                )
              ],
            )
                : Container(),
            SizedBox(height: 10),
          ]),
    );

    Widget cardInfo = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          rideDetails
        ],
      ),
    );
    if (ride == null) {
      return MergeSemantics(
        child: Container(
            margin: EdgeInsets.all(2),
            decoration: CarriageTheme.cardDecoration,
            child: cardInfo
        ),
      );
    }
    return Container(
        margin: EdgeInsets.all(2),
        decoration: CarriageTheme.cardDecoration,
        child: Material(
          type: MaterialType.transparency,
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: cardInfo,
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (context) => Current(ride)));
              },
            )
        )
    );
  }
}
