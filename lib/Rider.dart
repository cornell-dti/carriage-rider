import 'dart:core';

class Rider {
  final String id;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pronouns;
  final String picture;
  final String joinDate;

  Rider(
      {this.id,
      this.email,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.pronouns,
      this.picture,
      this.joinDate});

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      pronouns: json['pronouns'],
      picture: json['picture'],
      joinDate: json['joinDate']
    );
  }
}
