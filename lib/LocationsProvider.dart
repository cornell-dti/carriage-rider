import 'dart:core';
import 'package:flutter/material.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//The type for a location.
class Location {
  //The id of a location
  final String id;
  //The name of a location
  final String name;
  //The address of a location
  final String address;

  Location({
    this.id,
    this.name,
    this.address,
  });

  //Creates a location from JSON representation.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'], name: json['name'], address: json['address']);
  }
}

//Manage the state of locations with ChangeNotifier
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

  //Fetches all the locations from the backend as a list by using the baseUrl of [config] and id from [authProvider].
  Future<List<Location>> fetchLocations(
      AppConfig config, AuthProvider authProvider) async {
    final response = await http.get('${config.baseUrl}/locations');
    if (response.statusCode == 200) {
      String responseBody = response.body;
      List<Location> locations = _locationsFromJson(responseBody);
      return locations;
    } else {
      throw Exception('Failed to load locations.');
    }
  }

  //Decodes the string [json] of locations into a list representation of the locations.
  List<Location> _locationsFromJson(String json) {
    var data = jsonDecode(json)["data"];
    List<Location> res =
        data.map<Location>((e) => Location.fromJson(e)).toList();
    return res;
  }

  //Converts the list [locations] given by the results of [query] to a list of strings containing their names.
  static List<String> getSuggestions(String query, List<Location> locations) {
    List<String> matches = locations.map((e) => e.name).toList();
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
