import 'dart:core';
import 'dart:convert';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:flutter/widgets.dart';
import 'app_config.dart';
import 'package:http/http.dart' as http;

//The type for a rider.
class Rider {
  //The id of a rider.
  final String id;

  //The email of a rider.
  final String email;

  //The phone number of a rider in the format of ##########.
  final String phoneNumber;

  //The first name of a rider
  final String firstName;

  //The last name of a rider.
  final String lastName;

  //The personal pronouns of a rider.
  final String pronouns;

  //The accessibility needs of a rider as a list.
  final List accessibilityNeeds;

  //The ids of favorite locations.
  final List<String> favoriteLocations;

  //The description of a rider's disability, needs, etc.
  final String description;

  //The photo url of a rider's profile picture.
  final String picture;

  //The ISO 8601 formatted UTC date of a rider's join date
  final String joinDate;

  //The local address of a rider.
  final String address;

  //Creates a string representing a rider's full name from it's first name and last name
  String fullName() => firstName + " " + lastName;

  //Converts a rider's list of accessibility needs into a string representation
  String accessibilityStr() {
    String all = accessibilityNeeds.join(', ');
    return all == '' ? 'None' : all;
  }

  Rider(
      this.id,
      this.email,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.pronouns,
      this.accessibilityNeeds,
      this.favoriteLocations,
      this.description,
      this.picture,
      this.joinDate,
      this.address);

  //Creates a Rider from JSON representation.
  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
        json['id'],
        json['email'],
        json['phoneNumber'],
        json['firstName'],
        json['lastName'],
        json['pronouns'],
        List.from(
          json['accessibility'],
        ),
        List.from(json['favoriteLocations']),
        json['description'],
        json['picture'],
        json['joinDate'],
        json['address']);
  }

  //Converts a Rider instance into a map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phoneNumber': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
        'pronouns': picture,
        'accessibility': accessibilityNeeds,
        'description': description,
        'picture': picture,
        'joinDate': joinDate,
      };
}

//Manage the state of a rider with ChangeNotifier
class RiderProvider with ChangeNotifier {

  //Instance of a rider.
  Rider info;

  //Checks whether a rider and it's information exists.
  bool hasInfo() => info != null;

  //The delay involved with fetching a rider if the fetch previously fails.
  final retryDelay = Duration(seconds: 20);

  RiderProvider(AppConfig config, AuthProvider authProvider) {
    void Function() callback;
    callback = () {
      if (authProvider.isAuthenticated) {
        fetchRider(config, authProvider);
      }
    };
    callback();
    authProvider.addListener(callback);
  }

  //Assigns info to the rider instance.
  void _setInfo(Rider info) {
    this.info = info;
    notifyListeners();
  }

  //Checks whether a rider's information was updated successfully.
  void check(AuthProvider authProvider, response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setInfo(
        Rider.fromJson(json),
      );
    } else {
      throw Exception('Failed to update rider.');
    }
  }

  //Fetches the rider with the authProvider's id from the backend.
  Future<void> fetchRider(AppConfig config, AuthProvider authProvider) async {
    await http
        .get("${config.baseUrl}/riders/${authProvider.id}")
        .then((response) async {
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        _setInfo(Rider.fromJson(json));
      } else {
        await Future.delayed(retryDelay);
        fetchRider(config, authProvider);
      }
    });
  }


  //Sends a HTTP PUT request to update the rider fields specified in the map [changes].
  Future<void> sendUpdate(AppConfig config, AuthProvider authProvider,
      Map<String, dynamic> changes) async {
    final response = await http.put(
      "${config.baseUrl}/riders/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(changes),
    );
    check(authProvider, response);
  }

  //Updates the logged in rider's first name, last name, and phone number.
  void updateRider(AppConfig config, AuthProvider authProvider,
      String firstName, String lastName, String phoneNumber) async {
    sendUpdate(config, authProvider, <String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    });
  }

  //Updates the the logged in rider's first and last name.
  void setNames(AppConfig config, AuthProvider authProvider, String firstName,
      String lastName) async {
    sendUpdate(config, authProvider, <String, String>{
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  //Updates the logged in rider's email.
  void setEmail(
      AppConfig config, AuthProvider authProvider, String email) async {
    sendUpdate(config, authProvider, <String, String>{
      'email': email,
    });
  }

  //Updates the logged in rider's personal pronouns.
  void setPronouns(
      AppConfig config, AuthProvider authProvider, String pronouns) async {
    sendUpdate(config, authProvider, <String, String>{
      'pronouns': pronouns,
    });
  }

  //Updates the logged in rider's phone number.
  void setPhone(
      AppConfig config, AuthProvider authProvider, String phoneNumber) async {
    sendUpdate(config, authProvider, <String, String>{
      'phoneNumber': phoneNumber,
    });
  }

  //Updates the logged in rider's local address.
  void setAddress(
      AppConfig config, AuthProvider authProvider, String address) async {
    sendUpdate(config, authProvider, <String, String>{
      'address': address,
    });
  }

  //Updates the logged in rider's favorite locations.
  void setFavoriteLocations(AppConfig config, AuthProvider authProvider,
      List<String> favoriteLocations) async {
    sendUpdate(config, authProvider, <String, dynamic>{
      'favoriteLocations': favoriteLocations,
    });
  }
}
