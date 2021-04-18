import 'dart:math';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/widgets/RideCard.dart';
import 'package:flutter/material.dart';
import 'CarriageTheme.dart';

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