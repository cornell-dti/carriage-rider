import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'Ride.dart';
import 'TextThemes.dart';

class UpcomingRideCard extends StatelessWidget {
  UpcomingRideCard(this.ride);
  final Ride ride;

  final confirmationStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ride.type == 'active' ? Text('Ride Confirmed', style: confirmationStyle.copyWith(color: Color(0xFF4CAF50))) :
                Text('Ride Requested', style: confirmationStyle.copyWith(color: Color(0xFFFF9800))),
                SizedBox(height: 4),
                ride.buildStartTime(),
                SizedBox(height: 16),
                Text('From', style: TextThemes.directionStyle),
                Text(ride.startLocation, style: TextThemes.rideInfoStyle),
                SizedBox(height: 8),
                Text('To', style: TextThemes.directionStyle),
                Text(ride.endLocation, style: TextThemes.rideInfoStyle),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      //TODO: replace temp phone number
                      onTap: () => UrlLauncher.launch("tel://13232315234"),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.25))),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(Icons.phone, size: 20, color: Color(0xFF9B9B9B)),
                          )
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Driver', style: TextStyle(fontSize: 11)),
                        Text(ride.type == 'active' ? 'Confirmed' : 'TBD', style: TextThemes.rideInfoStyle)
                      ],
                    )
                  ],
                )
              ]
          ),
        ),
      ),
    );
  }
}
class UpcomingRides extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: <Widget>[
          //TODO: remove temporary data
          UpcomingRideCard(Ride(
            type: 'active',
            startLocation: 'Uris Hall',
            endLocation: 'Cascadilla Hall',
            startTime: DateTime(2020, 10, 18, 12, 0),
            endTime: DateTime(2020, 10, 18, 12, 15),
          ))
        ],
      ),
    );
  }
}
