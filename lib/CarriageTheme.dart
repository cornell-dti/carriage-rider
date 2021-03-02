import 'package:flutter/material.dart';

class CarriageTheme {

  static final directionStyle = TextStyle(
    color: Colors.grey[500],
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  static final rideInfoStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 17,
  );

  static final monthStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 22
  );

  static final dayStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 22
  );

  static final timeStyle = TextStyle(
      color: Colors.grey[500],
      fontWeight: FontWeight.w400,
      fontSize: 22
  );

  static final BoxDecoration cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            blurRadius: 2,
            spreadRadius: 0,
            color: Colors.black.withOpacity(0.25)
        )
      ]
  );

  static final String generatedRideID = 'INSTANCE';
}