import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/RidePage.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class RideCard extends StatelessWidget {
  RideCard(this.ride,
      {@required this.showConfirmation,
        @required this.showCallDriver,
        @required this.showArrow,
        this.parentRideID});

  final Ride ride;
  final bool showConfirmation;
  final bool showCallDriver;
  final bool showArrow;
  final String parentRideID;

  final confirmationStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );


  @override
  Widget build(BuildContext context) {
    void navigateToPage() {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  RidePage(ride))
      );
    }
    return Semantics(
      button: true,
      onTap: navigateToPage,
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: CarriageTheme.cardDecoration,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: navigateToPage,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          showConfirmation
                              ? (ride.type == 'active'
                              ? Text('Ride Confirmed',
                              style: confirmationStyle.copyWith(
                                  color: Color(0xFF4CAF50)))
                              : Text('Ride Requested',
                              style: confirmationStyle.copyWith(
                                  color: Color(0xFFFF9800))))
                              : Container(),
                          ride.status == RideStatus.NO_SHOW ? Text('No Show',
                              style: confirmationStyle.copyWith(
                                  color: Color(0xFFF44336))) : Container(),
                          SizedBox(height: 4),
                          ride.buildStartTime(),
                          SizedBox(height: 16),
                          Text('From', style: CarriageTheme.directionStyle),
                          Text(ride.startLocation,
                              style: CarriageTheme.rideInfoStyle),
                          SizedBox(height: 8),
                          Text('To', style: CarriageTheme.directionStyle),
                          Text(ride.endLocation,
                              style: CarriageTheme.rideInfoStyle),
                          SizedBox(height: 16),
                          showCallDriver
                              ? Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () =>
                                    UrlLauncher.launch('tel://${ride.driver.phoneNumber}'),
                                child: Container(
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
                                          size: 20, color: Color(0xFF9B9B9B)),
                                    )),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Driver',
                                      style: TextStyle(fontSize: 11)),
                                  Text(
                                      ride.type == 'active'
                                          ? 'Confirmed'
                                          : 'TBD',
                                      style: CarriageTheme.rideInfoStyle)
                                ],
                              )
                            ],
                          )
                              : Container()
                        ]),
                  ),
                  showArrow ? Icon(Icons.chevron_right, size: 28) : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}