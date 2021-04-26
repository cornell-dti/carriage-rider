import 'dart:convert';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Manage the state of rides with ChangeNotifier.
class RideFlowProvider with ChangeNotifier {
  bool editing;
  TextEditingController fromCtrl = TextEditingController();
  TextEditingController toCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController dropOffCtrl = TextEditingController();

  bool locationsFinished() => fromCtrl.text != null && fromCtrl.text != '' && toCtrl.text != null && toCtrl.text != '';

  void setEditing(bool isEditing) {
    editing = isEditing;
    notifyListeners();
  }

  void setStartDateCtrl(DateTime date) {
    startDateCtrl.text = DateFormat('yMd').format(date);
    notifyListeners();
  }

  void setEndDateCtrl(DateTime date) {
    endDateCtrl.text = DateFormat('yMd').format(date);
    notifyListeners();
  }

  void setPickupTimeCtrl(String time) {
    pickUpCtrl.text = time;
    notifyListeners();
  }

  void setDropoffTimeCtrl(String time) {
    dropOffCtrl.text = time;
    notifyListeners();
  }

  void setLocControllers(String fromLocation, String toLocation) {
    fromCtrl.text = fromLocation;
    toCtrl.text = toLocation;
    notifyListeners();
  }

  void clearControllers() {
    fromCtrl.clear();
    toCtrl.clear();
    startDateCtrl.clear();
    endDateCtrl.clear();
    pickUpCtrl.clear();
    dropOffCtrl.clear();
    notifyListeners();
  }

  Future<void> updateRecurringRide(
      AppConfig config,
      BuildContext context,
      String parentRideID,
      DateTime origDate,
      String startLocation,
      String endLocation,
      DateTime startTime,
      DateTime endTime,
      bool recurring,
      {DateTime endDate,
        List<int> recurringDays}) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    Map<String, dynamic> request = <String, dynamic>{
      'id': parentRideID,
      'deleteOnly': false,
      'origDate': DateFormat('yyyy-MM-dd').format(origDate),
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
    };
    print('update recurring');
    print(request);
    final response = await http.put('${config.baseUrl}/rides/$parentRideID/edits',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(request));
    if (response.statusCode != 200) {
      throw Exception('Failed to edit instance of recurring ride: ${response.body}');
    }
    clearControllers();
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
    await ridesProvider.fetchAllRides(config, authProvider);
    notifyListeners();
  }

  Future<void> updateRide(
      AppConfig config,
      BuildContext context,
      String rideID,
      String startLocation,
      String endLocation,
      DateTime startTime,
      DateTime endTime,
      bool recurring,
      {DateTime endDate,
        List<int> recurringDays}) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    Map<String, dynamic> request = <String, dynamic>{
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
    };
    if (recurring) {
      request['recurring'] = true;
      request['endDate'] = DateTime.parse(DateFormat('y-MM-dd').format(endDate))
          .toIso8601String()
          .substring(0, 10);
      request['recurringDays'] = recurringDays;
    }
    print('update single');
    print(request);
    final response = await http.put('${config.baseUrl}/rides/$rideID',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(request));
    if (response.statusCode != 200) {
      throw Exception('Failed to update ride: ${response.body}');
    }
    clearControllers();
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
    await ridesProvider.fetchAllRides(config, authProvider);
    notifyListeners();
  }

  /// Creates a ride in the backend by an HTTP POST request with the following fields:
  /// the location id if [startLocation] or [endLocation] is an already existing location or
  /// just the location name if it is a new location (not in backend yet) and
  /// a DateTime string converted into UTC time zone for [startTime] and [endTime].
  Future<void> createRide(
      AppConfig config,
      BuildContext context,
      String startLocation,
      String endLocation,
      DateTime startTime,
      DateTime endTime,
      bool recurring,
      {DateTime endDate,
        List<int> recurringDays}) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    RiderProvider riderProvider = Provider.of<RiderProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    Map<String, dynamic> request = <String, dynamic>{
      'rider': riderProvider.info.id,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
    };
    if (recurring) {
      request['recurring'] = true;
      request['endDate'] = DateTime.parse(DateFormat('y-MM-dd').format(endDate))
          .toIso8601String()
          .substring(0, 10);
      request['recurringDays'] = recurringDays;
    }

    final response = await http.post('${config.baseUrl}/rides',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(request));
    if (response.statusCode != 200) {
      throw Exception('Failed to create ride: ${response.body}');
    }
    clearControllers();
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context, listen: false);
    await ridesProvider.fetchAllRides(config, authProvider);
    notifyListeners();
  }
}
