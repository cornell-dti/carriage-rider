import 'dart:convert';
import 'package:carriage_rider/utils/RecurringRidesGenerator.dart';
import 'dart:io';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Manage the state of rides with ChangeNotifier.
class RidesProvider with ChangeNotifier {
  Ride currentRide;
  List<Ride> pastRides;
  List<Ride> existingUpcomingRides;
  List<Ride> _parentRecurringRides;
  List<Ride> upcomingRides;

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

  bool hasData() {
    return pastRides != null &&
        existingUpcomingRides != null &&
        _parentRecurringRides != null &&
        upcomingRides != null;
  }

  _generateUpcomingRides() {
    List<Ride> recurringRides =
    RecurringRidesGenerator(_parentRecurringRides, existingUpcomingRides)
        .generateRecurringRides();
    upcomingRides = existingUpcomingRides;
    upcomingRides.addAll(recurringRides);
    upcomingRides.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Fetches the most current ride from the backend by using the baseUrl of [config] and the rider id from [authProvider].
  /// The current ride that is retrieved from the backend is the soonest ride
  /// within the next 30 minutes for the rider with the associated id (if it exists).
  Future<void> _fetchCurrentRide(AppConfig config,
      AuthProvider authProvider) async {
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
  /// Past rides are sorted from closest in time to farthest back in time,
  /// so past rides has the most recent ride first.
  Future<void> _fetchPastRides(AppConfig config,
      AuthProvider authProvider) async {
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
  /// Upcoming rides are sorted from closest in time to farthest forward in time,
  /// so upcoming rides has the soonest ride first.
  Future<void> _fetchExistingUpcomingRides(AppConfig config,
      AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        '${config.baseUrl}/rides?status=not_started&rider=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List<Ride> rides = _ridesFromJson(response.body).toList();
      rides.sort((a, b) => a.startTime.compareTo(b.startTime));
      existingUpcomingRides = rides;
    }
  }

  /// Fetches a list of recurring rides from the backend by using the baseUrl of [config] and rider id from [authProvider].
  Future<void> _fetchParentRecurringRides(AppConfig config,
      AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        '${config.baseUrl}/rides/repeating?rider=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List<Ride> rides = _ridesFromJson(response.body);
      rides.sort((a, b) => a.startTime.compareTo(b.startTime));
      _parentRecurringRides = rides;
    }
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
      var data = jsonDecode(json);
      Ride res = Ride.fromJson(data);
      return res;
    }
    return null;
  }

  /// Fetches past rides, upcoming rides, and current ride from the backend.
  /// Uses AppConfig [config] and AuthProvider [authProvider] to pass in as arguments for each
  /// ride fetching helper function. Notifies client if the object containing rides may have changed.
  Future<void> fetchAllRides(AppConfig config,
      AuthProvider authProvider) async {
    await _fetchCurrentRide(config, authProvider);
    await _fetchPastRides(config, authProvider);
    await _fetchExistingUpcomingRides(config, authProvider);
    await _fetchParentRecurringRides(config, authProvider);
    _generateUpcomingRides();
    if (currentRide != null) {
      existingUpcomingRides.removeWhere((ride) => ride.id == currentRide.id);
    }
    notifyListeners();
  }

  Future<void> cancelRide(BuildContext context, Ride ride) async {
    AppConfig config = AppConfig.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    http.Response response = await http.delete(
        config.baseUrl + '/rides/${ride.id}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        });
    if (response.statusCode != 200) {
      throw Exception('Failed to delete instance of recurring ride: ${response.body}');
    }
    fetchAllRides(config, authProvider);
  }

  Future<void> cancelRepeatingRideOccurrence(BuildContext context, Ride ride) async {
    AppConfig config = AppConfig.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    Map<String, dynamic> request = <String, dynamic>{
      'id': ride.id,
      'deleteOnly': true,
      'origDate': DateFormat('yyyy-MM-dd').format(ride.origDate),
    };
    final response = await http.put('${config.baseUrl}/rides/${ride.parentRide.id}/edits',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(request));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete instance of recurring ride: ${response.body}');
    }
    fetchAllRides(config, authProvider);
  }
}
