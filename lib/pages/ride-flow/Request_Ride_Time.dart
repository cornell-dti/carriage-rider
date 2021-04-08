import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Review_Ride.dart';
import 'package:carriage_rider/pages/ride-flow/ToggleButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

DateTime assignDate() {
  DateTime now = DateTime.now();
  DateTime compare = DateTime(now.year, now.month, now.day, 10);
  return now.difference(compare).inMinutes >= 0
      ? DateTime(now.year, now.month, now.day + 2)
      : DateTime(now.year, now.month, now.day);
}

class RequestRideTime extends StatefulWidget {
  final Ride ride;

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
          margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Date & Time', style: CarriageTheme.title1),
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
                  Expanded(
                    child: Text('Is this a repeating ride? (1/2)',
                        style: CarriageTheme.title1),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SelectionButton(
                        text: 'Yes',
                        page: RequestRideRepeat(ride: widget.ride)),
                    SizedBox(width: 30.0),
                    SelectionButton(
                        text: 'No',
                        page: RequestRideNoRepeat(ride: widget.ride))
                  ]),
              FlowBack()
            ],
          ),
        )));
  }
}

class RequestRideNoRepeat extends StatefulWidget {
  final Ride ride;

  RequestRideNoRepeat({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideNoRepeatState createState() => _RequestRideNoRepeatState();
}

class _RequestRideNoRepeatState extends State<RequestRideNoRepeat> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  DateTime selectedDate = assignDate();
  TimeOfDay _pickUpTime = TimeOfDay.now();
  TimeOfDay _dropOffTime = TimeOfDay.now();

  TextEditingController dateCtrl = TextEditingController();
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController dropOffCtrl = TextEditingController();

  Future<Null> selectPickUpTime(BuildContext context) async {
    final now = selectedDate;
    _pickUpTime = await showTimePicker(
      context: context,
      initialTime: _pickUpTime,
    );
    if (_pickUpTime != null) {
      setState(() {
        widget.ride.startTime = new DateTime(
            now.year, now.month, now.day, _pickUpTime.hour, _pickUpTime.minute);
        pickUpCtrl.text = '${_pickUpTime.format(context)}';
      });
    }
  }

  Future<Null> selectDropOffTime(BuildContext context) async {
    final now = selectedDate;
    _dropOffTime = await showTimePicker(
      context: context,
      initialTime: _dropOffTime,
    );
    if (_dropOffTime != null) {
      setState(() {
        widget.ride.endTime = new DateTime(now.year, now.month, now.day,
            _dropOffTime.hour, _dropOffTime.minute);
        dropOffCtrl.text = '${_dropOffTime.format(context)}';
      });
    }
  }

  String format(String date) {
    var dates = date.split('-');
    String formatDate = dates[1] + '/' + dates[2] + '/' + dates[0];
    return formatDate;
  }

  _selectDate(BuildContext context) async {
    DateTime date = selectedDate;
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: date,
      lastDate: DateTime(date.year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateCtrl.text = format('$selectedDate'.split(' ')[0]);
      });
  }

  Widget _buildPickupTimeField() {
    return TextFormField(
      controller: pickUpCtrl,
      focusNode: AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
          labelText: 'Pickup Time',
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never),
      validator: (input) {
        if (input.isNotEmpty) {
          if (_dropOffTime != null &&
              toDouble(_dropOffTime) < toDouble(_pickUpTime)) {
            return 'Start time must be before pick up time';
          }
          return null;
        }
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
      focusNode: AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
          labelText: 'Drop-off Time',
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never),
      validator: (input) {
        if (input.isNotEmpty) {
          if (_pickUpTime != null &&
              toDouble(_dropOffTime) < toDouble(_pickUpTime)) {
            return 'End time must be after start time';
          }
          return null;
        }
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
          margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Date & Time', style: CarriageTheme.title1),
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
                    child: Text('When is your ride? (2/2)',
                        style: CarriageTheme.title1),
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text('Date & Time',
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
                      focusNode: AlwaysDisabledFocusNode(),
                      decoration: InputDecoration(
                          labelText: 'Date',
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
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Row(children: <Widget>[
                          FlowBackDuo(),
                          SizedBox(width: 40),
                          ButtonTheme(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.65,
                              height: 50.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Expanded(
                                child: RaisedButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewRide(
                                                        ride: widget.ride)));
                                        widget.ride.recurring = false;
                                      }
                                    },
                                    elevation: 2.0,
                                    color: Colors.black,
                                    textColor: Colors.white,
                                    child: Text('Set Date & Time',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              )),
                        ]))),
              ),
            ],
          ),
        ));
  }
}

class RequestRideRepeat extends StatefulWidget {
  final Ride ride;

