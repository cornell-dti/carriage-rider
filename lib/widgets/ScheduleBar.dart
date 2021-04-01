import 'package:flutter/material.dart';

class ScheduleBar extends StatelessWidget implements PreferredSizeWidget {

  ScheduleBar(this.textColor, this.backgroundColor);
  final Color textColor;
  final Color backgroundColor;

  static final double prefHeight = 80;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Schedule',
        style: TextStyle(
            color: textColor, fontSize: 20, fontFamily: 'SFPro'),
      ),
      backgroundColor: backgroundColor,
      titleSpacing: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: textColor),
        onPressed: () => Navigator.pop(context, false),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefHeight);
}
