// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:carriage_rider/CarriageTheme.dart';
import 'package:carriage_rider/Ride.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Ride urisCasc = Ride(
    id: 'urisCasc',
    type: 'past',
    status: 'not_started',
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
    status: 'not_started',
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
    status: 'not_started',
    startLocation: 'Uris Hall',
    endLocation: 'Cascadilla Hall',
    startTime: DateTime(2020, 10, 18, 13, 10),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  Ride urisCascEnd = Ride(
    id: 'urisCascEnd',
    type: 'past',
    status: 'not_started',
    startLocation: 'Uris Hall',
    endLocation: 'Cascadilla Hall',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 20),
  );

  Ride balchCasc = Ride(
    id: 'urisCascStartLoc',
    type: 'past',
    status: 'not_started',
    startLocation: 'Balch Hall',
    endLocation: 'Cascadilla Hall',
    startTime: DateTime(2020, 10, 18, 13, 0),
    requestedEndTime: DateTime(2020, 10, 18, 13, 15),
  );

  Ride urisBalch = Ride(
    id: 'urisCascEndLoc',
    type: 'past',
    status: 'not_started',
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
    status: 'not_started',
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
    status: 'not_started',
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

  FutureRidesGenerator generator = FutureRidesGenerator(testRides);

  nextDateOnWeekdayTest(String name, DateTime start, weekday, DateTime correct) {
    test(name, () {
      DateTime nextDay = generator.nextDateOnWeekday(start, weekday);
      expect(nextDay.isAtSameMomentAs(correct), true);
    });
  }

  rideListsEqual(List<Ride> list1, List<Ride> list2) {
    List<Ride> list2Copy = [];
    list2.forEach((ride) => list2Copy.add(ride));

    for (Ride r1 in list1) {
      list2Copy..removeWhere((r2) => generator.ridesEqualTimeLoc(r1, r2));
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

  group('nextDateOnWeekday tests', () {
    nextDateOnWeekdayTest(
        'weekday = start day, Monday after 12/14 is 12/14',
        DateTime(2020, 12, 14, 3, 0), 1, DateTime(2020, 12, 14, 3, 0)
    );
    nextDateOnWeekdayTest(
        'weekday > start day, Thursday after 12/15 is 12/17',
        DateTime(2020, 12, 15, 3, 0), 4, DateTime(2020, 12, 17, 3, 0)
    );
    nextDateOnWeekdayTest(
        'weekday < start day, Monday after 12/15 is 12/21',
        DateTime(2020, 12, 18, 14, 0), 1, DateTime(2020, 12, 21, 14, 0)
    );
  });

  group('ridesEqualTimeLoc tests', () {
    test('ride object is equal to itself', () {
      expect(generator.ridesEqualTimeLoc(oneTimeRide, oneTimeRide), true);
    });
    test('different ride objects with all fields the same are equal', () {
      expect(generator.ridesEqualTimeLoc(urisCasc, urisCascCopy), true);
    });
    test('rides with start time different are not equal', () {
      expect(generator.ridesEqualTimeLoc(urisCasc, urisCascStart), false);
    });
    test('rides with end time different are not equal', () {
      expect(generator.ridesEqualTimeLoc(urisCasc, urisCascEnd), false);
    });
    test('rides with start location different are not equal', () {
      expect(generator.ridesEqualTimeLoc(urisCasc, balchCasc), false);
    });
    test('rides with end location different are not equal', () {
      expect(generator.ridesEqualTimeLoc(urisCasc, urisBalch), false);
    });
    test('rides with start address different are not equal', () {
      expect(generator.ridesEqualTimeLoc(urisCasc, urisCascStartAddress), false);
    });
    test('rides with end address different are not equal', () {
      expect(generator.ridesEqualTimeLoc(urisCasc, urisCascEndAddress), false);
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
      expect(rideListsEqual(generator.generateFutureRides(), expectedGeneratedRides), true);
    });

  });

}
