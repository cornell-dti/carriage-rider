import 'dart:core';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/models/Driver.dart';
import '../utils/CarriageTheme.dart';

enum RideStatus {
  NOT_STARTED,
  ON_THE_WAY,
  ARRIVED,
  PICKED_UP,
  COMPLETED,
  NO_SHOW
}

/// Parses [status] representing a ride status into its corresponding enum.
RideStatus getStatusEnum(String status) {
  switch (status) {
    case ('not_started'):
      return RideStatus.NOT_STARTED;
    case ('on_the_way'):
      return RideStatus.ON_THE_WAY;
    case ('arrived'):
      return RideStatus.ARRIVED;
    case ('picked_up'):
      return RideStatus.PICKED_UP;
    case ('completed'):
      return RideStatus.COMPLETED;
    case ('no_show'):
      return RideStatus.NO_SHOW;
    default:
      throw Exception('Ride status is invalid');
  }
}

//Model for a ride.
class Ride {
  //The ride's id in the backend.
  String id;

  //The ride type. Can only be 'active', 'past', or 'unscheduled'.
  String type;

  //The starting location of a ride.
  String startLocation;

  //The starting address of a ride.
  String startAddress;

  //The ending location of a ride.
  String endLocation;

  //The ending address of a ride.
  String endAddress;

  //The ending date of a recurring ride. Will be null if ride is not recurring.
  DateTime endDate;

  //The starting time of a ride.
  DateTime startTime;

  //The ending time of a ride
  DateTime endTime;

  //The rider associated with this ride.
  Rider rider;

  //Indicates whether a ride is recurring or not. Will be null if ride is not recurring.
  bool recurring;

  //The days of the week that a ride will repeat on. Will be null if ride is not recurring.
  List<int> recurringDays;

  //The requested end time of a ride. Will be null if ride is not recurring.
  DateTime requestedEndTime;

  //The ride status. Can only be 'not_started', 'on_the_way', 'picked_up', 'no_show', or 'completed'.
  RideStatus status;

  //Indicates whether a ride is late
  bool late;

  //The driver associated with this ride
  Driver driver;

  //The IDs of rides corresponding to edits
  List<String> edits;

  // The parent ride, if this is a generated instance of a repeating ride
  Ride parentRide;

  // The original date of this ride, if this is a generated instance of a repeating ride
  DateTime origDate;
  // The dates of deleted instances of a recurring ride
  List<DateTime> deleted;

  // Whether this is an edited instance of a recurring ride (its ID appears in the edits field for a recurring ride
  bool isEdit;

