// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/utils/RecurringRidesGenerator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Ride urisCasc = Ride(
    id: 'urisCasc',
    type: 'past',
    status: RideStatus.NOT_STARTED,
    startLocation: 'Uris Hall',
    endLocation: 'Cascadilla Hall',
    startAddress: '123 Carriage Way',
    endAddress: '123 Carriage Ln',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  Ride urisCascCopy = Ride(
    id: 'urisCascCopy',
    type: 'past',
    status: RideStatus.NOT_STARTED,
    startLocation: 'Uris Hall',
    endLocation: 'Cascadilla Hall',
    startAddress: '123 Carriage Way',
    endAddress: '123 Carriage Ln',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  Ride urisCascStart = Ride(
    id: 'urisCascStart',
    type: 'past',
    status: RideStatus.NOT_STARTED,
    startLocation: 'Uris Hall',
    endLocation: 'Cascadilla Hall',
    startTime: DateTime(2020, 10, 18, 13, 10),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  Ride urisCascEnd = Ride(
    id: 'urisCascEnd',
    type: 'past',
    status: RideStatus.NOT_STARTED,
    startLocation: 'Uris Hall',
    endLocation: 'Cascadilla Hall',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 20),
  );

  Ride balchCasc = Ride(
    id: 'urisCascStartLoc',
    type: 'past',
    status: RideStatus.NOT_STARTED,
    startLocation: 'Balch Hall',
    endLocation: 'Cascadilla Hall',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  Ride urisBalch = Ride(
    id: 'urisCascEndLoc',
    type: 'past',
    status: RideStatus.NOT_STARTED,
    startLocation: 'Uris Hall',
    endLocation: 'Balch Hall',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  Ride origRepeating = Ride(
    id: 'abc',
    startLocation: 'Olin Hall',
    endLocation: 'Duffield Hall',
    startTime: DateTime(2020, 12, 15, 13, 0),
    requestedEndTime: DateTime(2020, 12, 15, 13, 15),
    recurring: true,
    recurringDays: [1,3,5],
    deleted: false,
    edits: ['abcdeleted', 'abcdedited'],
    endDate: DateTime(2020, 12, 23, 13, 0),

  );

  Ride deletedInstance = Ride(
    id: 'abcdeleted',
    startLocation: 'Olin Hall',
    endLocation: 'Duffield Hall',
    startTime: DateTime(2020, 12, 18, 13, 0),
    requestedEndTime: DateTime(2020, 12, 18, 13, 15),
    recurring: false,
    recurringDays: [],
    deleted: true,
    edits: [],
  );

  Ride editedTimeInstance = Ride(
    id: 'abcdedited',
    startLocation: 'Olin Hall',
    endLocation: 'Duffield Hall',
    startTime: DateTime(2020, 12, 18, 14, 0),
    requestedEndTime: DateTime(2020, 12, 18, 14, 15),
    recurring: false,
    recurringDays: [],
    deleted: false,
    edits: [],
  );

  Ride oneTimeRide = Ride(
    id: 'ijk',
    startLocation: 'Balch Hall',
    endLocation: 'Duffield Hall',
    startTime: DateTime(2020, 12, 30, 16, 0),
    requestedEndTime: DateTime(2020, 12, 30, 16, 30),
    recurring: false,
    recurringDays: [],
    deleted: false,
    edits: [],
  );

  Ride urisCascStartAddress = Ride(
    id: 'urisCascCopy',
    type: 'past',
    status: RideStatus.NOT_STARTED,
    startLocation: 'Uris Hall',
    endLocation: 'Cascadilla Hall',
    startAddress: '321 Carriage Way',
    endAddress: '123 Carriage Ln',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  Ride urisCascEndAddress = Ride(
    id: 'urisCascCopy',
    type: 'past',
    status: RideStatus.NOT_STARTED,
    startLocation: 'Uris Hall',
    endLocation: 'Cascadilla Hall',
    startAddress: '123 Carriage Way',
    endAddress: '321 Carriage Ln',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  List<Ride> testRides = [
    origRepeating,
    deletedInstance,
    editedTimeInstance,
    oneTimeRide
  ];

  bool ridesEqualTimeLoc(Ride ride, Ride otherRide) {
    return (ride.startTime.isAtSameMomentAs(otherRide.startTime) &&
        ride.endTime.isAtSameMomentAs(otherRide.endTime) &&
        ride.startLocation == otherRide.startLocation &&
        ride.endLocation == otherRide.endLocation &&
        ride.startAddress == otherRide.startAddress &&
        ride.endAddress == otherRide.endAddress);
  }

  List<Ride> expectedGeneratedRides = [
    editedTimeInstance,
    oneTimeRide,
    Ride(
        id: CarriageTheme.generatedRideID,
        startLocation: 'Olin Hall',
        endLocation: 'Duffield Hall',
        startTime: DateTime(2020, 12, 16, 13, 0),
        requestedEndTime: DateTime(2020, 12, 16, 13, 15)
    ),
    Ride(
        id: CarriageTheme.generatedRideID,
        startLocation: 'Olin Hall',
        endLocation: 'Duffield Hall',
        startTime: DateTime(2020, 12, 21, 13, 0),
        requestedEndTime: DateTime(2020, 12, 21, 13, 15)
    ),
    Ride(
        id: CarriageTheme.generatedRideID,
        startLocation: 'Olin Hall',
        endLocation: 'Duffield Hall',
        startTime: DateTime(2020, 12, 23, 13, 0),
        requestedEndTime: DateTime(2020, 12, 23, 13, 15)
    )
  ];

  RecurringRidesGenerator generator = RecurringRidesGenerator(testRides);

  rideListsEqual(List<Ride> list1, List<Ride> list2) {
    List<Ride> list2Copy = [];
    list2.forEach((ride) => list2Copy.add(ride));

    for (Ride r1 in list1) {
      list2Copy..removeWhere((r2) => ridesEqualTimeLoc(r1, r2));
    }
    return list2Copy.isEmpty;
  }

  group('daysUntilWeekday tests', () {
    test('weekday = start day gets 0', () {
      expect(generator.daysUntilWeekday(DateTime(2020, 12, 15), 2), 0);
    });
    test('weekday > start day, 2 days after gets 2', () {
      expect(generator.daysUntilWeekday(DateTime(2020, 12, 15), 4), 2);
    });
    test('weekday < start day, 3 days after gets 3', () {
      expect(generator.daysUntilWeekday(DateTime(2020, 12, 18), 1), 3);
    });
  });

  group('ridesEqualTimeLoc tests', () {
    test('ride object is equal to itself', () {
      expect(ridesEqualTimeLoc(oneTimeRide, oneTimeRide), true);
    });
    test('different ride objects with all fields the same are equal', () {
      expect(ridesEqualTimeLoc(urisCasc, urisCascCopy), true);
    });
    test('rides with start time different are not equal', () {
      expect(ridesEqualTimeLoc(urisCasc, urisCascStart), false);
    });
    test('rides with end time different are not equal', () {
      expect(ridesEqualTimeLoc(urisCasc, urisCascEnd), false);
    });
    test('rides with start location different are not equal', () {
      expect(ridesEqualTimeLoc(urisCasc, balchCasc), false);
    });
    test('rides with end location different are not equal', () {
      expect(ridesEqualTimeLoc(urisCasc, urisBalch), false);
    });
    test('rides with start address different are not equal', () {
      expect(ridesEqualTimeLoc(urisCasc, urisCascStartAddress), false);
    });
    test('rides with end address different are not equal', () {
      expect(ridesEqualTimeLoc(urisCasc, urisCascEndAddress), false);
    });
  });

  group('wasDeleted tests', () {
    test('the original version of a future ride that was edited was deleted', () {
      Ride ride = Ride(
        id: 'abc123',
        startLocation: 'Olin Hall',
        endLocation: 'Duffield Hall',
        startTime: DateTime(2020, 12, 18, 13, 0),
        requestedEndTime: DateTime(2020, 12, 18, 13, 15),
      );
      expect(generator.wasDeleted(ride, testRides), true);
    });

    test('generated future ride that is NOT in the list was NOT deleted', () {
      Ride ride = Ride(
        id: 'abc123',
        startLocation: 'Olin Hall',
        endLocation: 'Duffield Hall',
        startTime: DateTime(2020, 12, 23, 13, 0),
        requestedEndTime: DateTime(2020, 12, 23, 13, 15),
      );
      expect(generator.wasDeleted(ride, testRides), false);

    });
    test('one time ride that is in the list was NOT deleted', () {
      expect(generator.wasDeleted(oneTimeRide, testRides), true);
    });
  });

  group ('generate rides tests', () {
    test('list including single ride and recurring ride with edits is generated correctly', () {
      expect(rideListsEqual(generator.generateRideInstances(), expectedGeneratedRides), true);
    });
  });
}
