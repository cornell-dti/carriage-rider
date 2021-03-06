import 'dart:core';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'dart:math';
import 'package:carriage_rider/pages/Upcoming.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../utils/CarriageTheme.dart';

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
  final DateTime requestedEndTime;

  //The ride status. Can only be 'not_started', 'on_the_way', 'picked_up', 'no_show', or 'completed'.
  final String status;

  //Indicates whether a ride is late
  final bool late;

  //The driver associated with this ride
  final Map<String, dynamic> driver;

  //The IDs of rides corresponding to edits
  final List<String> edits;

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
      this.endTime,
      this.requestedEndTime,
      this.recurring,
      this.recurringDays,
      this.deleted,
      this.late,
      this.edits,
      this.endDate,
      this.driver});

  //Creates a ride from JSON representation
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
      startTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(json['startTime'], true)
          .toLocal(),
      endTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(json['endTime'], true)
          .toLocal(),
      requestedEndTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(json['requestedEndTime'], true)
          .toLocal(),
      recurring: json['recurring'] == null ? false : json['recurring'],
      recurringDays:
          json['recurringDays'] == null ? [] : List.from(json['recurringDays']),
      deleted: json['deleted'] == null ? false : json['deleted'],
      late: json['late'],
      driver: json['driver'] == null ? null : json['driver'],
      edits: json['edits'] == null ? [] : List.from(json['edits']),
      endDate: json['endDate'] == null
          ? null
          : DateFormat('MM/dd/yyyy').parse(json['endDate']),
    );
  }

  //Widget displaying the start time of a ride using DateFormat.
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
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Text('From', style: CarriageTheme.caption2)]),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text(startLocation, style: CarriageTheme.infoStyle)],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text('To', style: CarriageTheme.caption2)],
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text(endLocation, style: CarriageTheme.infoStyle)],
      ),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text('Date', style: CarriageTheme.caption2)],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(DateFormat('yMd').format(startTime),
              style: CarriageTheme.infoStyle)
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
                Text('Pickup Time', style: CarriageTheme.caption2),
                SizedBox(height: 5),
                Text(DateFormat('jm').format(startTime),
                    style: CarriageTheme.infoStyle)
              ],
            ),
          ),
          SizedBox(width: 30),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Drop-off Time', style: CarriageTheme.caption2),
                SizedBox(height: 5),
                Text(DateFormat('jm').format(endTime),
                    style: CarriageTheme.infoStyle)
              ],
            ),
          )
        ],
      ),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Text('Every', style: CarriageTheme.caption2)],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //TODO: change to have repeating rides info
          Text('M W F', style: CarriageTheme.infoStyle)
        ],
      ),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Accessibility Request', style: CarriageTheme.caption2)
        ],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
              riderProvider.hasInfo()
                  ? riderProvider.info.accessibilityStr()
                  : '',
              style: CarriageTheme.infoStyle)
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    UpcomingRidePage(ride, parentRideID: parentRideID)));
      },
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: CarriageTheme.cardDecoration,
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
                                  //TODO: replace temp phone number
                                  onTap: () =>
                                      UrlLauncher.launch('tel://13232315234'),
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
    );
  }
}

class RecurringRidesGenerator {
  RecurringRidesGenerator(this.originalRides);

  List<Ride> originalRides;

  int daysUntilWeekday(DateTime start, int weekday) {
    int startWeekday = start.weekday;
    if (weekday < startWeekday) {
      weekday += 7;
    }
    return weekday - startWeekday;
  }

  DateTime nextDateOnWeekday(DateTime start, int weekday) {
    int daysUntil = daysUntilWeekday(start, weekday);
    return start.add(Duration(days: daysUntil));
  }

  bool ridesEqualTimeLoc(Ride ride, Ride otherRide) {
    return (ride.startTime.isAtSameMomentAs(otherRide.startTime) &&
        ride.endTime.isAtSameMomentAs(otherRide.endTime) &&
        ride.startLocation == otherRide.startLocation &&
        ride.endLocation == otherRide.endLocation &&
        ride.startAddress == otherRide.startAddress &&
        ride.endAddress == otherRide.endAddress);
  }

  bool wasDeleted(Ride generatedRide, List<Ride> deletedRides) {
    return deletedRides
        .where((deletedRide) => ridesEqualTimeLoc(deletedRide, generatedRide))
        .isNotEmpty;
  }

  List<Ride> generateRideInstances() {
    List<Ride> allRides = [];
    Map<String, Ride> originalRidesByID = Map();
    Map<Ride, String> rideInstanceParentIDs = Map();

    for (Ride originalRide in originalRides) {
      originalRidesByID[originalRide.id] = originalRide;
    }
    for (Ride originalRide in originalRides) {
      // add one time rides
      if (!originalRide.deleted && !originalRide.recurring) {
        allRides.add(originalRide);
      }

      if (originalRide.recurring) {
        Duration rideDuration =
            originalRide.endTime.difference(originalRide.startTime);
        List<Ride> deletedInstances = originalRide.edits
            .map((rideID) => originalRidesByID[rideID])
            .where((ride) => ride.deleted)
            .toList();
        List<int> days = originalRide.recurringDays;

        // find first occurrence
        int daysUntilFirstOccurrence = days
            .map((day) => daysUntilWeekday(originalRide.startTime, day))
            .reduce(min);
        DateTime rideStart = originalRide.startTime
            .add(Duration(days: daysUntilFirstOccurrence));
        int dayIndex = days.indexOf(rideStart.weekday);

        // generate instances of recurring rides
        while (rideStart.isBefore(originalRide.endDate) ||
            rideStart.isAtSameMomentAs(originalRide.endDate)) {
          // create the new ride and keep track of its parent
          Ride rideInstance = Ride(
              id: CarriageTheme.generatedRideID,
              startLocation: originalRide.startLocation,
              startAddress: originalRide.startAddress,
              endLocation: originalRide.endLocation,
              endAddress: originalRide.endAddress,
              startTime: rideStart,
              endTime: rideStart.add(rideDuration));
          rideInstanceParentIDs[rideInstance] = originalRide.id;

          // if all ride info is equal to a deleted ride, don't add it because it was edited
          if (!wasDeleted(rideInstance, deletedInstances)) {
            allRides.add(rideInstance);
          }

          // find the next occurrence
          dayIndex = dayIndex == days.length - 1 ? 0 : dayIndex + 1;
          int daysUntilNextOccurrence =
              daysUntilWeekday(rideStart, days[dayIndex]);
          rideStart = rideStart.add(Duration(days: daysUntilNextOccurrence));
        }
      }
    }
    return allRides;
  }

  List<Ride> upcomingRides() {
    List<Ride> allRides = generateRideInstances();
    return allRides
        .where((ride) => ride.startTime.isAfter(DateTime.now()))
        .toList()
          ..sort((ride1, ride2) =>
              ride1.startTime.isBefore(ride2.startTime) ? -1 : 1);
  }

  ListView buildUpcomingRidesList() {
    List futureRides = upcomingRides();
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: futureRides.length,
      itemBuilder: (context, index) {
        return RideCard(
          futureRides[index],
          showConfirmation: true,
          showCallDriver: false,
          showArrow: true,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 16);
      },
    );
  }

  ListView buildPastRidesList() {
    List<Ride> allRides = generateRideInstances()
      ..sort(
          (ride1, ride2) => ride1.startTime.isBefore(ride2.startTime) ? 1 : -1);
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: allRides.length,
      itemBuilder: (context, index) {
        return RideCard(
          allRides[index],
          showConfirmation: false,
          showCallDriver: false,
          showArrow: true,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 16);
      },
    );
  }
}
