import 'dart:math';
import 'package:carriage_rider/models/Ride.dart';

class RecurringRidesGenerator {
  RecurringRidesGenerator(this.parentRides);
  List<Ride> parentRides;

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

  /// Returns whether the recurring ride from backend [parentRide]'s list of deleted dates contains the start date of [generatedRide],
  /// representing a frontend-generated instance of a repeating ride that does not exist in backend yet.
  ///
  /// This indicates that the original instance has been deleted so it should NOT be generated in the app.
  bool wasDeleted(Ride generatedRide, Ride parentRide) {
    return parentRide.deleted.where((date) => sameDay(date, generatedRide.startTime)).isNotEmpty;
  }

  /// Returns a list of all single-time rides and all future instances of repeating rides, based on [parentRides].
  ///
  /// Instances of repeating rides that do not exist yet use a temporary ID. Their parent rides, meaning the rides
  /// in backend that they are generated from, will be used for editing instances of repeating rides that do not
  /// exist in backend yet.
  List<Ride> generateRecurringRides() {
    List<Ride> generatedRides = [];
    Map<String, Ride> originalRidesByID = Map();

    for (Ride originalRide in parentRides) {
      originalRidesByID[originalRide.id] = originalRide;
    }
    for (Ride originalRide in parentRides) {
      DateTime origStart = originalRide.startTime;
      Duration rideDuration = originalRide.endTime.difference(origStart);
      List<int> days = originalRide.recurringDays;

      // find first occurrence
      DateTime now = DateTime.now();
      DateTime rideCreationTime = DateTime(now.year, now.month, now.day, 10, 5);

      DateTime today = DateTime(now.year, now.month, now.day, origStart.hour, origStart.minute);
      DateTime firstPossibleDate = origStart.isBefore(today) ? today : originalRide.startTime;
      int daysUntilFirstOccurrence = days.map((day) => daysUntilWeekday(firstPossibleDate, day)).reduce(min);
      DateTime rideStart = firstPossibleDate.add(Duration(days: daysUntilFirstOccurrence));
      int dayIndex = days.indexOf(rideStart.weekday);

      // generate instances of recurring rides
      while (rideStart.isBefore(originalRide.endDate) || rideStart.isAtSameMomentAs(originalRide.endDate)) {
        // create the new ride and keep track of its parent to help with editing
        Ride rideInstance = Ride(
            parentID: originalRide.id,
            origDate: rideStart,
            startLocation: originalRide.startLocation,
            startAddress: originalRide.startAddress,
            endLocation: originalRide.endLocation,
            endAddress: originalRide.endAddress,
            startTime: rideStart,
            endTime: rideStart.add(rideDuration),
            recurring: false
        );

        bool rideAlreadyExists = sameDay(rideStart, today) || (now.isAfter(rideCreationTime) && sameDay(rideStart, today.add(Duration(days: 1))));
        if (!rideAlreadyExists && !wasDeleted(rideInstance, originalRide)) {
          generatedRides.add(rideInstance);
        }

        // find the next occurrence
        dayIndex = dayIndex == days.length - 1 ? 0 : dayIndex + 1;
        int daysUntilNextOccurrence = daysUntilWeekday(rideStart, days[dayIndex]);
        rideStart = rideStart.add(Duration(days: daysUntilNextOccurrence));
      }
    }
    return generatedRides..sort((r1, r2) => r1.startTime.isBefore(r2.startTime) ? -1 : 1);
  }
}
