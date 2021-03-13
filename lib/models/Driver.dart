import 'dart:core';
import 'package:flutter/material.dart';

class Driver {
  //The id of a driver
  final String id;
  //The first name of a driver
  final String firstName;
  //The last name of a driver
  final String lastName;
  //The phoneNumber of a driver
  final String phoneNumber;

  String fullName() => firstName + ' ' + lastName;

  Driver({@required this.id, this.firstName, this.lastName, this.phoneNumber});

  //Creates a driver from JSON representation.
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        id: json['id'], firstName: json['firstName'], lastName: json['lastName'], phoneNumber: json['phoneNumber']);
  }
}
