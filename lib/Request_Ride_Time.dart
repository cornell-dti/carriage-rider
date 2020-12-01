import 'package:carriage_rider/Request_Ride_Loc.dart';
import 'package:carriage_rider/Review_Ride.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
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
                        repeatPage: true,
                        onPressed: () => widget.ride.recurring = true,
                        page: RequestRideRepeat(ride: widget.ride)),
                    SizedBox(width: 30.0),
                    SelectionButton(
                        text: 'No',
                        repeatPage: true,
                        onPressed: () => widget.ride.recurring = false,
                        page: RequestRideNoRepeat(ride: widget.ride))
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
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          FlowBackDuo(),
                          SizedBox(width: 40),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.65,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
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

class RequestRideRepeat extends StatefulWidget {
  final RideObject ride;

  RequestRideRepeat({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideRepeatState createState() => _RequestRideRepeatState();
}

class _RequestRideRepeatState extends State<RequestRideRepeat> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay _pickUpTime = TimeOfDay.now();
  TimeOfDay _dropOffTime = TimeOfDay.now();

  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
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

  String format(String date) {
    var dates = date.split('-');
    String formatDate = dates[1] + "/" + dates[2] + "/" + dates[0];
    return formatDate;
  }

  _selectDate(
      BuildContext context, DateTime date, TextEditingController ctrl) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

    if (picked != null && picked != date)
      setState(() {
        date = picked;
        ctrl.text = format("$date".split(' ')[0]);
      });
  }

  Widget _buildPickupTimeField() {
    return Container(
        width: MediaQuery.of(context).size.width / 3,
        margin: EdgeInsets.only(left: 15.0),
        child: TextFormField(
          controller: pickUpCtrl,
          decoration: InputDecoration(
              labelText: 'Pickup Time',
              labelStyle: TextStyle(color: Colors.grey, fontSize: 17)),
          validator: (input) {
            if (input.isEmpty) {
              return 'Please enter your pickup time';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          onTap: () => selectPickUpTime(context),
          style: TextStyle(color: Colors.black, fontSize: 15),
        ));
  }

  Widget _buildDropOTimeField() {
    return Container(
        width: MediaQuery.of(context).size.width / 3,
        margin: EdgeInsets.only(right: 15.0),
        child: TextFormField(
          controller: dropOffCtrl,
          decoration: InputDecoration(
              labelText: 'Drop-off Time',
              labelStyle: TextStyle(color: Colors.grey, fontSize: 17)),
          validator: (input) {
            if (input.isEmpty) {
              return 'Please enter your drop-off time';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
          onTap: () => selectDropOffTime(context),
          style: TextStyle(color: Colors.black, fontSize: 15),
        ));
  }

  final List<bool> isSelected = [false, false, false, false, false];
  final List<String> days = ["M", "T", "W", "Th", "F"];

  String selectedDays = "";

  String setSelectedDays(String sDays) {
    sDays = "";

    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        sDays += days[i] + " ";
      }
    }
    sDays = sDays.substring(0, sDays.length - 1);
    return sDays;
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
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          margin: EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                            controller: startDateCtrl,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                                labelText: 'Start Date',
                                labelStyle: TextStyle(
                                    color: Colors.grey, fontSize: 17)),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please enter the date';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onTap: () =>
                                _selectDate(context, startDate, startDateCtrl),
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          margin: EdgeInsets.only(right: 15.0),
                          child: TextFormField(
                            controller: endDateCtrl,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please enter the date';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onTap: () =>
                                _selectDate(context, endDate, endDateCtrl),
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        _buildPickupTimeField(),
                        SizedBox(width: 20.0),
                        _buildDropOTimeField(),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text("Repeat Days",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomToggleButtons(constraints: BoxConstraints.expand(width: 60, height: 60.0, ),
                    color: Colors.grey,
                    spacing: 5,
                    selectedColor: Colors.white,
                    renderBorder: true,
                    borderColor: Colors.black,
                    fillColor: Colors.black,
                    splashColor: Colors.white,
                    children: <Widget>[
                      Text('M', style: RideRequestStyles.toggle(context)),
                      Text('T', style: RideRequestStyles.toggle(context)),
                      Text('W', style: RideRequestStyles.toggle(context)),
                      Text('Th', style: RideRequestStyles.toggle(context)),
                      Text('F', style: RideRequestStyles.toggle(context))
                    ],
                    onPressed: (int index) {
                      setState(() {
                        isSelected[index] = !isSelected[index];
                        selectedDays = setSelectedDays(selectedDays);
                      });
                    },
                    isSelected: isSelected,)
                ],
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(children: <Widget>[
                          FlowBackDuo(),
                          SizedBox(width: 40),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.65,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              ReviewRide(ride: widget.ride)));
                                  widget.ride.startDate = startDateCtrl.text;
                                  widget.ride.endDate = endDateCtrl.text;
                                  widget.ride.pickUpTime = pickUpCtrl.text;
                                  widget.ride.dropOffTime = dropOffCtrl.text;
                                  widget.ride.every = selectedDays;
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
