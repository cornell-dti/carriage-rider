import 'package:carriage_rider/Assistance.dart';
import 'package:carriage_rider/Request_Ride_Time.dart';
import 'package:flutter/material.dart';

class RepeatRide extends StatefulWidget {
  @override
  _RepeatRideState createState() => _RepeatRideState();
}

class _RepeatRideState extends State<RepeatRide> {

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

  final toggleStyle = TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: 18,
  );

  final descriptionStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w100,
    fontSize: 13
  );

  final List<bool> isSelected = [false, false, false, false, false];

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
                      Navigator.pop(context, new MaterialPageRoute(builder: (context) => RequestRideTime()));
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
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.repeat),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, color: Colors.grey[350], size: 12.0),
                ),
                Icon(Icons.brightness_1, color: Colors.grey[350], size: 12.0),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Flexible(child: Text("When do you want to repeat this ride?", style: questionStyle))
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('This ride repeats every:', style: descriptionStyle),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ToggleButtons(
                  constraints: BoxConstraints.expand(width: 70, height: 60.0),
                  color: Colors.grey,
                  selectedColor: Colors.black,
                  renderBorder: false,
                  fillColor: Colors.white,
                  splashColor: Colors.white,
                  children: <Widget>[
                    Text('M', style: toggleStyle),
                    Text('T', style: toggleStyle),
                    Text('W', style: toggleStyle),
                    Text('Th', style: toggleStyle),
                    Text('F', style: toggleStyle)
                  ],
                  onPressed: (int index){
                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });
                  },
                  isSelected: isSelected,
                ),
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
                          Navigator.push(context, new MaterialPageRoute(builder: (context) => Assistance()));
                        },
                        elevation: 3.0,
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text('Next'),
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
