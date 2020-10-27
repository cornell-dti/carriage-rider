import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_config.dart';

class Location {
  final String id;
  final String name;
  final String address;

  Location({@required this.id, this.name, this.address});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'], name: json['name'], address: json['address']);
  }
}

Future<List<Location>> fetchLocations(BuildContext context) async {
  final response = await http.get(AppConfig.of(context).baseUrl + '/locations');
  if (response.statusCode == 200) {
    String responseBody = response.body;
    var data = jsonDecode(responseBody)["data"];
    List<Location> locations =
        data.map<Location>((e) => Location.fromJson(e)).toList();
    return locations;
  } else {
    throw Exception('Failed to fetch locations.');
  }
}

Map<String, Location> locationsById(List<Location> locations) {
  Map<String, Location> res = {};
  locations.forEach((element) {
    res[element.id] = element;
  });
  return res;
}
