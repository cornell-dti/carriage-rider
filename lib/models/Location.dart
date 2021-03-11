import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';

//Model for a location.
class Location {
  //The id of a location
  final String id;

  //The name of a location
  final String name;

  //The address of a location
  final String address;

  Location({this.id, this.name, this.address});

  //Creates a location from JSON representation.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'], name: json['name'], address: json['address']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address
  };
}

//Fetches all the locations from the backend as a list by using the baseUrl of [config] and id from [authProvider].
Future<List<Location>> fetchLocations(BuildContext context) async {
  final response = await http.get(AppConfig.of(context).baseUrl + '/locations');
  if (response.statusCode == 200) {
    String responseBody = response.body;
    var data = jsonDecode(responseBody)['data'];
    List<Location> locations =
        data.map<Location>((e) => Location.fromJson(e)).toList();
    return locations;
  } else {
    throw Exception('Failed to fetch locations.');
  }
}

//Converts a list of locations [locations] to a Map containing location ids (key) to locations (value).
Map<String, Location> locationsById(List<Location> locations) {
  Map<String, Location> res = {};
  locations.forEach((element) {
    res[element.id] = element;
  });
  return res;
}
