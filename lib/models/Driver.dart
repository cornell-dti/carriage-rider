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

  Widget profilePicture(double diameter) {
    return Container(
      height: diameter,
      width: diameter,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: photoLink == null
              ? Image.asset('assets/images/person.png',
                  width: diameter, height: diameter)
              : Image.network(
                  photoLink,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )),
    );
  }
}
