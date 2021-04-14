import 'dart:math';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/widgets/RideCard.dart';
import 'package:flutter/material.dart';
import 'CarriageTheme.dart';

class RecurringRidesGenerator {
  RecurringRidesGenerator(this.originalRides);
  List<Ride> originalRides;

  bool sameDay(DateTime dateTime, DateTime other) {
    return dateTime.year == other.year &&
        dateTime.month == other.month &&
        dateTime.day == other.day;
  }
  /// Returns the number of days between [start] and the next day that falls on [weekday].
  ///
  /// The weekday numbering follows Flutter's convention where 1 to 7 are Monday to Sunday.
  /// If [start] falls on [weekday], returns 7.
  int daysUntilWeekday(DateTime start, int weekday) {
    int startWeekday = start.weekday;
    if (weekday < startWeekday) {
      weekday += 7;
    }
    int days = weekday - startWeekday;
    if (days == 0) {
      return 7;
    }
    return days;
  }

  /// Returns whether [deletedRides], representing a list of deleted rides from backend, contains a ride with the
  /// same date as [generatedRide], representing a frontend-generated instance of a repeating ride that does not
  /// exist in backend yet.
  bool wasDeleted(Ride generatedRide, List<Ride> deletedRides) {
    return deletedRides.where((deletedRide) => sameDay(deletedRide.startTime, generatedRide.startTime)).isNotEmpty;
  }

  /// Returns a list of all single-time rides and all future instances of repeating rides, based on [originalRides].
  ///
  /// Instances of repeating rides that do not exist yet use a temporary ID. Their parent rides, meaning the rides
  /// in backend that they are generated from, will be used for editing instances of repeating rides that do not
  /// exist in backend yet.
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
        print(originalRide.id);
        Duration rideDuration = originalRide.endTime.difference(originalRide.startTime);
        List<Ride> deletedInstances = originalRide.edits.map((rideID) => originalRidesByID[rideID]).where((ride) => ride != null && ride.deleted).toList();
        List<int> days = originalRide.recurringDays;

        // find first occurrence
        int daysUntilFirstOccurrence = days.map((day) => daysUntilWeekday(originalRide.startTime, day)).reduce(min);
        DateTime rideStart = originalRide.startTime.add(Duration(days: daysUntilFirstOccurrence));
        int dayIndex = days.indexOf(rideStart.weekday);

        // generate instances of recurring rides
        while (rideStart.isBefore(originalRide.endDate) || rideStart.isAtSameMomentAs(originalRide.endDate)) {
          print(rideStart);
          // create the new ride and keep track of its parent
          Ride rideInstance = Ride(
              id: CarriageTheme.generatedRideID,
              startLocation: originalRide.startLocation,
              startAddress: originalRide.startAddress,
              endLocation: originalRide.endLocation,
              endAddress: originalRide.endAddress,
              startTime: rideStart,
              endTime: rideStart.add(rideDuration)
          );
          rideInstanceParentIDs[rideInstance] = originalRide.id;

          // if all ride info is equal to a deleted ride, don't add it because it was edited
          if (!wasDeleted(rideInstance, deletedInstances)) {
            allRides.add(rideInstance);
          }

          // find the next occurrence
          dayIndex = dayIndex == days.length - 1 ? 0 : dayIndex + 1;
          int daysUntilNextOccurrence = daysUntilWeekday(rideStart, days[dayIndex]);
          rideStart = rideStart.add(Duration(days: daysUntilNextOccurrence));
        }
        print('exit while');
      }
    }
    return allRides;
  }

  ListView buildUpcomingRidesList() {
    List futureRides = generateRideInstances().where((ride) => ride.type != 'past').toList()..sort((r1, r2) => r1.startTime.isBefore(r2.startTime) ? -1 : 1);
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
}
