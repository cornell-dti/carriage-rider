import 'dart:core';
import 'dart:io';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import '../utils/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carriage_rider/models/Location.dart';

//Manage the state of locations with ChangeNotifier
class LocationsProvider with ChangeNotifier {
  List<Location> locations;
  List<Location> favLocations;
  Map<String, Location> locationsByName = Map();

  LocationsProvider(AppConfig config, AuthProvider authProvider,
      RiderProvider riderProvider) {
    void Function() callback;
    callback = () async {
      if (authProvider.isAuthenticated && riderProvider.hasInfo()) {
        await fetchLocations(config, authProvider);
        await fetchFavoriteLocations(config, authProvider);
        locations.forEach((loc) => locationsByName[loc.name] = loc);
      }
    };
    callback();
    riderProvider.addListener(callback);
  }

  final retryDelay = Duration(seconds: 30);

  bool hasLocations() {
    return locations != null;
  }

  bool hasFavLocations() {
    return favLocations != null;
  }

  //Fetches all the locations from the backend as a list by using the baseUrl of [config] and id from [authProvider].
  Future<void> fetchLocations(config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(Uri.parse('${config.baseUrl}/locations'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      String responseBody = response.body;
      locations = _locationsFromJson(responseBody);
      notifyListeners();
    } else {
      await Future.delayed(retryDelay);
      fetchLocations(config, authProvider);
    }
  }

  //Fetches the rider's favorite locations from the backend.
  Future<void> fetchFavoriteLocations(
      AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get(
        Uri.parse('${config.baseUrl}/riders/${authProvider.id}/favorites'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      String responseBody = response.body;
      favLocations = _locationsFromJson(responseBody);
      notifyListeners();
    } else {
      await Future.delayed(retryDelay);
      fetchFavoriteLocations(config, authProvider);
    }
  }

  //Decodes the string [json] of locations into a list representation of the locations.
  List<Location> _locationsFromJson(String json) {
    var data = jsonDecode(json)['data'];
    List<Location> res =
        data.map<Location>((e) => Location.fromJson(e)).toList();
    return res;
  }

  //Returns a map from name to address of locations that match with [query].
  List<String> getSuggestions(String query) {
    if (query == '') {
      return locations.map((loc) => loc.name).toList()
        ..sort((a, b) => a.compareTo(b));
    }
    String lowerCaseQuery = query.toLowerCase();
    bool exact(Location loc) => loc.name.toLowerCase() == lowerCaseQuery;
    int containsIndex(Location loc) =>
        loc.name.toLowerCase().indexOf(lowerCaseQuery);

    List<Location> exactQuery = locations.where((loc) => exact(loc)).toList();
    List<Location> startsWithQuery = locations
        .where((loc) => !exact(loc) && containsIndex(loc) == 0)
        .toList();
    List<Location> containsQuery = locations
        .where((loc) =>
            !exact(loc) &&
            containsIndex(loc) != 0 &&
            loc.name.toLowerCase().contains(lowerCaseQuery))
        .toList();
    List<Location> matches = exactQuery
      ..addAll(startsWithQuery)
      ..addAll(containsQuery);
    return matches.map((loc) => loc.name).toList();
  }

  Location locationByName(String name) {
    return locationsByName[name];
  }

  String addressByName(String name) {
    return locationsByName[name].address;
  }

  String locationIDByName(String name) {
    return locationsByName[name].id;
  }

  bool isPreset(String name) {
    return locationsByName[name] != null;
  }

  //Converts a list of locations [locations] to a Map containing location ids (key) to locations (value).
  Map<String, Location> locationsByID() {
    Map<String, Location> res = {};
    locations.forEach((element) {
      res[element.id] = element;
    });
    return res;
  }
}
