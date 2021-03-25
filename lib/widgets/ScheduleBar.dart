import 'package:flutter/material.dart';

import '../pages/Home.dart';

class ScheduleBar extends StatelessWidget implements PreferredSizeWidget {
  static final double prefHeight = 80;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: prefHeight,
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => Home())
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) => Home())
                      );
                    },
                  ),
                  Text('Schedule', style: TextStyle(fontSize: 17))
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefHeight);
}
