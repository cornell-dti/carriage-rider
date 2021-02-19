import 'dart:convert';
import 'package:carriage_rider/providers/RiderProvider.dart';
import '../utils/app_config.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';

//Manage the state of rides with ChangeNotifier.
class RidesProvider with ChangeNotifier {
  RidesProvider(
      BuildContext context, AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) {
        fetchPastRides(context, config, authProvider);
      }
    };
    callback();
    authProvider.addListener(callback);
  }

  //Fetches a list of past rides from the backend by using the baseUrl of [config] and id from [authProvider].
  Future<List<Ride>> fetchPastRides(
      BuildContext context, AppConfig config, AuthProvider authProvider) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        '${config.baseUrl}/rides?type=past&rider=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
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
      BuildContext context, AppConfig config, AuthProvider authProvider) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    final responseNs = await http.get(
        '${config.baseUrl}/rides?status=not_started&rider=${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (responseNs.statusCode == 200) {
      String responseNSBody = responseNs.body;
      List<Ride> ridesNs = _ridesFromJson(responseNSBody);
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
        'endTime': endTime,
      }),
    );
    print(response);
    if (response.statusCode != 200) {
      throw Exception('Failed to create ride.');
    }
  }
}
