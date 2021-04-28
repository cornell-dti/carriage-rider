import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverCard extends StatelessWidget {
  final Color color;
  final Ride ride;
  final bool showButtons;

  const DriverCard(
      {Key key,
      @required this.color,
      @required this.ride,
      @required this.showButtons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration buttonDecoration = BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [CarriageTheme.boxShadow]);

    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: <Widget>[
          ride.driver == null || ride.driver.photoLink == null
              ? Icon(Icons.account_circle, size: 64, color: CarriageTheme.gray4)
              : ride.driver.profilePicture(70),
          SizedBox(width: 15),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  ride.driver == null ? 'Driver TBD' : ride.driver.fullName(),
                  style: TextStyle(
                      color: color, fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                showButtons
                    ? Row(
                        children: [
                          SizedBox(width: 20),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: buttonDecoration,
                            child: IconButton(
                              icon: Icon(Icons.phone, size: 16),
                              color: color,
                              onPressed: () =>
                                  launch('tel://${ride.driver.phoneNumber}'),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
