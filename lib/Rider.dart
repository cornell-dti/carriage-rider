import 'dart:core';

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

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
        id: json['id'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        pronouns: json['pronouns'],
        accessibilityNeeds: json['accessibilityNeeds'],
        hasWheelchair: json['hasWheelchair'],
        hasCrutches: json['hasCrutches'],
        needsAssistant: json['needsAssistant'],
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
        'hasWheelchair': hasWheelchair,
        'needsAssistant': needsAssistant,
        'description': description,
        'picture': picture,
        'joinDate': joinDate,
      };
}
