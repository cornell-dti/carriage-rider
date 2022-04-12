import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';

/// Black button with white text
class CButton extends StatelessWidget {
  final String text;
  final double height;
  final void Function() onPressed;

  CButton(
      {@required this.text, @required this.height, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        primary: Colors.black,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: CarriageTheme.button),
      onPressed: onPressed,
    );
  }
}
