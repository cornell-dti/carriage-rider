import 'package:carriage_rider/Request_Ride_Time.dart';
import 'package:carriage_rider/Review_Ride.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/Ride.dart';

class RepeatRide extends StatefulWidget {
  final Ride ride;

  RepeatRide({Key key, this.ride}) : super(key: key);

  @override
  _RepeatRideState createState() => _RepeatRideState();
}

class _RepeatRideState extends State<RepeatRide> {
  final _formKey = GlobalKey<FormState>();

  TimeOfDay _pickUpTime = TimeOfDay.now();
  TimeOfDay _dropOffTime = TimeOfDay.now();

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

  final descriptionStyle =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w100, fontSize: 13);

  Widget _buildPickupTimeField() {
    return TextFormField(
      initialValue: widget.ride.pickUpTime,
      controller: pickUpCtrl,
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

  Widget _buildDropOffTimeField() {
    return TextFormField(
      initialValue: widget.ride.dropOffTime,
      controller: dropOffCtrl,
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

  final List<bool> isSelected = [false, false, false, false, false];
  final List<String> days = ["M", "T", "W", "Th", "F"];

  String selectedDays = "";

  void setSelectedDays(String sDays) {
    sDays = "";

    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        sDays += days[i] + " ";
      }
    }
    sDays = sDays.substring(0, sDays.length - 1);
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
                    child: Text("Cancel", style: cancelStyle),
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
                        style: questionStyle))
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('This ride repeats every:', style: descriptionStyle),
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
                      Text('M', style: toggleStyle),
                      Text('T', style: toggleStyle),
                      Text('W', style: toggleStyle),
                      Text('Th', style: toggleStyle),
                      Text('F', style: toggleStyle)
                    ],
                    onPressed: (int index) {
                      setState(() {
                        isSelected[index] = !isSelected[index];
                      });
                      setSelectedDays(selectedDays);
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
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewRide(ride: widget.ride)));
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
