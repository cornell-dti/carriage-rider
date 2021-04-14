import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Review_Ride.dart';
import 'package:carriage_rider/pages/ride-flow/ToggleButton.dart';
import 'package:carriage_rider/providers/CreateRideProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';
import 'package:provider/provider.dart';

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

DateTime assignDate() {
  DateTime now = DateTime.now();
  DateTime compare = DateTime(now.year, now.month, now.day, 10);
  return now.difference(compare).inMinutes >= 0
      ? DateTime(now.year, now.month, now.day + 2)
      : DateTime(now.year, now.month, now.day);
}

class RequestRideType extends StatefulWidget {
  final Ride ride;

  RequestRideType({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideTypeState createState() => _RequestRideTypeState();
}

class _RequestRideTypeState extends State<RequestRideType> {
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
                            onPressed: () {
                              widget.ride.recurring = true;
                            },
                            page: RequestRideDateTime(ride: widget.ride)),
                        SizedBox(width: 30.0),
                        SelectionButton(
                            text: 'No',
                            onPressed: () {
                              widget.ride.recurring = false;
                            },
                            page: RequestRideDateTime(ride: widget.ride))
                      ]),
                  FlowBack()
                ],
              ),
            )));
  }
}

class RequestRideDateTime extends StatefulWidget {
  final Ride ride;

  RequestRideDateTime({Key key, @required this.ride}) : super(key: key);

  @override
  _RequestRideDateTimeState createState() => _RequestRideDateTimeState();
}

