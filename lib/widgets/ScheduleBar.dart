import 'package:flutter/material.dart';

class ScheduleBar extends StatelessWidget implements PreferredSizeWidget {

  ScheduleBar(this.textColor, this.backgroundColor);
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Return to schedule',
      onTap: () => Navigator.pop(context, false),
      child: ExcludeSemantics(
        child: AppBar(
          backgroundColor: backgroundColor,
          titleSpacing: 0.0,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.arrow_back_ios, color: textColor),
              ExcludeSemantics(
                child: Text(
                  'Schedule',
                  style: TextStyle(
                      color: textColor, fontSize: 20, fontFamily: 'SFPro'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
