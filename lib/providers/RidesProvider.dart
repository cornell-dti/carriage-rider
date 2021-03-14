import 'dart:convert';
import 'package:carriage_rider/providers/RiderProvider.dart';
import '../utils/app_config.dart';
import 'dart:io';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';

/// Manage the state of rides with ChangeNotifier.
class RidesProvider with ChangeNotifier {
  Ride currentRide = Ride();
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

  /// Fetches past rides, upcoming rides, and current ride from the backend.
  /// Uses AppConfig [config] and AuthProvider [authProvider] to pass in as arguments for each
  /// ride fetching helper function. Notifies client if the object containing rides may have changed.
  Future<void> fetchAllRides(
      AppConfig config, AuthProvider authProvider) async {
    await _fetchPastRides(config, authProvider);
    await _fetchUpcomingRides(config, authProvider);
    await _fetchCurrentRide(config, authProvider);
    notifyListeners();
  }

  /// Returns a list of rides that are decoded from the response body of a HTTP request [json].
  /// Each ride is displayed in the order that they are presented in [json].
  List<Ride> _ridesFromJson(String json) {
    var data = jsonDecode(json)['data'];
    List<Ride> res = data.map<Ride>((e) => Ride.fromJson(e)).toList();
    return res;
  }

  /// Returns a ride that is decoded from the response body of a HTTP request [json].
  /// If there is no ride in [json], we will return null to indicate that there is no
  /// current ride.
  Ride _rideFromJson(String json) {
    if (json != '{}') {
      var data = jsonDecode(json)['data'];
      Ride res = Ride.fromJson(data);
      return res;
    }
    return null;
  }

  /// Fetches the most current ride from the backend by using the baseUrl of [config] and the rider id from [authProvider].
  /// The current ride that is retrieved from the backend is the soonest ride
  /// within the next 30 minutes for the rider with the associated id (if it exists).
  Future<void> _fetchCurrentRide(
      AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        '${config.baseUrl}/riders/${authProvider.id}/currentride',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      Ride ride = _rideFromJson(response.body);
      currentRide = ride;
    } else {
      throw Exception('Failed to load current ride.');
    }
  }

  /// Fetches a list of have already occurred from the backend by using the baseUrl of [config] and rider id from [authProvider].
  /// Past rides are sorted and displayed in order of their initial start time.
  Future<void> _fetchPastRides(
      AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        '${config.baseUrl}/rides?type=past&rider=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List<Ride> rides = _ridesFromJson(response.body);
      rides.sort((a, b) => b.startTime.compareTo(a.startTime));
      pastRides = rides;
    } else {
      throw Exception('Failed to load rides.');
    }
  }

  /// Fetches a list of upcoming rides from the backend by using the baseUrl of [config] and rider id from [authProvider].
  /// Upcoming rides are sorted and displayed in order of their initial start time.
  Future<void> _fetchUpcomingRides(
      AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        '${config.baseUrl}/rides?status=not_started&rider=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List<Ride> rides = _ridesFromJson(response.body);
      rides.sort((a, b) => a.startTime.compareTo(b.startTime));
      upcomingRides = rides;
    }
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
      String startTime,
      String endTime) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      '${config.baseUrl}/rides',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
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
