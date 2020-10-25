import 'dart:convert';
import 'package:carriage_rider/RiderProvider.dart';
import 'app_config.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/RideProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PastRidesProvider with ChangeNotifier {
  PastRidesProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) {
        fetchRides(config, authProvider);
      }
    };
    callback();
    authProvider.addListener(callback);
  }

  Future<List<Ride>> fetchRides(
      AppConfig config, AuthProvider authProvider) async {
    final response = await http
        .get('${config.baseUrl}/rides?type=past&rider=${authProvider.id}');
    if (response.statusCode == 200) {
      String responseBody = response.body;
      List<Ride> rides = _ridesFromJson(responseBody);
      return rides;
    } else {
      throw Exception('Failed to load rides.');
    }
  }

  List<Ride> _ridesFromJson(String json) {
    var data = jsonDecode(json)["data"];
    List<Ride> res = data.map<Ride>((e) => Ride.fromJson(e)).toList();
    res.sort((a, b) => a.startTime.compareTo(b.startTime));
    return res;
  }

  Future<void> createRide(
      AppConfig config,
      RiderProvider riderProvider,
      String startLocation,
      String endLocation,
      String startTime,
      String endTime) async {
    final response = await http.post(
      "${config.baseUrl}/rides",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'rider': riderProvider.info,
        'startLocation': startLocation,
        'endLocation': endLocation,
        'startTime': startTime,
        'endTime': endTime,
      }),
    );
    print(response);
    if (response.statusCode != 200) {
      throw Exception('Failed to create ride.');
    }
  }
}
