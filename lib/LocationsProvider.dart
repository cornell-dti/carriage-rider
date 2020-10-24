import 'dart:core';
import 'package:flutter/material.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Location {
  final String id;
  final String name;
  final String address;

  Location({
    this.id,
    this.name,
    this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'], name: json['name'], address: json['address']);
  }
}

class LocationsProvider with ChangeNotifier {
  LocationsProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) {
        fetchLocations(config, authProvider);
      }
    };
    callback();
    authProvider.addListener(callback);
  }

  Future<List<Location>> fetchLocations(
      AppConfig config, AuthProvider authProvider) async {
    final response = await http.get('${config.baseUrl}/locations');
    if (response.statusCode == 200) {
      String responseBody = response.body;
      List<Location> locations = _locationsFromJson(responseBody);
      return locations;
    } else {
      throw Exception('Failed to load rides.');
    }
  }

  List<Location> _locationsFromJson(String json) {
    var data = jsonDecode(json)["data"];
    List<Location> res =
        data.map<Location>((e) => Location.fromJson(e)).toList();
    return res;
  }

  static List<String> getSuggestions(String query, List<Location> locations) {
    List<String> matches = locations.map((e) => e.name).toList();
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
