import 'dart:convert';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Manage the state of rides with ChangeNotifier.
class CreateRideProvider with ChangeNotifier {
  Ride ride;
  TextEditingController fromCtrl = TextEditingController();
  TextEditingController toCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController dropOffCtrl = TextEditingController();

  bool isFinished() => fromCtrl.text != '' || toCtrl.text != '';

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

  /// Creates a ride in the backend by an HTTP POST request with the following fields:
  /// the location id if [startLocation] or [endLocation] is an already existing location or
  /// just the location name if it is a new location (not in backend yet) and
  /// a DateTime string converted into UTC time zone for [startTime] and [endTime].
  Future<void> createRide(
      AppConfig config,
      BuildContext context,
      RiderProvider riderProvider,
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
      throw Exception('Failed to create ride.');
    }
    clearControllers();
    notifyListeners();
  }
}
