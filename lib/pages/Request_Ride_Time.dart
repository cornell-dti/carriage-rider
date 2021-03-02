import 'package:carriage_rider/pages/Request_Ride_Loc.dart';
import 'package:carriage_rider/pages/Repeat_Ride.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/models/RideObject.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

class RequestRideTime extends StatefulWidget {
  final RideObject ride;

  RequestRideTime({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideTimeState createState() => _RequestRideTimeState();
}

class _RequestRideTimeState extends State<RequestRideTime> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  DateTime selectedDate = DateTime.now();
  TimeOfDay _pickUpTime = TimeOfDay.now();
  TimeOfDay _dropOffTime = TimeOfDay.now();

  TextEditingController dateCtrl = TextEditingController();
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController dropOffCtrl = TextEditingController();

  Future<Null> selectPickUpTime(BuildContext context) async {
    _pickUpTime = await showTimePicker(
      context: context,
      initialTime: _pickUpTime,
    );
    if (_pickUpTime != null) {
      setState(() {
        pickUpCtrl.text = '${_pickUpTime.format(context)}';
      });
    }
  }

  Future<Null> selectDropOffTime(BuildContext context) async {
    _dropOffTime = await showTimePicker(
      context: context,
      initialTime: _dropOffTime,
    );
    if (_dropOffTime != null) {
      setState(() {
        dropOffCtrl.text = '${_dropOffTime.format(context)}';
      });
    }
  }

  final List<bool> isSelected = [true, false];

  String format(String date) {
    var dates = date.split('-');
    String formatDate = dates[1] + '/' + dates[2] + '/' + dates[0];
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
        dateCtrl.text = format('$selectedDate'.split(' ')[0]);
      });
  }

  Widget _buildPickupTimeField() {
    return TextFormField(
      controller: pickUpCtrl,
      decoration: InputDecoration(
          labelText: 'Pickup Time', labelStyle: TextStyle(color: Colors.black)),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your pickup time';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      onTap: () => selectPickUpTime(context),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );
  }

  Widget _buildDropOTimeField() {
    return TextFormField(
      controller: dropOffCtrl,
      decoration: InputDecoration(
          labelText: 'Drop-off Time',
          labelStyle: TextStyle(color: Colors.black)),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your drop-off time';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      onTap: () => selectDropOffTime(context),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      child: Text('Cancel', style: CarriageTheme.cancelStyle),
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
                  Text('When is this ride?', style: CarriageTheme.title1),
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
                      Text('Repeat', style: CarriageTheme.toggleStyle),
                      Text('Once', style: CarriageTheme.toggleStyle)
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
                      controller: dateCtrl,
                      focusNode: focusNode,
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
                      textInputAction: TextInputAction.next,
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
                        height: 50.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              widget.ride.date = dateCtrl.text;
                              widget.ride.pickUpTime = pickUpCtrl.text;
                              widget.ride.dropOffTime = dropOffCtrl.text;
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          RepeatRide(ride: widget.ride)));
                            }
                          },
                          elevation: 3.0,
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
