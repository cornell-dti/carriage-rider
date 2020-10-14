import 'package:carriage_rider/Request_Ride_Loc.dart';
import 'package:carriage_rider/Repeat_Ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class RequestRideTime extends StatefulWidget {
  @override
  _RequestRideTimeState createState() => _RequestRideTimeState();
}

class _RequestRideTimeState extends State<RequestRideTime> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay _pickUpTime = TimeOfDay.now();
  TimeOfDay _dropOffTime = TimeOfDay.now();

  Future<Null> selectPickUpTime(BuildContext context) async {
    _pickUpTime = await showTimePicker(
      context: context,
      initialTime: _pickUpTime,
    );
  }

  Future<Null> selectDropOffTime(BuildContext context) async {
    _dropOffTime = await showTimePicker(
      context: context,
      initialTime: _dropOffTime,
    );
  }

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

  String format(String date) {
    var dates = date.split('-');
    String formatDate = dates[1] + "/" + dates[2] + "/" + dates[0];
    return formatDate;
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget _buildPickupTimeField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Pickup Time',
          hintText: 'Pickup Time',
          labelStyle: TextStyle(color: Colors.black)),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your pickup time';
        }
        return null;
      },
      onTap: () => selectPickUpTime(context),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );
  }

  Widget _buildDropOTimeField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Drop-off Time',
          hintText: 'Drop-off Time',
          labelStyle: TextStyle(color: Colors.black)),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your drop-off time';
        }
        return null;
      },
      onTap: () => selectDropOffTime(context),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                        Navigator.pop(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => RequestRideLoc()));
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
                    fillColor: Colors.grey[100],
                    splashColor: Colors.white,
                    children: <Widget>[
                      Text('Repeat', style: toggleStyle),
                      Text('Once', style: toggleStyle)
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelected.length;
                            buttonIndex++)
                          if (buttonIndex == index) {
                            isSelected[buttonIndex] = true;
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                      });
                    },
                    isSelected: isSelected,
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Date',
                          hintText: 'Date',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter the date';
                        }
                        return null;
                      },
                      onTap: () => _selectDate(context),
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    SizedBox(height: 20.0),
                    _buildPickupTimeField(),
                    SizedBox(height: 20.0),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => RepeatRide()));
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
