import 'package:flutter/material.dart';

class CarriageTheme {
  static final TextStyle largeTitle = TextStyle(
      color: Colors.black,
      fontFamily: 'SFDisplay',
      fontWeight: FontWeight.bold,
      fontSize: 34,
      letterSpacing: 0.37);

  static final TextStyle title1 = TextStyle(
      color: Colors.black,
      fontFamily: 'SFDisplay',
      fontWeight: FontWeight.bold,
      fontSize: 28,
      letterSpacing: 0.36);

  static final TextStyle title2 = TextStyle(
      color: Colors.black,
      fontFamily: 'SFDisplay',
      fontWeight: FontWeight.w800,
      fontSize: 23,
      letterSpacing: 0.35);

  static final TextStyle title3 = TextStyle(
      color: Colors.black,
      fontFamily: 'SFDisplay',
      fontWeight: FontWeight.w800,
      fontSize: 20,
      height: 24 / 20,
      letterSpacing: 0.38);

  static final TextStyle body = TextStyle(
      color: Colors.black,
      fontFamily: 'SFText',
      fontWeight: FontWeight.w400,
      fontSize: 17,
      letterSpacing: -0.41);

  static final TextStyle button = TextStyle(
      color: Colors.white,
      fontFamily: 'SFText',
      fontWeight: FontWeight.bold,
      fontSize: 17);

  static final TextStyle subheadline = TextStyle(
      color: Colors.black,
      fontFamily: 'SFText',
      fontWeight: FontWeight.w400,
      fontSize: 15,
      letterSpacing: -0.24);

  static final TextStyle caption1 = TextStyle(
      color: Colors.black,
      fontFamily: 'SFText',
      fontWeight: FontWeight.w600,
      fontSize: 11,
      letterSpacing: 0.07);

  static final TextStyle caption2 = TextStyle(
      color: Colors.black,
      fontFamily: 'SFText',
      fontWeight: FontWeight.w400,
      fontSize: 11,
      letterSpacing: 0.07);

  static final subHeading = TextStyle(
      color: Colors.grey[700], fontWeight: FontWeight.w700, fontSize: 20);

  static final seeMoreStyle = TextStyle(fontSize: 14, color: Color(0xFF181818));

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

  static final monthStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 22);

  static final dayStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 22);

  static final timeStyle = TextStyle(
      color: Colors.grey[500], fontWeight: FontWeight.w400, fontSize: 22);

  static final cancelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w100,
    fontSize: 15,
  );

  static final descriptionStyle =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w100, fontSize: 13);

  static final labelStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 11);

  static final infoStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);

  static Color gray1 = Color.fromRGBO(74, 74, 74, 1);
  static Color gray2 = Color.fromRGBO(132, 132, 132, 1);
  static Color gray3 = Color.fromRGBO(167, 167, 167, 1);

  static final BoxDecoration cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            blurRadius: 2,
            spreadRadius: 0,
            color: Colors.black.withOpacity(0.25))
      ]);

  static final String generatedRideID = 'INSTANCE';
}
