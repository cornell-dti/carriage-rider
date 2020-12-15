import 'dart:convert';
import 'package:carriage_rider/RiderProvider.dart';
import 'app_config.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/Ride.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//Manage the state of rides with ChangeNotifier.
class RidesProvider with ChangeNotifier {
  RidesProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) {
        fetchPastRides(config, authProvider);
      }
    };
    callback();
    authProvider.addListener(callback);
  }

  //Fetches a list of past rides from the backend by using the baseUrl of [config] and id from [authProvider].
  Future<List<Ride>> fetchPastRides(
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

//  Future<List<Ride>> fetchUpcomingRides(
//      AppConfig config, AuthProvider authProvider) async {
//    final responseAct = await http
//        .get('${config.baseUrl}/rides?type=active&rider=${authProvider.id}');
//    final responseUn = await http.get(
//        '${config.baseUrl}/rides?type=unscheduled&rider=${authProvider.id}');
//    if (responseAct.statusCode == 200 || responseUn.statusCode == 200) {
//      String responseActBody = responseAct.body;
//      String responseUnBody = responseUn.body;
//      List<Ride> ridesAct = _ridesFromJson(responseActBody);
//      List<Ride> ridesUn = _ridesFromJson(responseUnBody);
//      List<Ride> combRides = ridesAct + ridesUn;
//      return combRides;
//    } else {
//      throw Exception('Failed to load rides.');
//    }
//  }

  //Fetches a list of upcoming rides from the backend by using the baseUrl of [config] and id from [authProvider].
  Future<List<Ride>> fetchUpcomingRides(
      AppConfig config, AuthProvider authProvider) async {
    final responseNs = await http.get(
        '${config.baseUrl}/rides?status=not_started&rider=${authProvider.id}');
    if (responseNs.statusCode == 200) {
      String responseNSBody = responseNs.body;
      List<Ride> ridesNs = _ridesFromJson(responseNSBody);
      print(ridesNs);
      return ridesNs;
    } else {
      throw Exception('Failed to load rides.');
    }
  }

  //Decodes [json] of locations into a list representation of rides.
  List<Ride> _ridesFromJson(String json) {
    var data = jsonDecode(json)["data"];
    List<Ride> res = data.map<Ride>((e) => Ride.fromJson(e)).toList();
    res.sort((a, b) => a.startTime.compareTo(b.startTime));
    return res;
  }

  //Creates a ride in the backend by an HTTP post request with the fields:
  // [startLocation], [endLocation], [startTime], and [endTime].
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
