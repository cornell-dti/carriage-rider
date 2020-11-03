import 'dart:core';
import 'dart:convert';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:flutter/widgets.dart';
import 'app_config.dart';
import 'package:http/http.dart' as http;

class Rider {
  final String id;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pronouns;
  final List accessibilityNeeds;
  final String description;
  final String picture;
  final String joinDate;
  final String address;

  String fullName() => firstName + " " + lastName;

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
      this.description,
      this.picture,
      this.joinDate,
      this.address);

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
        json['description'],
        json['picture'],
        json['joinDate'],
        json['address']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phoneNumber': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
        'pronouns': picture,
        'accessibilityNeeds': accessibilityNeeds,
        'description': description,
        'picture': picture,
        'joinDate': joinDate,
      };
}

class RiderProvider with ChangeNotifier {
  Rider info;

  bool hasInfo() => info != null;

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

  void _setInfo(Rider info) {
    this.info = info;
    notifyListeners();
  }

  void check(AuthProvider authProvider, response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _setInfo(
        Rider.fromJson(json),
      );
    } else {
      throw Exception('Failed to update driver.');
    }
  }

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

  Future<void> sendUpdate(AppConfig config, AuthProvider authProvider,
      Map<String, String> changes) async {
    final response = await http.put(
      "${config.baseUrl}/riders/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(changes),
    );
    check(authProvider, response);
  }

  void updateRider(AppConfig config, AuthProvider authProvider,
      String firstName, String lastName, String phoneNumber) async {
    sendUpdate(config, authProvider, <String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    });
  }

  void setNames(AppConfig config, AuthProvider authProvider, String firstName,
      String lastName) async {
    sendUpdate(config, authProvider, <String, String>{
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  void setEmail(
      AppConfig config, AuthProvider authProvider, String email) async {
    sendUpdate(config, authProvider, <String, String>{
      'email': email,
    });
  }

  void setPronouns(
      AppConfig config, AuthProvider authProvider, String pronouns) async {
    sendUpdate(config, authProvider, <String, String>{
      'pronouns': pronouns,
    });
  }

  void setPhone(
      AppConfig config, AuthProvider authProvider, String phoneNumber) async {
    sendUpdate(config, authProvider, <String, String>{
      'phoneNumber': phoneNumber,
    });
  }

  void setAddress(
      AppConfig config, AuthProvider authProvider, String address) async {
    sendUpdate(config, authProvider, <String, String>{
      'address': address,
    });
  }
}
