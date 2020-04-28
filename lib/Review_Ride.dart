import 'package:carriage_rider/Assistance.dart';
import 'package:carriage_rider/Ride_Confirmation.dart';
import 'package:flutter/material.dart';

class ReviewRide extends StatefulWidget {
  @override
  _ReviewRideState createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {

  final cancelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w100,
    fontSize: 15,
  );

  final questionStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontSize: 25,
  );

  final labelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontSize: 11
  );

  final infoStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 16
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: InkWell(
                    child: Text("Cancel", style: cancelStyle),
                    onTap: () {
                      Navigator.pop(context, new MaterialPageRoute(builder: (context) => Assistance()));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Icon(Icons.check),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Flexible(child: Text("Review your ride", style: questionStyle))
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('From', style: labelStyle)
              ]
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Bill & Melinda Gates Hall', style: infoStyle)
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('To', style: labelStyle)
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Barton Hall', style: infoStyle)
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Date', style: labelStyle)
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('02/20/2020', style: infoStyle)
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Pickup Time', style: labelStyle),
                      SizedBox(height: 5),
                      Text('10:30 AM', style: infoStyle)
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Drop-off Time', style: labelStyle),
                      SizedBox(height: 5),
                      Text('10:50 AM', style: infoStyle)
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Every', style: labelStyle)
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('M W F', style: infoStyle)
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Accessibility Request', style: labelStyle)
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Wheelchair', style: infoStyle)
              ],
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: 45.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.push(context, new MaterialPageRoute(builder: (context) => RideConfirmation()));
                        },
                        elevation: 3.0,
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text('Send Request'),
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
