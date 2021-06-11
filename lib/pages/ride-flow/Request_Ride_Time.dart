import 'dart:async';
import 'dart:math';
import 'package:carriage_rider/pages/ride-flow/Review_Ride.dart';
import 'package:carriage_rider/pages/ride-flow/ToggleButton.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/widgets/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';

double timeToDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

DateTime firstPossibleRideDate() {
  DateTime now = DateTime.now();
  DateTime today10AM = DateTime(now.year, now.month, now.day, 10);
  return now.isAfter(today10AM)
      ? DateTime(now.year, now.month, now.day + 2)
      : DateTime(now.year, now.month, now.day + 1);
}

class RequestRideType extends StatefulWidget {

  RequestRideType({Key key}) : super(key: key);

  @override
  _RequestRideTypeState createState() => _RequestRideTypeState();
}

class _RequestRideTypeState extends State<RequestRideType> {
  @override
  Widget build(BuildContext context) {
    double horizPadding = min(MediaQuery.of(context).size.width * 0.05, 20);
    double buttonSpacing = min(MediaQuery.of(context).size.width * 0.1, 20);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 40.0, left: horizPadding, right: horizPadding),
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
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 48,
                          onPressed: () {
                            rideFlowProvider.setRecurring(true);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => RequestRideDateTime()
                            ));
                          },
                        ),
                        SizedBox(width: buttonSpacing),
                        SelectionButton(
                            text: 'No',
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 48,
                            onPressed: () {
                              rideFlowProvider.setRecurring(false);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => RequestRideDateTime()
                              ));
                            }
                        )
                      ]
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: BackArrowButton(50),
                        )
                    ),
                  )
                ],
              ),
            )));
  }
}

class RequestRideDateTime extends StatefulWidget {

  RequestRideDateTime({Key key}) : super(key: key);

  @override
  _RequestRideDateTimeState createState() => _RequestRideDateTimeState();
}

