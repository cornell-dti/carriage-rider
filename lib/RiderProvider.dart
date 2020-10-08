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
  final Map accessibilityNeeds;
  final bool hasWheelchair;
  final bool hasCrutches;
  final bool needsAssistant;
  final String description;
  final String picture;
  final String joinDate;

  String fullName() => firstName + " " + lastName;

  Rider({
    this.id,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.pronouns,
    this.accessibilityNeeds,
    this.hasWheelchair,
    this.hasCrutches,
    this.needsAssistant,
    this.description,
    this.picture,
    this.joinDate,
  });

  factory Rider.fromJson(Map<String, dynamic> json, String photoUrl) {
    return Rider(
        id: json['id'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        pronouns: json['pronouns'],
        accessibilityNeeds: json['accessibilityNeeds'],
        description: json['description'],
        picture: json['picture'],
        joinDate: json['joinDate']);
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
      Map<String,dynamic> json = jsonDecode(response.body);
      _setInfo(Rider.fromJson(
          json, authProvider.googleSignIn.currentUser.photoUrl));
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
        _setInfo(Rider.fromJson(
            json, authProvider.googleSignIn.currentUser.photoUrl));
      } else {
        await Future.delayed(retryDelay);
        fetchRider(config, authProvider);
      }
    });
  }

  Future<void> updateRider(AppConfig config, AuthProvider authProvider,
      String firstName, String lastName, String phoneNumber) async {
    final response = await http.put(
      "${config.baseUrl}/riders/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      }),
    );
    check(authProvider, response);
  }

  Future<void> setNames(AppConfig config, AuthProvider authProvider,
      String firstName, String lastName) async {
    final response = await http.put(
      "${config.baseUrl}/riders/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
      }),
    );
    check(authProvider, response);
  }

  Future<void> setEmail(AppConfig config, AuthProvider authProvider,
      String email) async {
    final response = await http.put(
      "${config.baseUrl}/riders/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    check(authProvider, response);
  }

  Future<void> setPronouns(AppConfig config, AuthProvider authProvider,
      String pronouns) async {
    final response = await http.put(
      "${config.baseUrl}/riders/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'pronouns': pronouns,
      }),
    );
    check(authProvider, response);
  }

  Future<void> setPhone(AppConfig config, AuthProvider authProvider,
      String phoneNumber) async {
    final response = await http.put(
      "${config.baseUrl}/riders/${authProvider.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
      }),
    );
    check(authProvider, response);
  }
}
