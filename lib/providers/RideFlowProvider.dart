import 'dart:convert';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum RideFlowType { CREATE, EDIT_SINGLE, EDIT_ALL, EDIT_RECURRING }

/// Manage the state of rides with ChangeNotifier.
class RideFlowProvider with ChangeNotifier {
  RideFlowType rideFlowType;
  Ride origRide;

  TextEditingController startLocCtrl = TextEditingController();
  TextEditingController endLocCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController pickUpTimeCtrl = TextEditingController();
  TextEditingController dropOffTimeCtrl = TextEditingController();

  bool recurring;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay pickUpTime;
  TimeOfDay dropOffTime;
  List<bool> repeatDaysSelected = List.filled(5, false);

  bool requestHadError = false;

  bool locationsFinished() =>
      startLocCtrl.text != null &&
      startLocCtrl.text != '' &&
      endLocCtrl.text != null &&
      endLocCtrl.text != '';
  bool locationsEmpty() =>
      (startLocCtrl.text == null || startLocCtrl.text == '') &&
      (endLocCtrl.text == null || endLocCtrl.text == '');

  void clear() {
    startLocCtrl.clear();
    endLocCtrl.clear();
    startDateCtrl.clear();
    endDateCtrl.clear();
    pickUpTimeCtrl.clear();
    dropOffTimeCtrl.clear();
    startDate = null;
    endDate = null;
    pickUpTime = null;
    dropOffTime = null;
    repeatDaysSelected = List.filled(5, false);
    requestHadError = false;
    notifyListeners();
  }

  void initFromRide(BuildContext context, Ride ride) {
    setLocControllers(ride.startLocation, ride.endLocation);
    setPickUpTime(TimeOfDay.fromDateTime(ride.startTime), context);
    setDropOffTime(TimeOfDay.fromDateTime(ride.endTime), context);
    setStartDate(ride.startTime);
    if (ride.recurring) {
      setRecurring(true);
      setEndDate(ride.endDate);
      repeatDaysSelected = List.filled(5, false);
      ride.recurringDays.forEach((day) {
        repeatDaysSelected[day - 1] = true;
      });
    } else {
      setRecurring(false);
    }
    notifyListeners();
  }

  Ride assembleRide(BuildContext context) {
    Ride ride = Ride(
      startLocation: startLocCtrl.text,
      endLocation: endLocCtrl.text,
      startTime: assembleStartTime(),
      endTime: assembleEndTime(),
    );
    if (recurring) {
      ride.recurring = true;
      ride.endDate = endDate;
      ride.recurringDays = assembleRecurringDays();
    } else {
      ride.recurring = false;
    }
    return ride;
  }

  void _setFlowType(RideFlowType type) {
    rideFlowType = type;
    notifyListeners();
  }

  bool creating() => rideFlowType == RideFlowType.CREATE;
  bool editingSingle() => rideFlowType == RideFlowType.EDIT_SINGLE;
  bool editingAll() => rideFlowType == RideFlowType.EDIT_ALL;
  bool editingRecurringSingle() => rideFlowType == RideFlowType.EDIT_RECURRING;

  void setCreating() {
    _setFlowType(RideFlowType.CREATE);
    notifyListeners();
  }

  void setEditingSingle(BuildContext context, Ride ride) {
    _setFlowType(RideFlowType.EDIT_SINGLE);
    origRide = ride;
    initFromRide(context, ride);
    notifyListeners();
  }

  void setEditingAll(BuildContext context, Ride parentRide) {
    _setFlowType(RideFlowType.EDIT_ALL);
    origRide = parentRide;
    initFromRide(context, parentRide);
    notifyListeners();
  }

  void setEditingRecurringSingle(BuildContext context, Ride ride) {
    _setFlowType(RideFlowType.EDIT_RECURRING);
    origRide = ride;
    initFromRide(context, ride);
    notifyListeners();
  }

  void setRecurring(bool isRecurring) {
    recurring = isRecurring;
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    startDate = date;
    startDateCtrl.text = DateFormat('yMd').format(date);
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    endDateCtrl.text = DateFormat('yMd').format(date);
    notifyListeners();
  }

  void setPickUpTime(TimeOfDay time, BuildContext context) {
    pickUpTime = time;
    pickUpTimeCtrl.text = time.format(context);
    notifyListeners();
  }

  void setDropOffTime(TimeOfDay time, BuildContext context) {
    dropOffTime = time;
    dropOffTimeCtrl.text = time.format(context);
    notifyListeners();
  }

  void setLocControllers(String fromLocation, String toLocation) {
    startLocCtrl.text = fromLocation;
    endLocCtrl.text = toLocation;
    notifyListeners();
  }

  void setError(bool hadError) {
    requestHadError = hadError;
    notifyListeners();
  }

  void setRepeatDays(List<bool> selected) {
    repeatDaysSelected = selected;
    notifyListeners();
  }

  void toggleRepeatDays(int index) {
    repeatDaysSelected[index] = !repeatDaysSelected[index];
    notifyListeners();
  }

