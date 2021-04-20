import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import '../utils/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:carriage_rider/models/Location.dart';

//Manage the state of locations with ChangeNotifier
class LocationsProvider with ChangeNotifier {
  List<Location> locations;

  LocationsProvider(BuildContext context, AppConfig config,
      AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) {
        fetchLocations(context, config, authProvider);
      }
    };
    callback();
    authProvider.addListener(callback);
  }

  final retryDelay = Duration(seconds: 30);

  bool hasLocations() {
    return locations != null;
  }

  //Fetches all the locations from the backend as a list by using the baseUrl of [config] and id from [authProvider].
  Future<void> fetchLocations(BuildContext context, AppConfig config,
      AuthProvider authProvider) async {
    AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.get('${config.baseUrl}/locations',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      String responseBody = response.body;
      locations = _locationsFromJson(responseBody);
      notifyListeners();
    } else {
      await Future.delayed(retryDelay);
      fetchLocations(context, config, authProvider);
    }
  }

  //Decodes the string [json] of locations into a list representation of the locations.
  List<Location> _locationsFromJson(String json) {
    var data = jsonDecode(json)['data'];
    List<Location> res =
    data.map<Location>((e) => Location.fromJson(e)).toList();
    return res;
  }

  //Converts the list [locations] given by the results of [query] to a list of strings containing their names.
  List<String> getSuggestions(String query) {
    List<String> matches = locations.where((e) =>
    e.tag != 'custom' && e.name.toLowerCase().contains(query.toLowerCase()))
        .map((e) => e.name)
        .toList();
    return matches;
  }

  Location locationByName(String location) {
    int index;
    if (locations != null) {
      index = locations.indexWhere((e) => e.name == location);
    }
    return index == null ? null : locations[index];
  }

  bool checkLocation(String location) {
    int index;
    if (locations != null) {
      index = locations.indexWhere((e) => e.name == location);
      return index == -1 ? false : locations.contains(locations[index]);
    }
    return false;
  }

  bool isCustom(String locationName) {
    List<Location> regularLocations = locations.where((e) => e.tag != 'custom')
        .toList();
    return !regularLocations.contains(locationByName(locationName));
  }

  bool isPreset(String locationName) {
    List<String> regularLocations = locations.map((e) => e.name).toList();
    return !regularLocations.contains(locationName);
  }

  //Converts a list of locations [locations] to a Map containing location ids (key) to locations (value).
  Map<String, Location> locationsById(List<Location> locations) {
    Map<String, Location> res = {};
    locations.forEach((element) {
      res[element.id] = element;
    });
    return res;
  }
}
