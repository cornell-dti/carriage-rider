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
    Map<String, dynamic> itemJson = json['Item'];
    return Rider(
        id: itemJson['id'],
        email: itemJson['email'],
        phoneNumber: itemJson['phoneNumber'],
        firstName: itemJson['firstName'],
        lastName: itemJson['lastName'],
        pronouns: itemJson['pronouns'],
        accessibilityNeeds: itemJson['accessibilityNeeds'],
        hasWheelchair: itemJson['hasWheelchair'],
        hasCrutches: itemJson['hasCrutches'],
        needsAssistant: itemJson['needsAssistant'],
        description: itemJson['description'],
        picture: itemJson['picture'],
        joinDate: itemJson['joinDate'],
        pastRides: (itemJson['pastRides'] as List<dynamic>).cast<String>().toList(),
        requestedRides:
            (itemJson['requestedRides'] as List<dynamic>).cast<String>().toList(),
        favoriteLocations: (itemJson['favoriteLocations'] as List<dynamic>)
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
