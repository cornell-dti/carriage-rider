import 'package:flutter/material.dart';

class UpcomingRide extends StatelessWidget {
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

    final confirmationStyle = TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        fontSize: 12,
        height: 2
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17.0),
      height: MediaQuery.of(context).size.height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 15.0),
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
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Text('OCT', style: monthStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 2.0, top: 1.0),
                          child: Text('18th', style: dayStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 2.0, top: 3.0),
                          child: Text('12:00 PM', style: timeStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 44.0),
                          child: Icon(Icons.touch_app),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('From', style: directionStyle)
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Uris Hall', style: infoStyle)
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('To', style: directionStyle)
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Cascadilla Hall', style: infoStyle)
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Ride Confirmed', style: confirmationStyle)
                        ],
                      )
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.person_pin, size: 38.0),
                        ),
                        SizedBox(width: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Davea Butler', style: infoStyle),
                            Row(
                              children: <Widget>[
                                Icon(Icons.phone, size: 13.0,),
                                SizedBox(width: 5.0),
                                Text('+ 323-231-5234')
                              ],
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
            margin: EdgeInsets.only(right: 15.0),
            width: 260.0,
            height: 300.0,
            child: Card(
              elevation: 3.0,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Text('NOV', style: monthStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 2.0, top: 1.0),
                          child: Text('20th', style: dayStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 2.0, top: 3.0),
                          child: Text('1:00 PM', style: timeStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 44.0),
                          child: Icon(Icons.touch_app),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('From', style: directionStyle)
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Balch Hall', style: infoStyle)
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('To', style: directionStyle)
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Statler Hall', style: infoStyle)
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Ride Confirmed', style: confirmationStyle)
                        ],
                      )
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.person_pin, size: 38.0),
                        ),
                        SizedBox(width: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('George Michael', style: infoStyle),
                            Row(
                              children: <Widget>[
                                Icon(Icons.phone, size: 13.0,),
                                SizedBox(width: 5.0),
                                Text('+ 323-231-5234')
                              ],
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
      ),
    );
  }
}
