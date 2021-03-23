import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/app_config.dart';
import 'package:http/http.dart' as http;

//Model for a rider.
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
  final List accessibility;

  //The ids of favorite locations.
  final List<String> favoriteLocations;

  //The description of a rider's disability, needs, etc.
  final String description;

  //The photo url of a rider's profile picture.
  final String photoLink;

  //The ISO 8601 formatted UTC date of a rider's join date
  final String joinDate;

  //The local address of a rider.
  final String address;

  //Creates a string representing a rider's full name from it's first name and last name
  String fullName() => firstName + lastName;

  //Converts a rider's list of accessibility needs into a string representation
  String accessibilityStr() {
    String all = accessibility.join(', ');
    return all == '' ? 'None' : all;
  }

  Rider(
      this.id,
      this.email,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.pronouns,
      this.accessibility,
      this.favoriteLocations,
      this.description,
      this.photoLink,
      this.joinDate,
      this.address);

  // Creates a Rider from JSON representation. The query at the end of photoLink is to
  // force the network images that display it to re-fetch the photo, because it won't
  // if the URL is the same, and the URL does not change after an upload to backend.
  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
        json['id'],
        json['email'],
        json['phoneNumber'],
        json['firstName'],
        json['lastName'],
        json['pronouns'],
        List.from(json['accessibility']),
        List.from(json['favoriteLocations']),
        json['description'],
        json['photoLink'] == null ? null : 'http://${json['photoLink']}?dummy=${DateTime.now().millisecondsSinceEpoch}',
        json['joinDate'],
        json['address']);
  }

  Widget profilePicture(double diameter) {
    return Container(
      height: diameter,
      width: diameter,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: photoLink == null ? Image.asset(
              'assets/images/person.png',
              width: diameter,
              height: diameter
          ) : Image.network(
            this.photoLink,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
      ),
    );
  }
}

//Manage the state of a rider with ChangeNotifier
class RiderProvider with ChangeNotifier {
  //Instance of a rider.
  Rider info;

  //Checks whether a rider exists. Returns true if info is not null and false otherwise.
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

  //Checks whether a rider's information was updated successfully
  //and throws an exception if rider is not updated.
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

  //Fetches the rider with the authProvider's id from the backend
  //by using the baseUrl of [config] and id from [authProvider].
  Future<void> fetchRider(AppConfig config, AuthProvider authProvider) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    http.Response response = await http.get(
        '${config.baseUrl}/riders/${authProvider.id}',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setInfo(Rider.fromJson(json));
    } else {
      await Future.delayed(retryDelay);
      fetchRider(config, authProvider);
    }
  }

  //Sends a HTTP PUT request to update the rider fields specified in the map [changes].
  Future<void> sendUpdate(AppConfig config, AuthProvider authProvider,
      Map<String, dynamic> changes) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.put(
      '${config.baseUrl}/riders/${authProvider.id}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(changes),
    );
    check(authProvider, response);
  }

  //Updates the logged in rider's first name [firstName], last name [lastName], and phone number [phoneNumber].
  void updateRider(AppConfig config, AuthProvider authProvider,
      String firstName, String lastName, String phoneNumber) async {
    sendUpdate(config, authProvider, <String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    });
  }

  //Updates the the logged in rider's first [firstName] and last name [lastName].
  void setNames(AppConfig config, AuthProvider authProvider, String firstName,
      String lastName) async {
    sendUpdate(config, authProvider, <String, String>{
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  //Updates the logged in rider's email [email].
  void setEmail(
      AppConfig config, AuthProvider authProvider, String email) async {
    sendUpdate(config, authProvider, <String, String>{
      'email': email,
    });
  }

  //Updates the logged in rider's personal pronouns [pronouns].
  void setPronouns(
      AppConfig config, AuthProvider authProvider, String pronouns) async {
    sendUpdate(config, authProvider, <String, String>{
      'pronouns': pronouns,
    });
  }

  //Updates the logged in rider's phone number [phoneNumber].
  void setPhone(
      AppConfig config, AuthProvider authProvider, String phoneNumber) async {
    sendUpdate(config, authProvider, <String, String>{
      'phoneNumber': phoneNumber,
    });
  }

  //Updates the logged in rider's local address [address].
  void setAddress(
      AppConfig config, AuthProvider authProvider, String address) async {
    sendUpdate(config, authProvider, <String, String>{
      'address': address,
    });
  }

  //Updates the logged in rider's favorite locations [favoriteLocations].
  void setFavoriteLocations(AppConfig config, AuthProvider authProvider,
      List<String> favoriteLocations) async {
    sendUpdate(config, authProvider, <String, dynamic>{
      'favoriteLocations': favoriteLocations,
    });
  }

  /// Updates the logged in rider's profile picture.
  Future<void> updateRiderPhoto(AppConfig config, AuthProvider authProvider,
      String base64Photo) async {
    String token = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      "${config.baseUrl}/upload",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, String>{
        'id': authProvider.id,
        'tableName': 'Riders',
        'fileBuffer': base64Photo,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setInfo(Rider.fromJson(json));
    } else {
      print(response.body);
      throw Exception('Failed to update driver.');
    }
  }
}