class _RequestRideDateTimeState extends State<RequestRideDateTime> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  DateTime startDate = assignDate();
  DateTime endDate = assignDate();
  TimeOfDay _pickUpTime = TimeOfDay.now();
  TimeOfDay _dropOffTime = TimeOfDay.now();

  Future<Null> selectPickUpTime(BuildContext context) async {
    CreateRideProvider createRideProvider = Provider.of<CreateRideProvider>(context, listen: false);
    final firstDate = startDate;
    _pickUpTime = await showTimePicker(
      context: context,
      initialTime: _pickUpTime,
    );
    if (_pickUpTime != null) {
      setState(() {
        widget.ride.startTime = new DateTime(
            firstDate.year, firstDate.month, firstDate.day, _pickUpTime.hour, _pickUpTime.minute);
        createRideProvider.setPickupTimeCtrl(_pickUpTime.format(context));
      });
    }
  }

  Future<Null> selectDropOffTime(BuildContext context) async {
    CreateRideProvider createRideProvider = Provider.of<CreateRideProvider>(context, listen: false);
    final firstDate = startDate;
    _dropOffTime = await showTimePicker(
      context: context,
      initialTime: _dropOffTime,
    );
    if (_dropOffTime != null) {
      setState(() {
        widget.ride.endTime = new DateTime(firstDate.year, firstDate.month, firstDate.day,
            _dropOffTime.hour, _dropOffTime.minute);
        createRideProvider.setDropoffTimeCtrl(_dropOffTime.format(context));
      });
    }
  }

  _selectDate(BuildContext context, DateTime date, TextEditingController ctrl) async {
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

    CreateRideProvider createRideProvider = Provider.of<CreateRideProvider>(context, listen: false);
    if (picked != null)
      setState(() {
        date = picked;
        if (ctrl == createRideProvider.endDateCtrl) {
          widget.ride.endDate = date;
        }
        ctrl.text = DateFormat('yMd').format(date);
      });
  }

  List<bool> isSelected = List.filled(5, false);
  bool justPressedNext = false;

  void toggle(int index) {
    setState(() {
      justPressedNext = false;
      isSelected[index] = !isSelected[index];
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.ride.recurring && widget.ride.recurringDays != null) {
      for (int day in widget.ride.recurringDays) {
        setState(() {
          isSelected[day-1] = true;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    CreateRideProvider createRideProvider = Provider.of<CreateRideProvider>(context);
    TextEditingController startDateCtrl = createRideProvider.startDateCtrl;
    TextEditingController endDateCtrl = createRideProvider.endDateCtrl;

    Widget startDateInput = TextFormField(
      controller: startDateCtrl,
      enableInteractiveSelection: false,
      focusNode: AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
          errorMaxLines: 3,
          labelText: widget.ride.recurring ? 'Start Date' : 'Date',
          labelStyle: TextStyle(
              color: Colors.grey, fontSize: 17)),
      validator: (input) {
        if (widget.ride.recurring &&
            input.isNotEmpty &&
            endDateCtrl.text != '' &&
            DateFormat('yMd').parse(startDateCtrl.text)
                .isAfter(DateFormat('yMd').parse(endDateCtrl.text))) {
          return 'Start date must be before end date';
        }
        if (input.isEmpty) {
          return 'Please enter the ' + (widget.ride.recurring ? 'start date' : 'date');
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      onTap: () =>
          _selectDate(context, startDate, startDateCtrl),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );

    Widget endDateInput = TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      enableInteractiveSelection: false,
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
                .isAfter(DateFormat('MM/dd/yyyy')
                .parse(endDateCtrl.text))) {
          return 'End date must be after start date';
        }
        if (input.isEmpty) {
          return 'Please enter the end date';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      onTap: () =>
          _selectDate(context, endDate, endDateCtrl),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );

    Widget pickUpTimeInput = TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      enableInteractiveSelection: false,
      controller: createRideProvider.pickUpCtrl,
      decoration: InputDecoration(
          errorMaxLines: 3,
          labelText: 'Pickup Time',
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17)),
      validator: (input) {
        if (input.isNotEmpty) {
          if (_dropOffTime != null &&
              toDouble(_dropOffTime) < toDouble(_pickUpTime)) {
            return 'Start time must be before end time';
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

    Widget dropOffTimeInput = TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      enableInteractiveSelection: false,
      controller: createRideProvider.dropOffCtrl,
      decoration: InputDecoration(
          errorMaxLines: 3,
          labelText: 'Drop-off Time',
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17)),
      validator: (input) {
        if (input.isNotEmpty) {
          if (_dropOffTime != null &&
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
      textInputAction: TextInputAction.next,
      onTap: () => selectDropOffTime(context),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );

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
                child: widget.ride.recurring ? Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width / 3,
                            margin: EdgeInsets.only(left: 15.0),
                            child: startDateInput
                        ),
                        SizedBox(width: 30),
                        Container(
                            width: MediaQuery.of(context).size.width / 3,
                            margin: EdgeInsets.only(right: 15.0),
                            child: endDateInput
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width / 3,
                            margin: EdgeInsets.only(left: 15.0),
                            child: pickUpTimeInput),
                        SizedBox(width: 30.0),
                        Container(
                            width: MediaQuery.of(context).size.width / 3,
                            margin: EdgeInsets.only(right: 15.0),
                            child: dropOffTimeInput),
                      ],
                    )
                  ],
                ) : Column(
                  children: [
                    startDateInput,
                    SizedBox(height: 20.0),
                    pickUpTimeInput,
                    SizedBox(height: 20.0),
                    dropOffTimeInput
                  ],
                ),
              ),
              widget.ride.recurring ? Column(
                  children: [
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
                        ToggleButton(isSelected[0], () => toggle(0), 'M'),
                        SizedBox(width: 15),
                        ToggleButton(isSelected[1], () => toggle(1), 'T'),
                        SizedBox(width: 15),
                        ToggleButton(isSelected[2], () => toggle(2), 'W'),
                        SizedBox(width: 15),
                        ToggleButton(isSelected[3], () => toggle(3), 'Th'),
                        SizedBox(width: 15),
                        ToggleButton(isSelected[4], () => toggle(4), 'F'),
                      ],
                    ),
                    justPressedNext && isSelected.indexOf(true) == -1 ? Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Select at least one day.', style: TextStyle(color: Colors.red)),
                    ) : Container()
                  ]
              ) : Container(),
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
                                      setState(() {
                                        justPressedNext = true;
                                      });
                                      if (_formKey.currentState.validate() && (widget.ride.recurring ? isSelected.indexOf(true) >= 0 : true)) {
                                        Navigator.push( context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewRide(
                                                      ride: widget.ride
                                                    )
                                            )
                                        );
                                        if (widget.ride.recurring) {
                                          List<int> selectedDays = [];
                                          for (int i = 0; i < isSelected.length; i++) {
                                            if (isSelected[i]) {
                                              selectedDays.add(i);
                                            }
                                          }
                                          widget.ride.recurringDays = selectedDays.map((index) => index+1).toList();
                                        }
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