  RequestRideRepeat({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideRepeatState createState() => _RequestRideRepeatState();
}

class _RequestRideRepeatState extends State<RequestRideRepeat> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  DateTime startDate = assignDate();
  DateTime endDate = assignDate();
  TimeOfDay _pickUpTime = TimeOfDay.now();
  TimeOfDay _dropOffTime = TimeOfDay.now();

  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController dropOffCtrl = TextEditingController();

  Future<Null> selectPickUpTime(BuildContext context) async {
    final now = startDate;
    _pickUpTime = await showTimePicker(
      context: context,
      initialTime: _pickUpTime,
    );
    if (_pickUpTime != null) {
      setState(() {
        widget.ride.startTime = new DateTime(
            now.year, now.month, now.day, _pickUpTime.hour, _pickUpTime.minute);
        pickUpCtrl.text = '${_pickUpTime.format(context)}';
      });
    }
  }

  Future<Null> selectDropOffTime(BuildContext context) async {
    final now = startDate;
    _dropOffTime = await showTimePicker(
      context: context,
      initialTime: _dropOffTime,
    );
    if (_dropOffTime != null) {
      setState(() {
        widget.ride.endTime = new DateTime(now.year, now.month, now.day,
            _dropOffTime.hour, _dropOffTime.minute);
        dropOffCtrl.text = '${_dropOffTime.format(context)}';
      });
    }
  }

  String format(String date) {
    var dates = date.split('-');
    String formatDate = dates[1] + '/' + dates[2] + '/' + dates[0];
    return formatDate;
  }

  _selectDate(
      BuildContext context, DateTime date, TextEditingController ctrl) async {
    DateTime init = startDate;
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: init,
      lastDate: DateTime(init.year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

    if (picked != null)
      setState(() {
        date = picked;
        if (ctrl == endDateCtrl) {
          widget.ride.endDate = date;
        }
        ctrl.text = format('$date'.split(' ')[0]);
      });
  }

  Widget _buildPickupTimeField() {
    return Container(
        width: MediaQuery.of(context).size.width / 3,
        margin: EdgeInsets.only(left: 15.0),
        child: TextFormField(
          focusNode: AlwaysDisabledFocusNode(),
          controller: pickUpCtrl,
          decoration: InputDecoration(
              errorMaxLines: 3,
              labelText: 'Pickup Time',
              labelStyle: TextStyle(color: Colors.grey, fontSize: 17)),
          validator: (input) {
            if (input.isNotEmpty) {
              if (_dropOffTime != null &&
                  toDouble(_dropOffTime) < toDouble(_pickUpTime)) {
                return 'Start time must be before pick up time';
              }
              return null;
            }
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
          focusNode: AlwaysDisabledFocusNode(),
          controller: dropOffCtrl,
          decoration: InputDecoration(
              errorMaxLines: 3,
              labelText: 'Drop-off Time',
              labelStyle: TextStyle(color: Colors.grey, fontSize: 17)),
          validator: (input) {
            if (input.isNotEmpty) {
              if (_pickUpTime != null &&
                  toDouble(_dropOffTime) < toDouble(_pickUpTime)) {
                return 'End time must be after start time';
              }
              return null;
            }
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

  List<bool> isSelected = List.filled(5, false);
  final List<String> days = ['M', 'T', 'W', 'Th', 'F'];
  String selectedDays = '';
  List<int> recurringDays = [];

  List<int> setRecurringDays(List<int> rDays) {
    rDays = [];
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        rDays.add(i + 1);
      }
    }
    return rDays;
  }

  String setSelectedDays(String sDays) {
    sDays = '';
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        sDays += days[i] + ' ';
      }
    }
    if (sDays.length == 0) {
      return sDays;
    }
    return sDays.substring(0, sDays.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Date & Time', style: CarriageTheme.title1),
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
                    child: Text('When is your ride? (2/2)',
                        style: CarriageTheme.title1),
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text('Date & Time',
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
                            focusNode: AlwaysDisabledFocusNode(),
                            decoration: InputDecoration(
                                errorMaxLines: 3,
                                labelText: 'Start Date',
                                labelStyle: TextStyle(
                                    color: Colors.grey, fontSize: 17)),
                            validator: (input) {
                              if (input.isNotEmpty &&
                                  endDateCtrl.text != '' &&
                                  DateFormat('MM/dd/yyyy')
                                          .parse(startDateCtrl.text)
                                          .difference(DateFormat('MM/dd/yyyy')
                                              .parse(endDateCtrl.text))
                                          .inDays >
                                      0) {
                                return 'Start date must be before end date';
                              }
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
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: endDateCtrl,
                            decoration: InputDecoration(
                              errorMaxLines: 3,
                              labelText: 'End Date',
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                            validator: (input) {
                              if (input.isNotEmpty &&
                                  startDateCtrl.text != '' &&
                                  DateFormat('MM/dd/yyyy')
                                          .parse(startDateCtrl.text)
                                          .difference(DateFormat('MM/dd/yyyy')
                                              .parse(endDateCtrl.text))
                                          .inDays >
                                      0) {
                                return 'End date must be after start date';
                              }
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
                        SizedBox(width: 30.0),
                        _buildDropOTimeField(),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text('Repeat Days',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  ToggleButton(0, 'M', isSelected),
                  SizedBox(width: 15),
                  ToggleButton(1, 'T', isSelected),
                  SizedBox(width: 15),
                  ToggleButton(2, 'W', isSelected),
                  SizedBox(width: 15),
                  ToggleButton(3, 'Th', isSelected),
                  SizedBox(width: 15),
                  ToggleButton(4, 'F', isSelected),
                ],
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Row(children: <Widget>[
                          FlowBackDuo(),
                          SizedBox(width: 40),
                          ButtonTheme(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.65,
                              height: 50.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Expanded(
                                child: RaisedButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewRide(
                                                      ride: widget.ride,
                                                      selectedDays:
                                                          selectedDays,
                                                    )));
                                        selectedDays =
                                            setSelectedDays(selectedDays);
                                        recurringDays =
                                            setRecurringDays(recurringDays);
                                        widget.ride.recurring = true;
                                        widget.ride.recurringDays =
                                            recurringDays;
                                      }
                                    },
                                    elevation: 2.0,
                                    color: Colors.black,
                                    textColor: Colors.white,
                                    child: Text('Set Date & Time',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              )),
                        ]))),
              ),
            ],
          ),
        ));
  }
}