  Ride(
      {this.id,
        this.parentRide,
        this.origDate,
        this.type,
        this.rider,
        this.status,
        this.startLocation,
        this.startAddress,
        this.endLocation,
        this.endAddress,
        this.startTime,
        this.endTime,
        this.requestedEndTime,
        this.recurring,
        this.recurringDays,
        this.deleted,
        this.late,
        this.edits,
        this.isEdit,
        this.endDate,
        this.driver});

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
        id: json['id'],
        type: json['type'],
        rider: Rider.fromJson(json['rider']),
        status: getStatusEnum(json['status']),
        startLocation: json['startLocation']['name'],
        startAddress: json['startLocation']['address'],
        endLocation: json['endLocation']['name'],
        endAddress: json['endLocation']['address'],
        startTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
            .parse(json['startTime'], true)
            .toLocal(),
        endTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
            .parse(json['endTime'], true)
            .toLocal(),
        recurring: json['recurring'] == null ? false : json['recurring'],
        recurringDays:
        json['recurringDays'] == null ? null : List.from(json['recurringDays']),
        deleted: json['deleted'] == null
            ? null
            : List<String>.from(json['deleted'])
            .map((String d) => DateFormat('yyyy-MM-dd').parse(d, true))
            .toList(),
        late: json['late'],
        driver: json['driver'] == null ? null : Driver.fromJson(json['driver']),
        edits: json['edits'] == null ? null : List.from(json['edits']),
        endDate: json['endDate'] == null
            ? null
            : DateFormat('yyyy-MM-dd').parse(json['endDate'])
    );
  }

  //Widget displaying the start time of a ride using DateFormat.
  Widget buildStartTime(BuildContext context) {
    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
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

  //Widget displaying a custom built card with information about a ride's start location and start time.
  //[isIcon] determines whether the card needs an icon.
  Widget buildLocationsCard(context, bool isIcon, bool pickUp, bool isStart) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [CarriageTheme.boxShadow]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isStart ? startLocation : endLocation,
                style: TextStyle(fontSize: 14, color: Color(0xFF1A051D))),
            Container(
                width: MediaQuery.of(context).size.width,
                child: cardInfo(context, isStart, isIcon)),
            SizedBox(height: 16),
            Text(
                'Estimated ${pickUp ? 'pick up time' : 'drop off time'}: ' +
                    DateFormat('jm').format(isStart ? startTime : endTime),
                style: TextStyle(fontSize: 13, color: Color(0xFF3F3356)))
          ]),
        ));
  }

  Widget cardInfo(context, bool isStartAddress, bool isIcon) {
    Widget addressInfo = Row(children: [
      Expanded(
        child: Text(isStartAddress ? startAddress : endAddress,
            style: TextStyle(
                fontSize: 14, color: Color(0xFF1A051D).withOpacity(0.5))),
      ),
      isIcon
          ? Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.location_on))
          : Container()
    ]);
    return addressInfo;
  }

  //Widget displaying the information of a ride after it has been requested. Shows the ride's
  //start location, end location, date, start and end time, recurring days,
  //and accessibility requests.
  Widget buildSummary(context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    return Column(children: [
      MergeSemantics(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text('From', style: CarriageTheme.labelStyle)
            ]),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Text(startLocation,
                        style: CarriageTheme.infoStyle))
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 15),
      MergeSemantics(
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[Text('To', style: CarriageTheme.labelStyle)],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: Text(endLocation,
                            style: CarriageTheme.infoStyle))
                  ],
                ),
              ]
          )
      ),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Start Date', style: CarriageTheme.labelStyle),
                        SizedBox(height: 5),
                        Text(DateFormat.yMd().format(startTime),
                            style: CarriageTheme.infoStyle)
                      ],
                    ),
                  )
              ),
              SizedBox(height: 20),
              MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Pickup Time', style: CarriageTheme.labelStyle),
                    SizedBox(height: 5),
                    Text(DateFormat.jm().format(startTime),
                        style: CarriageTheme.infoStyle)
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              endDate != null
                  ? Container(
                  child: MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('End Date', style: CarriageTheme.labelStyle),
                        SizedBox(height: 5),
                        Text(DateFormat.yMd().format(endDate),
                            style: CarriageTheme.infoStyle)
                      ],
                    ),
                  ))
                  : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(''),
                      SizedBox(height: 5),
                      Text('', style: CarriageTheme.infoStyle)
                    ],
                  )),
              SizedBox(height: 20),
              Container(
                  child: MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Drop-off Time',
                            style: CarriageTheme.labelStyle),
                        SizedBox(height: 5),
                        Text(DateFormat.jm().format(endTime),
                            style: CarriageTheme.infoStyle)
                      ],
                    ),
                  )
              )
            ],
          ),
        ],
      ),
      recurring ? Container(
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Every', style: CarriageTheme.labelStyle)
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(recurringDays.map((day) {
                      List<String> days = ['M', 'T', 'W', 'Th', 'F'];
                      return days[day-1];
                    }).toList().join(' '),
                      style: CarriageTheme.infoStyle,
                      semanticsLabel: recurringDays.map((day) {
                        List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
                        return days[day-1];
                      }).toList().join(' '),)
                  ],
                )
              ],
            ),
          ))
          : Container(),
      SizedBox(height: 15),
      MergeSemantics(
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Accessibility Requirement',
                        style: CarriageTheme.labelStyle)
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(riderProvider.info.accessibilityStr(), style: CarriageTheme.infoStyle)
                  ],
                ),
              ]
          )
      ),
    ]);
  }

  Ride copy() {
    return Ride(
        id: this.id,
        parentRide: this.parentRide,
        origDate: this.origDate,
        type: this.type,
        rider: this.rider,
        status: this.status,
        startLocation: this.startLocation,
        startAddress: this.startAddress,
        endLocation: this.endLocation,
        endAddress: this.endAddress,
        startTime: this.startTime,
        endTime: this.endTime,
        recurring: this.recurring,
        recurringDays: this.recurringDays,
        deleted: this.deleted,
        late: this.late,
        edits: this.edits,
        endDate: this.endDate,
        driver: this.driver);
  }
}
