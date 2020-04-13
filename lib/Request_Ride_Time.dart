import 'package:flutter/material.dart';
import 'package:carriage_rider/Home.dart';

class RequestRideTime extends StatelessWidget {
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
                Icon(Icons.remove_circle),
                Icon(Icons.calendar_today),
                Icon(Icons.remove_circle_outline),
                Icon(Icons.remove_circle_outline),
                Icon(Icons.remove_circle_outline)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(),
            margin: EdgeInsets.only(right: 125.0),
            child: Text("When is this ride?", style: questionStyle),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30.0),
                child: Text("Repeat", style: TextStyle(fontWeight: FontWeight.w900),),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text("Once"),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(right: 300.0),
            child: Text("Date", style: fromToStyle),
          ),
          Container(
            margin: EdgeInsets.only(right: 240.0),
            child: Text("02/20/2020", style: locationStyle),
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
            margin: EdgeInsets.only(right: 260.0),
            child: Text("Pickup Time", style: fromToStyle),
          ),
          Container(
            margin: EdgeInsets.only(right: 260.0),
            child: Text("10:30 AM", style: locationStyle),
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
            margin: EdgeInsets.only(right: 250.0),
            child: Text("Drop-off Time", style: fromToStyle),
          ),
          Container(
            margin: EdgeInsets.only(right: 260.0),
            child: Text("10:50 AM", style: locationStyle),
          ),
          Container(
            margin: EdgeInsets.only(right: 30.0, left: 30.0),
            child: Divider(
              height: 10,
              thickness: 3,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 140.0),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: 50,
            child: RaisedButton(
              onPressed: () {},
              child: Text('Next'),
              textColor: Colors.white,
              color: Colors.black,
            ),
          ),
        ],
      ),

    );
  }
}
