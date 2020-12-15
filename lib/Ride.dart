import 'dart:core';
import 'package:carriage_rider/RiderProvider.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'CarriageTheme.dart';

class Ride {
  final String id;
  final String type;
  final Rider rider;
  final String status;

  final String startLocation;
  final String startAddress;
  final String endLocation;
  final String endAddress;

  final DateTime startTime;
  final DateTime requestedEndTime;

  final bool recurring;
  final List<int> recurringDays;
  final bool deleted;
  final bool late;
  final List<String> edits;
  final DateTime endDate;

  final Map<String, dynamic> driver;

  Ride(
      {this.id,
        this.type,
        this.rider,
        this.status,

        this.startLocation,
        this.startAddress,
        this.endLocation,
        this.endAddress,

        this.startTime,
        this.requestedEndTime,

        this.recurring,
        this.recurringDays,
        this.deleted,
        this.late,
        this.edits,
        this.endDate,
        this.driver
      });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      type: json['type'],
      rider: Rider.fromJson(json['rider']),
      status: json['status'],

      startLocation: json['startLocation']['name'],
      startAddress: json['startLocation']['address'],
      endLocation: json['endLocation']['name'],
      endAddress: json['endLocation']['address'],

      startTime: DateTime.parse(json['startTime']),
      requestedEndTime: json['requestedEndTime'] == null ? null : DateTime.parse(json['requestedEndTime']),

      recurring: json['recurring'] == null ? false : json['recurring'],
      recurringDays: json['recurringDays'] == null ? [] : List.from(json['recurringDays']),
      deleted: json['deleted'] == null ? false : json['deleted'],
      late: json['late'],
      driver: json['driver'] == null ? null : json['driver'],
      edits: json['edits'] == null ? [] : List.from(json['edits']),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
    );
  }

  Widget buildStartTime() {
    return RichText(
      text: TextSpan(
          text: DateFormat('MMM').format(startTime).toUpperCase() + ' ',
          style: CarriageTheme.monthStyle,
          children: [
            TextSpan(
                text:
                ordinal(int.parse(DateFormat('d').format(startTime))) + ' ',
                style: CarriageTheme.dayStyle),
            TextSpan(
                text: DateFormat('jm').format(startTime),
                style: CarriageTheme.timeStyle)
          ]),
    );
  }

  Widget buildLocationsCard(context, bool isIcon) {
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 8,
              spreadRadius: 0,
              color: Colors.black.withOpacity(0.15))
        ]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(startLocation,
                style: TextStyle(fontSize: 14, color: Color(0xFF1A051D))),
            Container(
                width: MediaQuery.of(context).size.width,
                child:
                isIcon == true ? cardIconInfo(context) : cardInfo(context)),
            SizedBox(height: 16),
            Text(
                'Estimated pick up time: ' + DateFormat('jm').format(startTime),
                style: TextStyle(fontSize: 13, color: Color(0xFF3F3356)))
          ]),
        ));
  }

  Widget cardIconInfo(context) {
    return Row(
      children: [
        Text(startAddress,
            style: TextStyle(
                fontSize: 14, color: Color(0xFF1A051D).withOpacity(0.5))),
        SizedBox(width: 10),
        Icon(Icons.location_on),
      ],
    );
  }

  Widget cardInfo(context) {
    return Row(
      children: [
        Text(startAddress,
            style: TextStyle(
                fontSize: 14, color: Color(0xFF1A051D).withOpacity(0.5))),
      ],
    );
  }

  Widget buildSummary(context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    final labelStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.w300, fontSize: 11);

    final infoStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Text('From', style: labelStyle)]),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text(startLocation, style: infoStyle)],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text('To', style: labelStyle)],
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text(endLocation, style: infoStyle)],
      ),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text('Date', style: labelStyle)],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(DateFormat('yMd').format(startTime), style: infoStyle)
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
                Text('Pickup Time', style: labelStyle),
                SizedBox(height: 5),
                Text(DateFormat('jm').format(startTime), style: infoStyle)
              ],
            ),
          ),
          SizedBox(width: 30),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Drop-off Time', style: labelStyle),
                SizedBox(height: 5),
                Text(DateFormat('jm').format(requestedEndTime), style: infoStyle)
              ],
            ),
          )
        ],
      ),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text('Every', style: labelStyle)],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //TODO: change to have repeating rides info
          Text('M W F', style: infoStyle)
        ],
      ),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text('Accessibility Request', style: labelStyle)],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
              riderProvider.hasInfo()
                  ? riderProvider.info.accessibilityStr()
                  : '',
              style: infoStyle)
        ],
      ),
    ]);
  }
}

T getOrNull<T>(Map<String, dynamic> map, String key, {T parse(dynamic s)}) {
  var x = map.containsKey(key) ? map[key] : null;
  if (x == null) return null;
  if (parse == null) return x;
  return parse(x);
}

class RideCard extends StatelessWidget {
  RideCard(this.ride, {@required this.showConfirmation, @required this.showCallDriver, @required this.showArrow});
  final Ride ride;
  final bool showConfirmation;
  final bool showCallDriver;
  final bool showArrow;

  final confirmationStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => UpcomingRidePage(ride))
        );
      },
      child: Container(
        margin: EdgeInsets.all(2),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: CarriageTheme.cardDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    showConfirmation ?
                    (ride.type == 'active' ? Text('Ride Confirmed', style: confirmationStyle.copyWith(color: Color(0xFF4CAF50))) :
                    Text('Ride Requested', style: confirmationStyle.copyWith(color: Color(0xFFFF9800)))) : Container(),
                    SizedBox(height: 4),
                    ride.buildStartTime(),
                    SizedBox(height: 16),
                    Text('From', style: CarriageTheme.directionStyle),
                    Text(ride.startLocation, style: CarriageTheme.rideInfoStyle),
                    SizedBox(height: 8),
                    Text('To', style: CarriageTheme.directionStyle),
                    Text(ride.endLocation, style: CarriageTheme.rideInfoStyle),
                    SizedBox(height: 16),
                    showCallDriver ? Row(
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
                            Text(ride.type == 'active' ? 'Confirmed' : 'TBD', style: CarriageTheme.rideInfoStyle)
                          ],
                        )
                      ],
                    ) : Container()
                  ]
              ),
              showArrow ? Spacer() : Container(),
              showArrow ? Icon(Icons.chevron_right, size: 28) : Container()
            ],
          ),
        ),
      ),
    );
  }
}