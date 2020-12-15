import 'dart:core';
import 'package:carriage_rider/RiderProvider.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'TextThemes.dart';

//Model for a ride.
class Ride {
  //The ride's id in the backend.
  final String id;
  //The ride type. Can only be 'active', 'past', or 'unscheduled'.
  final String type;
  //The starting location of a ride.
  final String startLocation;
  //The starting address of a ride.
  final String startAddress;
  //The ending location of a ride.
  final String endLocation;
  //The ending address of a ride.
  final String endAddress;
  //The ending date of a recurring ride. Will be null if ride is not recurring.
  final DateTime endDate;
  //The starting time of a ride.
  final DateTime startTime;
  //The ending time of a ride
  final DateTime endTime;
  //The rider associated with this ride.
  final Rider rider;
  //Indicates whether a ride is recurring or not. Will be null if ride is not recurring.
  final bool recurring;
  //The days of the week that a ride will repeat on. Will be null if ride is not recurring.
  final List<int> recurringDays;
  //Indicates whether a ride is deleted. Will be null if ride is not recurring.
  final bool deleted;
  //The requested end time of a ride. Will be null if ride is not recurring.
  final String requestedEndTime;
  //The ride status. Can only be 'not_started', 'on_the_way', 'picked_up', 'no_show', or 'completed'.
  final String status;
  //Indicates whether a ride is late
  final bool late;
  //The driver associated with this ride
  final Map<String, dynamic> driver;

  Ride(
      {this.id,
      this.type,
      this.startLocation,
      this.startAddress,
      this.endLocation,
      this.endAddress,
      this.rider,
      this.endDate,
      this.endTime,
      this.startTime,
      this.recurring,
      this.recurringDays,
      this.deleted,
      this.requestedEndTime,
      this.status,
      this.late,
      this.driver});

  //Creates a ride from JSON representation
  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
        id: json['id'],
        type: json['type'],
        startLocation: json['startLocation']['name'],
        startAddress: json['startLocation']['address'],
        endLocation: json['endLocation']['name'],
        endAddress: json['endLocation']['address'],
        startTime: DateTime.parse(json['startTime']),
        endDate: json['endDate'] == null
            ? DateTime.now()
            : DateTime.parse(json['endDate']),
        endTime: DateTime.parse(json['endTime']),
        rider: Rider.fromJson(json['rider']),
        recurring: json['recurring'] == null ? false : json['recurring'],
        recurringDays: json['recurringDays'] == null
            ? []
            : List.from(json['recurringDays']),
        deleted: json['deleted'] == null ? false : json['deleted'],
        requestedEndTime:
            json['requestedEndTime'] == null ? '' : json['requestedEndTime'],
        status: json['status'],
        late: json['late'],
        driver: json['driver'] == null ? false : json['driver']);
  }

  //Widget displaying the start time of a ride using DateFormat.
  Widget buildStartTime() {
    return RichText(
      text: TextSpan(
          text: DateFormat('MMM').format(startTime).toUpperCase() + ' ',
          style: TextThemes.monthStyle,
          children: [
            TextSpan(
                text:
                    ordinal(int.parse(DateFormat('d').format(startTime))) + ' ',
                style: TextThemes.dayStyle),
            TextSpan(
                text: DateFormat('jm').format(startTime),
                style: TextThemes.timeStyle)
          ]),
    );
  }

  //Widget displaying a custom built card with information about a ride's start location and start time.
  //[isIcon] determines whether the card needs an icon.
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

  //Widget displaying the start address of a ride along with an icon for a card.
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

  //Widget displaying the start address of a ride without an icon for a card.
  Widget cardInfo(context) {
    return Row(
      children: [
        Text(startAddress,
            style: TextStyle(
                fontSize: 14, color: Color(0xFF1A051D).withOpacity(0.5))),
      ],
    );
  }


  //Widget displaying the information of a ride after it has been requested. Shows the ride's
  //start location, end location, date, start and end time, recurring days,
  //and accessibility requests.
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
                Text(DateFormat('jm').format(endTime), style: infoStyle)
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
