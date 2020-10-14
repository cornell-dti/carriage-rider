import 'dart:convert';
import 'app_config.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/RideProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RidesProvider with ChangeNotifier {
  RidesProvider(AppConfig config, AuthProvider authProvider) {
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
      print(rides);
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
}
