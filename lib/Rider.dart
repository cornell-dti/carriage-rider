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
  List<String> pastRides;
  List<String> requestedRides;
  List<String> favoriteLocations;

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
    this.pastRides,
    this.requestedRides,
    this.favoriteLocations,
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
        joinDate: json['joinDate'],
        pastRides: (json['pastRides'] as List<dynamic>).cast<String>().toList(),
        requestedRides:
            (json['requestedRides'] as List<dynamic>).cast<String>().toList(),
        favoriteLocations: (json['favoriteLocations'] as List<dynamic>)
            .cast<String>()
            .toList());
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
        'hasWheelchair': hasWheelchair,
        'needsAssistant': needsAssistant,
        'description': description,
        'picture': picture,
        'joinDate': joinDate,
        'pastRides': pastRides,
        'requestedRides': requestedRides,
        'favoriteLocations': favoriteLocations
      };
}
