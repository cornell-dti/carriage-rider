import 'package:carriage_rider/Request_Ride_Time.dart';
import 'package:carriage_rider/Review_Ride.dart';
import 'package:carriage_rider/TextThemes.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/RideObject.dart';

class RepeatRide extends StatefulWidget {
  final RideObject ride;

  RepeatRide({Key key, this.ride}) : super(key: key);

  @override
  _RepeatRideState createState() => _RepeatRideState();
}

class _RepeatRideState extends State<RepeatRide> {
  final _formKey = GlobalKey<FormState>();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  TextEditingController sDateCtrl = TextEditingController();
  TextEditingController eDateCtrl = TextEditingController();

  String selectedDays = "";

  String format(String date) {
    var dates = date.split('-');
    String formatDate = dates[1] + "/" + dates[2] + "/" + dates[0];
    return formatDate;
  }

  _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null && picked != startDate)
      setState(() {
        startDate = picked;
        sDateCtrl.text = format("$startDate".split(' ')[0]);
      });
  }

  _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null && picked != endDate)
      setState(() {
        endDate = picked;
        eDateCtrl.text = format("$endDate".split(' ')[0]);
      });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildPickupTimeField() {
    return TextFormField(
      controller: sDateCtrl,
      decoration: InputDecoration(
          labelText: 'Start Date', labelStyle: TextStyle(color: Colors.black)),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your start date';
        }
        return null;
      },
      onTap: () => _selectStartDate(context),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );
  }

  Widget _buildDropOffTimeField() {
    return TextFormField(
      controller: eDateCtrl,
      decoration: InputDecoration(
          labelText: 'End Date', labelStyle: TextStyle(color: Colors.black)),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your end date';
        }
        return null;
      },
      onTap: () => _selectEndDate(context),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );
  }

  final List<bool> isSelected = [false, false, false, false, false];
  final List<String> days = ["M", "T", "W", "Th", "F"];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: InkWell(
                    child: Text("Cancel",
                        style: TextThemes.cancel),
                    onTap: () {
                      Navigator.pop(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => RequestRideTime()));
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
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.repeat),
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
                Flexible(
                    child: Text("When do you want to repeat this ride?",
                        style: TextThemes.question))
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('This ride repeats every:',
                    style: TextThemes.description),
              ],
            ),
            SizedBox(height: 10.0),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ToggleButtons(
                    constraints: BoxConstraints.expand(width: 60, height: 60.0),
                    color: Colors.grey,
                    selectedColor: Colors.black,
                    renderBorder: false,
                    fillColor: Colors.white,
                    splashColor: Colors.white,
                    children: <Widget>[
                      Text('M', style: TextThemes.toggle),
                      Text('T', style: TextThemes.toggle),
                      Text('W', style: TextThemes.toggle),
                      Text('Th', style: TextThemes.toggle),
                      Text('F', style: TextThemes.toggle)
                    ],
                    onPressed: (int index) {
                      setState(() {
                        isSelected[index] = !isSelected[index];
                        selectedDays = setSelectedDays(selectedDays);
                      });
                    },
                    isSelected: isSelected,
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  _buildPickupTimeField(),
                  SizedBox(height: 20.0),
                  _buildDropOffTimeField(),
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
                          if (_formKey.currentState.validate()) {
                            widget.ride.startDate = sDateCtrl.text;
                            widget.ride.endDate = eDateCtrl.text;
                            widget.ride.every = selectedDays;
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewRide(ride: widget.ride)));
                          }
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
      ),
    );
  }
}
