import 'dart:core';
import 'package:carriage_rider/RiderProvider.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';

import 'TextThemes.dart';

class Ride {
  final String id;
  final String type;
  final String startLocation;
  final String endLocation;
  final DateTime startTime;
  final DateTime endTime;
  final Rider rider;

  Ride(
      {this.id,
      this.type,
      this.startLocation,
      this.endLocation,
      this.rider,
      this.endTime,
      this.startTime});

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      type: json['type'],
      startLocation: json['startLocation']['name'],
      endLocation: json['endLocation']['name'],
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
}

T getOrNull<T>(Map<String, dynamic> map, String key, {T parse(dynamic s)}) {
  var x = map.containsKey(key) ? map[key] : null;
  if (x == null) return null;
  if (parse == null) return x;
  return parse(x);
}