class _RequestRideDateTimeState extends State<RequestRideDateTime> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();

  bool showSelectionError;
  String startDateError;
  String endDateError;
  String startTimeError;
  String endTimeError;

  @override
  void initState() {
    super.initState();
    setState(() {
      showSelectionError = false;
      startDateError = '';
      endDateError = '';
      startTimeError = '';
      endTimeError = '';
    });
  }

  Future<void> selectTime(BuildContext context, TimeOfDay init, Function selectCallback) async {
    TimeOfDay selection = await showTimePicker(
      context: context,
      initialTime: init,
    );
    if (selection != null) {
      selectCallback(selection);
    }
  }

  Future<void> selectDate(BuildContext context, DateTime init, Function selectCallback) async {
    final DateTime selection = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: firstPossibleRideDate(),
      lastDate: DateTime(init.year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (selection != null) {
      selectCallback(selection);
    }
  }

  void toggle(RideFlowProvider rideFlowProvider, int index) {
    setState(() {
      showSelectionError = false;
    });
    rideFlowProvider.toggleRepeatDays(index);
  }

  @override
  Widget build(BuildContext context) {
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    bool showRecurringFields = (rideFlowProvider.creating() && rideFlowProvider.recurring) || rideFlowProvider.editingAll();

    Widget buildInputField(TextEditingController ctrl, String label, String errorInfo, Function onTap) {
      bool hasText = ctrl.text != null && ctrl.text != '';
      String labelInfo = hasText ? 'Selected $label: ${ctrl.text}' : 'Select $label';
      String semanticsLabel = labelInfo;
      bool hasError = errorInfo != null && errorInfo.isNotEmpty;
      if (hasError) {
        semanticsLabel += '. Error: $errorInfo.';
      }

      return Semantics(
          label: semanticsLabel,
          focusable: true,
          onTap: onTap,
          button: true,
          child: ExcludeSemantics(
              child: Column(
                children: [
                  TextFormField(
                    controller: ctrl,
                    enableInteractiveSelection: false,
                    focusNode: AlwaysDisabledFocusNode(),
                    onTap: onTap,
                    decoration: InputDecoration(
                        errorMaxLines: 3,
                        labelText: label,
                        labelStyle: TextStyle(
                            color: Colors.grey, fontSize: 17
                        ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey),
                      ),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  hasError ? Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(errorInfo, style: TextStyle(color: Colors.red),),
                  ) : Container()
                ],
              )
          )
      );
    }

    String validateStartDate(bool checkEmpty) {
      String error;
      if (rideFlowProvider.startDate != null) {
        if (showRecurringFields && rideFlowProvider.endDate != null && rideFlowProvider.startDate.isAfter(rideFlowProvider.endDate)) {
          error = 'Start date must be before end date';
        }
      }
      else if (checkEmpty) {
        error = 'Please enter the ' + (rideFlowProvider.recurring ? 'start date' : 'date');
      }
      startDateError = error;
      return error;
    }

    String validateEndDate(bool checkEmpty) {
      String error;
      if (rideFlowProvider.recurring) {
        if (rideFlowProvider.endDate != null) {
          if (rideFlowProvider.startDate != null &&
              rideFlowProvider.startDate.isAfter(rideFlowProvider.endDate)) {
            error = 'End date must be after start date';
          }
        }
        else if (checkEmpty) {
          error = 'Please enter the end date';
        }
      }
      endDateError = error;
      return error;
    }

    Future<void> selectStartDate() async {
      await selectDate(context, rideFlowProvider.startDate == null ? firstPossibleRideDate() : rideFlowProvider.startDate, (DateTime selection) {
        rideFlowProvider.setStartDate(selection);
        setState(() {
          startDateError = validateStartDate(true);
          endDateError = validateEndDate(false);
        });
      });
    }

    Future<void> selectEndDate() async {
      await selectDate(context, rideFlowProvider.endDate == null ? firstPossibleRideDate() : rideFlowProvider.endDate, (DateTime selection) {
        rideFlowProvider.setEndDate(selection);
        setState(() {
          startDateError = validateStartDate(false);
          endDateError = validateEndDate(true);
        });
      });
    }

    String validateStartTime(bool checkEmpty) {
      String error;
      if (rideFlowProvider.pickUpTime != null) {
        if (rideFlowProvider.dropOffTime != null && timeToDouble(rideFlowProvider.pickUpTime) >= timeToDouble(rideFlowProvider.dropOffTime)) {
          error = 'Start time must be before end time';
        }
      }
      else if (checkEmpty) {
        error = 'Please enter your pickup time';
      }
      startTimeError = error;
      return error;
    }

    String validateEndTime(bool checkEmpty) {
      String error;
      if (rideFlowProvider.dropOffTime != null ) {
        if (rideFlowProvider.pickUpTime != null && timeToDouble(rideFlowProvider.pickUpTime) >= timeToDouble(rideFlowProvider.dropOffTime)) {
          error = 'End time must be after start time';
        }
      }
      else if (checkEmpty) {
        error = 'Please enter your drop-off time';
      }
      endTimeError = error;
      return error;
    }

    void selectStartTime() {
      selectTime(context, rideFlowProvider.pickUpTime == null ? TimeOfDay.now() : rideFlowProvider.pickUpTime, (TimeOfDay selection) {
        rideFlowProvider.setPickUpTime(selection, context);
        setState(() {
          startTimeError = validateStartTime(true);
          endTimeError = validateEndTime(false);
        });
      });
    }

    void selectEndTime() {
      selectTime(context, rideFlowProvider.dropOffTime == null ? TimeOfDay.now() : rideFlowProvider.dropOffTime, (selection) {
        rideFlowProvider.setDropOffTime(selection, context);
        setState(() {
          startTimeError = validateStartTime(false);
          endTimeError = validateEndTime(true);
        });
      });
    }

    Widget startDateInput() => buildInputField(
        rideFlowProvider.startDateCtrl,
        rideFlowProvider.recurring ? 'Start Date' : 'Date',
        startDateError,
        selectStartDate
    );

    Widget endDateInput() => buildInputField(
        rideFlowProvider.endDateCtrl,
        'End Date',
        endDateError,
        selectEndDate
    );

    Widget startTimeInput() => buildInputField(
        rideFlowProvider.pickUpTimeCtrl,
        'Pickup Time',
        startTimeError,
        selectStartTime
    );

    Widget endTimeInput() => buildInputField(
        rideFlowProvider.dropOffTimeCtrl,
        'Drop-off Time',
        endTimeError,
        selectEndTime
    );

    bool allValid(bool checkEndDate) {
      bool validStartTime = validateStartTime(true) == null;
      bool validEndTime = validateEndTime(true) == null;
      bool validStartDate = validateStartDate(true) == null;
      bool validEndDate = checkEndDate ? (validateEndDate(true) == null) : true;
      return validStartDate && validEndDate && validStartTime && validEndTime;
    }
    double buttonsHeight = 48;
    double buttonsVerticalPadding = 16;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 20.0, right: 20.0, bottom: buttonsHeight + 2*buttonsVerticalPadding + 40),
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
                        child: showRecurringFields ? Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    margin: EdgeInsets.only(left: 15.0),
                                    child: startDateInput()
                                ),
                                SizedBox(width: 30),
                                Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    margin: EdgeInsets.only(right: 15.0),
                                    child: endDateInput()
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    margin: EdgeInsets.only(left: 15.0),
                                    child: startTimeInput()),
                                SizedBox(width: 30.0),
                                Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    margin: EdgeInsets.only(right: 15.0),
                                    child: endTimeInput()),
                              ],
                            )
                          ],
                        ) : Column(
                          children: [
                            startDateInput(),
                            SizedBox(height: 20.0),
                            startTimeInput(),
                            SizedBox(height: 20.0),
                            endTimeInput()
                          ],
                        ),
                      ),
                      showRecurringFields ? Column(
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
                                ToggleButton(rideFlowProvider.repeatDaysSelected[0], () => toggle(rideFlowProvider, 0), 'M', 'Mondays'),
                                SizedBox(width: 15),
                                ToggleButton(rideFlowProvider.repeatDaysSelected[1], () => toggle(rideFlowProvider, 1), 'T', 'Tuesdays'),
                                SizedBox(width: 15),
                                ToggleButton(rideFlowProvider.repeatDaysSelected[2], () => toggle(rideFlowProvider, 2), 'W', 'Wednesdays'),
                                SizedBox(width: 15),
                                ToggleButton(rideFlowProvider.repeatDaysSelected[3], () => toggle(rideFlowProvider, 3), 'Th', 'Thursdays'),
                                SizedBox(width: 15),
                                ToggleButton(rideFlowProvider.repeatDaysSelected[4], () => toggle(rideFlowProvider, 4), 'F', 'Fridays'),
                              ],
                            ),
                            showSelectionError && rideFlowProvider.repeatDaysSelected.indexOf(true) == -1 ? Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text('Select at least one day.', semanticsLabel: 'Error, please select at least one day for the ride to repeat on.', style: TextStyle(color: Colors.red)),
                            ) : Container(),
                          ]
                      ) : Container(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: buttonsVerticalPadding),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 5,
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.11))
                      ]
                  ),
                  child: Row(
                      children: [
                        BackArrowButton(buttonsHeight),
                        SizedBox(width: 24),
                        Expanded(
                          child: CButton(
                            text: 'Set Date & Time',
                            height: buttonsHeight,
                            onPressed: () {
                              if (allValid(showRecurringFields) && (showRecurringFields ? rideFlowProvider.repeatDaysSelected.indexOf(true) >= 0 : true)) {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewRide()
                                    )
                                );
                              }
                              else {
                                SemanticsService.announce('Error, please check your dates and times', TextDirection.ltr);
                                setState(() {
                                  showSelectionError = true;
                                });
                              }
                            },
                          ),
                        )
                      ]
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
