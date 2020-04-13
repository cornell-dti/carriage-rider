import 'package:carriage_rider/Request_Ride_Time.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/Home.dart';

class Request_Ride_Loc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cancelStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w100,
        fontSize: 15,
        height: 2
    );

    final fromToStyle = TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w200,
        fontSize: 12,
        height: 2
    );

    final questionStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontSize: 25,
        height: 4
    );

    final locationStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 2
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 290.0, top: 45.0),
              child: InkWell(
                child: Text("Cancel", style: cancelStyle),
                onTap: () {
                  Navigator.pop(context, new MaterialPageRoute(builder: (context) => Home()));
                },
              ),
          ),
          SizedBox(height: 70.0),
          Container(
            margin: EdgeInsets.only(left: 23.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.location_on),
                Icon(Icons.remove_circle_outline),
                Icon(Icons.remove_circle_outline),
                Icon(Icons.remove_circle_outline),
                Icon(Icons.remove_circle_outline)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(),
            margin: EdgeInsets.only(right: 25.0),
            child: Text("Where do you want to go?", style: questionStyle),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(right: 300.0),
            child: Text("From", style: fromToStyle),
          ),
          Container(
            margin: EdgeInsets.only(right: 145.0),
            child: Text("Bill & Melinda Gates Hall", style: locationStyle),
          ),
          Container(
            margin: EdgeInsets.only(right: 30.0, left: 30.0),
            child: Divider(
              height: 10,
              thickness: 3,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(right: 320.0),
            child: Text("To", style: fromToStyle),
          ),
          Container(
            margin: EdgeInsets.only(right: 245.0),
            child: Text("Barton Hall", style: locationStyle),
          ),
          Container(
            margin: EdgeInsets.only(right: 30.0, left: 30.0),
            child: Divider(
              height: 10,
              thickness: 3,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 240.0),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: 50,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (context) => RequestRideTime()));
              },
              child: Text('Next'),
              textColor: Colors.white,
              color: Colors.black,
            ),
          )

        ],
      ),

    );
  }
}
