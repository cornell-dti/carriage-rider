import 'package:flutter/material.dart';

class PopButton extends StatelessWidget {
  PopButton(this.context, this.text);
  final BuildContext context;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, top: 16, bottom: 15),
        child: Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.black),
              Text(text, style: TextStyle(fontSize: 17))
            ]
        ),
      ),
    );
  }
}