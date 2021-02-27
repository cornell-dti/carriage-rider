import 'package:carriage_rider/Maps.dart';
import 'package:carriage_rider/Request_Ride_Time.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/Home.dart';

class RideRequestStyles {
  static TextStyle cancel(context) {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w100,
      fontSize: 15,
    );
  }

  static TextStyle question(context) {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontSize: 25,
    );
  }

  static TextStyle toggle(context) {
    return TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 15,
    );
  }

  static TextStyle description(context) {
    return TextStyle(
        color: Colors.grey, fontWeight: FontWeight.w100, fontSize: 13);
  }

  static TextStyle label(context) {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.w300, fontSize: 11);
  }

  static TextStyle info(context) {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);
  }
}

class RequestRideLoc extends StatefulWidget {
  @override
  _RequestRideLocState createState() => _RequestRideLocState();
}

class _RequestRideLocState extends State<RequestRideLoc> {
  Widget _buildFromField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'From'),
    );
  }

  Widget _buildToField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'To'),
    );
  }

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
                  child: Text("Cancel", style: RideRequestStyles.cancel(context)),
                  onTap: () {
                    Navigator.pop(context,
                        new MaterialPageRoute(builder: (context) => Home()));
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(Icons.location_on),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(Icons.brightness_1,
                    color: Colors.grey[350], size: 12.0),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(Icons.brightness_1,
                    color: Colors.grey[350], size: 12.0),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(Icons.brightness_1,
                    color: Colors.grey[350], size: 12.0),
              ),
              Icon(Icons.brightness_1, color: Colors.grey[350], size: 12.0),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Text("Where do you want to go?", style: RideRequestStyles.question(context)),
            ],
          ),
          SizedBox(height: 20.0),
          Container(
              height: 180,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ShowPickupDestinationMap())),
          SizedBox(height: 20.0),
          Form(
            child: Column(
              children: <Widget>[
                _buildFromField(),
                SizedBox(height: 40.0),
                _buildToField(),
                SizedBox(height: 10.0)
              ],
            ),
          ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    height: 45.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => RequestRideTime()));
                      },
                      elevation: 3.0,
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('Next'),
                    ),
                  ),
                )),
          )
        ],
      ),
    ));
  }
}
