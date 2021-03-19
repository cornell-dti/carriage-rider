import 'dart:core';
import 'package:flutter/material.dart';

class Driver {
  //The id of a driver
  final String id;

  //The first name of a driver
  final String firstName;

  //The last name of a driver
  final String lastName;

  //The phone number of a driver
  final String phoneNumber;

  //The link to a profile picture of a driver
  final String photoLink;

  String fullName() => firstName + ' ' + lastName;

  Driver(
      {@required this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.photoLink});

  //Creates a driver from JSON representation.
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber'],
        photoLink: json['photoLink'] == null ? null : json['photoLink']);
  }
}
