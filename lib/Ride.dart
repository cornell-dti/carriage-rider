import 'dart:core';
import 'package:carriage_rider/RiderProvider.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'TextThemes.dart';

class Ride {
  final String id;
  final String type;
  final String startLocation;
  final String startAddress;
  final String endLocation;
  final String endAddress;
  final DateTime startTime;
  final DateTime endTime;
  final Rider rider;

  Ride({
    this.id,
    this.type,
    this.startLocation,
    this.startAddress,
    this.endLocation,
    this.endAddress,
    this.rider,
    this.endTime,
    this.startTime
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      type: json['type'],
      startLocation: json['startLocation']['name'],
      startAddress: json['startLocation']['address'],
      endLocation: json['endLocation']['name'],
      endAddress: json['endLocation']['address'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      rider: Rider.fromJson(json['rider']),
    );
  }

  Widget buildStartTime() {
    return RichText(
      text: TextSpan(
          text: DateFormat('MMM').format(startTime).toUpperCase() + ' ',
          style: TextThemes.monthStyle,
          children: [
            TextSpan(
                text: ordinal(int.parse(DateFormat('d')
                    .format(startTime))) +
                    ' ',
                style: TextThemes.dayStyle),
            TextSpan(
                text: DateFormat('jm').format(startTime),
                style: TextThemes.timeStyle)
          ]
      ),
    );
  }

  Widget buildLocationsCard(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 8,
                  spreadRadius: 0,
                  color: Colors.black.withOpacity(0.15)
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(startLocation, style: TextStyle(fontSize: 15, color: Color(0xFF1A051D))),
                Container(
                  width: MediaQuery.of(context).size.width,
                    child: Text(startAddress, style: TextStyle(fontSize: 15, color: Color(0xFF1A051D).withOpacity(0.5)))
                ),
                SizedBox(height: 16),
                Text('Estimated pick up time: ' + DateFormat('jm').format(startTime), style: TextStyle(fontSize: 13, color: Color(0xFF3F3356)))
              ]
          ),
        )
    );
  }

  Widget buildSummary(BuildContext context) {
    Rider rider = Provider.of<RiderProvider>(context).info;
    final labelStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w300,
        fontSize: 11
    );

    final infoStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16
    );
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('From', style: labelStyle)
            ]
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(startLocation, style: infoStyle)
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('To', style: labelStyle)
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(endLocation, style: infoStyle)
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Date', style: labelStyle)
          ],
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
                  Text(DateFormat('jm').format(endTime), style: infoStyle)
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Every', style: labelStyle)
          ],
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
          children: <Widget>[
            Text('Accessibility Request', style: labelStyle)
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(rider.accessibilityStr(), style: infoStyle)
          ],
        ),
      ]
    );
  }
}

T getOrNull<T>(Map<String, dynamic> map, String key, {T parse(dynamic s)}) {
  var x = map.containsKey(key) ? map[key] : null;
  if (x == null) return null;
  if (parse == null) return x;
  return parse(x);
}
