import 'package:flutter/material.dart';

class RideHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final directionStyle = TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        fontSize: 12,
        height: 2
    );

    final infoStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        fontSize: 18,
        height: 2
    );

    final monthStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        fontSize: 18,
        height: 2
    );

    final dayStyle = TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        fontSize: 18,
        height: 2
    );

    final timeStyle = TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        fontSize: 17,
        height: 2
    );

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 17.0, right: 17.0, bottom: 15.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Card(
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 2.0),
                        child: Text('OCT', style: monthStyle),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2.0, top: 1.0),
                        child: Text('18th', style: dayStyle),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2.0, top: 3.0),
                        child: Text('12:00 PM', style: timeStyle),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 11.0),
                            child: Text('From', style: directionStyle),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 11.0),
                            child: Text('Upson Hall', style: infoStyle),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 70.0),
                        child: Icon(Icons.arrow_forward),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 85.0),
                            child: Text('To', style: directionStyle),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 85.0),
                            child: Text('Uris Hall', style: infoStyle),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 17.0, right: 17.0, bottom: 15.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Card(
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 2.0),
                        child: Text('MAR', style: monthStyle),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2.0, top: 1.0),
                        child: Text('3rd', style: dayStyle),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2.0, top: 3.0),
                        child: Text('3:00 PM', style: timeStyle),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 11.0),
                            child: Text('From', style: directionStyle),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 11.0),
                            child: Text('Balch Hall', style: infoStyle),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 70.0),
                        child: Icon(Icons.arrow_forward),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 85.0),
                            child: Text('To', style: directionStyle),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 85.0),
                            child: Text('Gates Hall', style: infoStyle),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
