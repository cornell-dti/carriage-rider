import 'dart:convert';
import 'dart:io';
import 'package:carriage_rider/RiderProvider.dart';
import 'app_config.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/Ride.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';

//Manage the state of rides with ChangeNotifier.
class RidesProvider with ChangeNotifier {
  List<Ride> pastRides = [];
  List<Ride> upcomingRides = [];

  RidesProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) {
        fetchAllRides(config, authProvider);
      }
    };
    callback();
    authProvider.addListener(callback);
  }

  Future<void> fetchAllRides(AppConfig config, AuthProvider authProvider) async {
    await _fetchPastRides(config, authProvider);
    await _fetchUpcomingRides(config, authProvider);
    notifyListeners();
  }

  //Decodes [json] of locations into a list representation of rides.
  List<Ride> _ridesFromJson(String json) {
    var data = jsonDecode(json)["data"];
    List<Ride> res = data.map<Ride>((e) => Ride.fromJson(e)).toList();
    return res;
  }

  //Fetches a list of past rides from the backend by using the baseUrl of [config] and id from [authProvider].
  Future<void> _fetchPastRides(
      AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        '${config.baseUrl}/rides?type=past&rider=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      List<Ride> rides = _ridesFromJson(response.body);
      rides.sort((a, b) => b.startTime.compareTo(a.startTime));
      pastRides = rides;
    } else {
      throw Exception('Failed to load rides.');
    }
  }


  //Fetches a list of upcoming rides from the backend by using the baseUrl of [config] and id from [authProvider].
  Future<void> _fetchUpcomingRides(
      AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        '${config.baseUrl}/rides?status=not_started&rider=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      List<Ride> rides = _ridesFromJson(response.body);
      rides.sort((a, b) => a.startTime.compareTo(b.startTime));
      upcomingRides = rides;
    }
  }

  //Creates a ride in the backend by an HTTP post request with the fields:
  //[startLocation], [endLocation], [startTime], and [endTime].
  Future<void> createRide(
      AppConfig config,
      BuildContext context,
      RiderProvider riderProvider,
      String startLocation,
      String endLocation,
      String startTime,
      String endTime) async {
    AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      "${config.baseUrl}/rides",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        'rider': riderProvider.info,
        'startLocation': startLocation,
        'endLocation': endLocation,
        'startTime': startTime,
        'requestedEndTime': endTime,
      }),
    );
    print(response);
    if (response.statusCode != 200) {
      throw Exception('Failed to create ride.');
    }
  }
}
