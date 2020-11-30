import 'package:carriage_rider/Request_Ride_Loc.dart';
import 'package:carriage_rider/Review_Ride.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/RideObject.dart';

class RequestRideTime extends StatefulWidget {
  final RideObject ride;

  RequestRideTime({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideTimeState createState() => _RequestRideTimeState();
}

class _RequestRideTimeState extends State<RequestRideTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text("Date & Time",
                        style: RideRequestStyles.question(context)),
                  )
                ],
              ),
              TabBarTop(
                  colorOne: Colors.black,
                  colorTwo: Colors.black,
                  colorThree: Colors.grey[350]),
              TabBarBot(
                  colorOne: Colors.green,
                  colorTwo: Colors.black,
                  colorThree: Colors.grey[350]),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text("Is this a repeating ride? (1/2)",
                        style: RideRequestStyles.question(context)),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SelectionButton(
                      text: 'Yes',
                    ),
                    SizedBox(width: 30.0),
                    SelectionButton(text: 'No', page: RequestRideNoRepeat())
                  ]),
              FlowBack()
            ],
          ),
        )));
  }
}

class RequestRideNoRepeat extends StatefulWidget {
  final RideObject ride;

  RequestRideNoRepeat({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideNoRepeatState createState() => _RequestRideNoRepeatState();
}

class _RequestRideNoRepeatState extends State<RequestRideNoRepeat> {
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
        pickUpCtrl.text = "${_pickUpTime.format(context)}";
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
        dropOffCtrl.text = "${_dropOffTime.format(context)}";
      });
    }
  }

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
        dateCtrl.text = format("$selectedDate".split(' ')[0]);
      });
  }

  Widget _buildPickupTimeField() {
    return TextFormField(
      controller: pickUpCtrl,
      decoration: InputDecoration(
          labelText: 'Pickup Time',
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never),
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
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never),
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
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text("Date & Time",
                        style: RideRequestStyles.question(context)),
                  )
                ],
              ),
              TabBarTop(
                  colorOne: Colors.black,
                  colorTwo: Colors.black,
                  colorThree: Colors.grey[350]),
              TabBarBot(
                  colorOne: Colors.green,
                  colorTwo: Colors.black,
                  colorThree: Colors.grey[350]),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Text("When is this ride? (2/2)",
                      style: RideRequestStyles.question(context)),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text("Date & Time",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 17),
                          floatingLabelBehavior: FloatingLabelBehavior.never),
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
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(children: <Widget>[
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.1,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              elevation: 2.0,
                              color: Colors.white,
                              child: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                          SizedBox(width: 40),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.65,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            child: RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              ReviewRide(ride: widget.ride)));
                                  widget.ride.startDate = dateCtrl.text;
                                  widget.ride.endDate = dateCtrl.text;
                                  widget.ride.pickUpTime = pickUpCtrl.text;
                                  widget.ride.dropOffTime = dropOffCtrl.text;
                                }
                              },
                              elevation: 2.0,
                              color: Colors.black,
                              textColor: Colors.white,
                              child: Text("Set Date & Time"),
                            ),
                          ),
                        ]))),
              ),
            ],
          ),
        ));
  }
}
