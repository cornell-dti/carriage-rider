import 'package:carriage_rider/Request_Ride_Loc.dart';
import 'package:carriage_rider/Repeat_Ride.dart';
import 'package:flutter/material.dart';
class RequestRideTime extends StatefulWidget {

  @override
  _RequestRideTimeState createState() => _RequestRideTimeState();
}

class _RequestRideTimeState extends State<RequestRideTime> {
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
    fontSize: 15,
  );

  final List<bool> isSelected = [true, false];

  Widget _buildDateField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Date'),
    );
  }

  Widget _buildPickupTimeField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Pickup Time'),
    );
  }

  Widget _buildDropOTimeField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Drop-off Time'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      child: Text("Cancel", style: cancelStyle),
                      onTap: () {
                        Navigator.pop(context, new MaterialPageRoute(builder: (context) => RequestRideLoc()));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.brightness_1, size: 12.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.calendar_today),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.brightness_1, color: Colors.grey[350], size: 12.0),
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
                  Text("When is this ride?", style: questionStyle),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ToggleButtons(
                    color: Colors.grey,
                    selectedColor: Colors.black,
                    renderBorder: false,
                    fillColor: Colors.white,
                    splashColor: Colors.white,
                    children: <Widget>[
                      Text('Repeat', style: toggleStyle),
                      Text('Once', style: toggleStyle)
                    ],
                    onPressed: (int index){
                      setState(() {
                        for(int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++)
                          if(buttonIndex == index){
                            isSelected[buttonIndex] = true;
                          } else{
                            isSelected[buttonIndex] = false;
                          }
                      });
                    },
                    isSelected: isSelected,
                  ),
                ],
              ),
              Form(
                child: Column(
                  children: <Widget>[
                    _buildDateField(),
                    SizedBox(height: 10.0),
                    _buildPickupTimeField(),
                    SizedBox(height: 10.0),
                    _buildDropOTimeField(),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        height: 45.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => RepeatRide()));
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
        )
    );
  }
}
