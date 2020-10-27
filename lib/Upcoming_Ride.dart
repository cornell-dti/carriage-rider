import 'package:flutter/material.dart';

class UpcomingRide extends StatefulWidget {
  @override
  _UpcomingRideState createState() => _UpcomingRideState();
}

class _UpcomingRideState extends State<UpcomingRide> {
  @override
  Widget build(BuildContext context) {
    final monthStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      fontSize: 22,
    );

    final dayStyle = TextStyle(
      color: Colors.grey[700],
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      fontSize: 22,
    );

    final timeStyle = TextStyle(
      color: Colors.grey[500],
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      fontSize: 22,
    );

    final confirmationStyle = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    final requestedStyle = TextStyle(
      color: Colors.orangeAccent,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          UpcomingRideCard(
            rideStatus: Text('Ride Confirmed', style: confirmationStyle),
            timeDateWidget: RichText(
              text: TextSpan(text: 'OCT' + ' ', style: monthStyle, children: [
                TextSpan(text: '31th' + ' ', style: dayStyle),
                TextSpan(text: '10:00PM', style: timeStyle)
              ]),
            ),
            rideInfoWidget: RideInfoWidget(
              start: 'Uris Hall',
              end: 'Cascadila Hall',
            ),
            driverInfoWidget: DriverInfoWidget(
              driverName: 'Driver',
              driverStatus: 'Confirmed',
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 17),
            child: UpcomingRideCard(
              rideStatus: Text('Ride Requested', style: requestedStyle),
              timeDateWidget: RichText(
                text: TextSpan(text: 'NOV' + ' ', style: monthStyle, children: [
                  TextSpan(text: '26th' + ' ', style: dayStyle),
                  TextSpan(text: '3:00PM', style: timeStyle)
                ]),
              ),
              rideInfoWidget: RideInfoWidget(
                start: 'Balch Hall',
                end: 'Gates Hall',
              ),
              driverInfoWidget: DriverInfoWidget(
                driverName: 'Driver',
                driverStatus: 'TBD',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RideInfoWidget extends StatelessWidget {
  const RideInfoWidget({Key key, this.start, this.end}) : super(key: key);

  final start;
  final end;

  @override
  Widget build(BuildContext context) {
    final fromToStyle = TextStyle(
      color: Colors.grey[500],
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    final infoStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'From',
            style: fromToStyle,
          ),
          Text(
            start,
            style: infoStyle,
          ),
          SizedBox(height: 7),
          Text(
            'To',
            style: fromToStyle,
          ),
          Text(
            end,
            style: infoStyle,
          )
        ],
      ),
    );
  }
}

class DriverInfoWidget extends StatelessWidget {
  const DriverInfoWidget({Key key, this.driverName, this.driverStatus})
      : super(key: key);

  final driverName;
  final driverStatus;

  @override
  Widget build(BuildContext context) {
    final driverToStyle = TextStyle(
      color: Colors.grey[500],
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );

    final rideStatusStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    return Row(
      children: <Widget>[
        Icon(Icons.phone),
        SizedBox(
          width: 10.0,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                driverName,
                style: driverToStyle,
              ),
              Text(
                driverStatus,
                style: rideStatusStyle,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class UpcomingRideCard extends StatelessWidget {
  const UpcomingRideCard(
      {Key key,
      this.rideStatus,
      this.timeDateWidget,
      this.rideInfoWidget,
      this.driverInfoWidget})
      : super(key: key);

  final Widget rideStatus;
  final Widget timeDateWidget;
  final Widget rideInfoWidget;
  final Widget driverInfoWidget;
//  final Widget driverInfoWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 17.0, bottom: 15.0),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 22, bottom: 22),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      rideStatus,
                      SizedBox(height: 7),
                      timeDateWidget,
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                rideInfoWidget,
                SizedBox(
                  height: 15,
                ),
                driverInfoWidget
              ],
            ),
          ),
        ),
      ),
    );
  }
}