  DateTime assembleStartTime() => DateTime(startDate.year, startDate.month,
      startDate.day, pickUpTime.hour, pickUpTime.minute);
  String assembleStartTimeString() =>
      assembleStartTime().toUtc().toIso8601String();
  DateTime assembleEndTime() => DateTime(startDate.year, startDate.month,
      startDate.day, dropOffTime.hour, dropOffTime.minute);
  String assembleEndTimeString() => assembleEndTime().toUtc().toIso8601String();

  String assembleStartLocation(LocationsProvider locationsProvider) {
    String input = startLocCtrl.text;
    if (locationsProvider.isPreset(input)) {
      return locationsProvider.locationByName(input).id;
    }
    return input;
  }

  String assembleEndLocation(LocationsProvider locationsProvider) {
    String input = endLocCtrl.text;
    if (locationsProvider.isPreset(input)) {
      return locationsProvider.locationByName(input).id;
    }
    return input;
  }

  List<int> assembleRecurringDays() {
    List<int> recurringDays = [];
    for (int i = 0; i < repeatDaysSelected.length; i++) {
      if (repeatDaysSelected[i]) {
        recurringDays.add(i + 1);
      }
    }
    return recurringDays;
  }

  Future<bool> updateRecurringRide(
      BuildContext context, Ride origRide, Ride parentRide) async {
    AppConfig config = AppConfig.of(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    Map<String, dynamic> request = <String, dynamic>{
      'id': parentRide.id,
      'deleteOnly': false,
      'origDate': DateFormat('yyyy-MM-dd').format(parentRide.origDate != null
          ? parentRide.origDate
          : origRide.startTime),
      'startLocation': assembleStartLocation(locationsProvider),
      'endLocation': assembleEndLocation(locationsProvider),
      'startTime': assembleStartTimeString(),
      'endTime': assembleEndTimeString()
    };
    final response =
        await http.put('${config.baseUrl}/rides/${parentRide.id}/edits',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
            body: jsonEncode(request));
    if (response.statusCode != 200) {
      print('Failed to edit instance of recurring ride: ${response.body}');
      return false;
    }
    return true;
  }

  Future<bool> updateRide(BuildContext context) async {
    AppConfig config = AppConfig.of(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);

    String token = await authProvider.secureStorage.read(key: 'token');
    Map<String, dynamic> request = <String, dynamic>{
      'startLocation': assembleStartLocation(locationsProvider),
      'endLocation': assembleEndLocation(locationsProvider),
      'startTime': assembleStartTimeString(),
      'endTime': assembleEndTimeString()
    };
    if (recurring) {
      request['recurring'] = true;
      request['endDate'] = DateTime.parse(DateFormat('y-MM-dd').format(endDate))
          .toIso8601String()
          .substring(0, 10);
      request['recurringDays'] = assembleRecurringDays();
    }
    final response = await http.put('${config.baseUrl}/rides/${origRide.id}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(request));
    if (response.statusCode != 200) {
      print('Failed to update ride: ${response.body}');
      return false;
    }
    notifyListeners();
    return true;
  }

  /// Creates a ride in the backend by an HTTP POST request with the following fields:
  /// the location id if [startLocation] or [endLocation] is an already existing location or
  /// just the location name if it is a new location (not in backend yet) and
  /// a DateTime string converted into UTC time zone for [startTime] and [endTime].
  /// Returns whether the request was successful or not.
  Future<bool> createRide(BuildContext context) async {
    AppConfig config = AppConfig.of(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);
    RiderProvider riderProvider =
        Provider.of<RiderProvider>(context, listen: false);

    String token = await authProvider.secureStorage.read(key: 'token');
    Map<String, dynamic> request = <String, dynamic>{
      'rider': riderProvider.info.id,
      'startLocation': assembleStartLocation(locationsProvider),
      'endLocation': assembleEndLocation(locationsProvider),
      'startTime': assembleStartTimeString(),
      'endTime': assembleEndTimeString()
    };
    if (recurring) {
      request['recurring'] = true;
      request['endDate'] = DateTime.parse(DateFormat('y-MM-dd').format(endDate))
          .toIso8601String()
          .substring(0, 10);
      request['recurringDays'] = assembleRecurringDays();
    }

    final response = await http.post('${config.baseUrl}/rides',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(request));
    if (response.statusCode != 200) {
      print('Failed to create ride: ${response.body}');
      return false;
    }
    return true;
  }

  Future<bool> request(BuildContext context) async {
    bool successful;
    // update fake instance for recurring ride
    if (editingRecurringSingle()) {
      successful = await updateRecurringRide(
          context,
          origRide,
          // if editing first instance, it exists and is its own parent
          origRide.parentRide != null ? origRide.parentRide : origRide);
    }
    // update real instance; parent to edit all, or regular single ride
    else if (editingAll() || editingSingle()) {
      successful = await updateRide(context);
    } else if (creating()) {
      successful = await createRide(context);
    } else {
      throw Exception('Invalid ride flow type');
    }
    AppConfig config = AppConfig.of(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);
    await locationsProvider.fetchLocations(config, authProvider);
    RidesProvider ridesProvider =
        Provider.of<RidesProvider>(context, listen: false);
    await ridesProvider.fetchAllRides(config, authProvider);
    notifyListeners();

    return successful;
  }
}
