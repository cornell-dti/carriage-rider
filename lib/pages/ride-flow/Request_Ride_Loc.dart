import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Request_Ride_Time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:carriage_rider/models/Location.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';

class RequestRideLoc extends StatefulWidget {
  final Ride ride;

  RequestRideLoc({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideLocState createState() => _RequestRideLocState();
}

class _RequestRideLocState extends State<RequestRideLoc> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
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
                    child: Text('Location', style: CarriageTheme.title1),
                  )
                ],
              ),
              TabBarTop(
                  colorOne: Colors.black,
                  colorTwo: Colors.grey[350],
                  colorThree: Colors.grey[350]),
              TabBarBot(
                  colorOne: Colors.black,
                  colorTwo: Colors.grey[350],
                  colorThree: Colors.grey[350]),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Set your pickup and dropoff location',
                        style: CarriageTheme.title1),
                  )
                ],
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    LocationInput(
                      fromCtrl: fromCtrl,
                      label: 'From',
                      ride: widget.ride,
                      finished: false,
                      isToLocation: false,
                    ),
                    SizedBox(height: 30.0),
                    LocationInput(
                      toCtrl: toCtrl,
                      label: 'To',
                      ride: widget.ride,
                      finished: true,
                      isToLocation: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}

class LocationRequestSelection extends StatefulWidget {
  final Ride ride;
  final Widget page;

  LocationRequestSelection({Key key, this.ride, this.page}) : super(key: key);

  @override
  _LocationRequestSelectionState createState() =>
      _LocationRequestSelectionState();
}

class _LocationRequestSelectionState extends State<LocationRequestSelection> {
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
                    child: Text('Location', style: CarriageTheme.title1),
                  )
                ],
              ),
              TabBarTop(
                  colorOne: Colors.black,
                  colorTwo: Colors.grey[350],
                  colorThree: Colors.grey[350]),
              TabBarBot(
                  colorOne: Colors.black,
                  colorTwo: Colors.grey[350],
                  colorThree: Colors.grey[350]),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Where do you want to be picked up? (1/3)',
                        style: CarriageTheme.title1),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SelectionButton(
                      page: widget.page,
                      text: 'Campus',
                    ),
                    SizedBox(width: 30.0),
                    SelectionButton(
                      page: widget.page,
                      text: 'Off-Campus',
                    )
                  ]),
              FlowBack()
            ],
          ),
        )));
  }
}

class RequestLoc extends StatefulWidget {
  final Ride ride;
  final TextEditingController fromCtrl;
  final TextEditingController toCtrl;
  final bool isToLocation;
  final String label;
  final Widget page;

  RequestLoc(
      {Key key,
      this.ride,
      this.fromCtrl,
      this.toCtrl,
      this.isToLocation,
      this.label,
      this.page})
      : super(key: key);

  @override
  _RequestLocState createState() => _RequestLocState();
}

class _RequestLocState extends State<RequestLoc> {
  final _formKey = GlobalKey<FormState>();

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
                    child: Text('Location', style: CarriageTheme.title1),
                  )
                ],
              ),
              TabBarTop(
                  colorOne: Colors.black,
                  colorTwo: Colors.grey[350],
                  colorThree: Colors.grey[350]),
              TabBarBot(
                  colorOne: Colors.black,
                  colorTwo: Colors.grey[350],
                  colorThree: Colors.grey[350]),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Where do you want to be picked up? (2/3)',
                        style: CarriageTheme.title1),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    LocationField(
                        ctrl: widget.isToLocation ? toCtrl : fromCtrl,
                        label: widget.label),
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
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.6,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => widget.page));
                                  }
                                },
                                elevation: 2.0,
                                color: Colors.black,
                                textColor: Colors.white,
                                child: Text(
                                  'Next',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ]))),
              ),
            ],
          ),
        )));
  }
}

class RequestRideLocConfirm extends StatefulWidget {
  final TextEditingController fromCtrl;
  final TextEditingController toCtrl;
  final Ride ride;

  RequestRideLocConfirm({Key key, this.ride, this.fromCtrl, this.toCtrl})
      : super(key: key);

  @override
  _RequestRideLocConfirmState createState() => _RequestRideLocConfirmState();
}

class _RequestRideLocConfirmState extends State<RequestRideLocConfirm> {
  final _formKey = GlobalKey<FormState>();

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
                    child: Text('Location', style: CarriageTheme.title1),
                  )
                ],
              ),
              TabBarTop(
                  colorOne: Colors.black,
                  colorTwo: Colors.grey[350],
                  colorThree: Colors.grey[350]),
              TabBarBot(
                  colorOne: Colors.black,
                  colorTwo: Colors.grey[350],
                  colorThree: Colors.grey[350]),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Review your pickup and dropoff location',
                        style: CarriageTheme.title1),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    LocationInput(
                      fromCtrl: fromCtrl,
                      label: 'From',
                      ride: widget.ride,
                      finished: false,
                      isToLocation: false,
                    ),
                    SizedBox(height: 30.0),
                    LocationInput(
                        toCtrl: toCtrl,
                        label: 'To',
                        ride: widget.ride,
                        finished: true,
                        isToLocation: true),
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
                          SizedBox(width: 50),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.6,
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
                                                    RequestRideTime(
                                                        ride: widget.ride)));
                                        widget.ride.startLocation =
                                            fromCtrl.text;
                                        widget.ride.endLocation = toCtrl.text;
                                      }
                                    },
                                    elevation: 2.0,
                                    color: Colors.black,
                                    textColor: Colors.white,
                                    child: Text('Set Location',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                          ),
                        ]))),
              ),
            ],
          ),
        )));
  }
}

class LocationInput extends StatelessWidget {
  final TextEditingController fromCtrl;
  final TextEditingController toCtrl;
  final Ride ride;
  final String label;
  final bool finished;
  final bool isToLocation;

  LocationInput(
      {Key key,
      this.fromCtrl,
      this.toCtrl,
      this.ride,
      this.label,
      this.finished,
      this.isToLocation})
      : super(key: key);

  Widget _locationInputField(BuildContext context) {
    return Container(
        child: TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      controller: isToLocation ? toCtrl : fromCtrl,
      onTap: () => Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => LocationRequestSelection(
                    ride: ride,
                    page: RequestLoc(
                        ride: ride,
                        fromCtrl: fromCtrl,
                        toCtrl: toCtrl,
                        label: label,
                        isToLocation: isToLocation,
                        page: finished
                            ? RequestRideLocConfirm(
                                ride: ride,
                                fromCtrl: fromCtrl,
                                toCtrl: toCtrl,
                              )
                            : RequestRideLoc(ride: ride)),
                  ))),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never),
      textInputAction: TextInputAction.next,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your location';
        }
        return null;
      },
      style: TextStyle(color: Colors.black, fontSize: 17),
      onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _locationInputField(context);
  }
}

class LocationField extends StatelessWidget {
  final TextEditingController ctrl;
  final bool filled;
  final String label;
  final Function navigator;

  LocationField({Key key, this.ctrl, this.filled, this.label, this.navigator})
      : super(key: key);

  Widget _locationField(BuildContext context, List<Location> locations) {
    return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: ctrl,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: label,
              labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
            )),
        suggestionsCallback: (pattern) {
          return LocationsProvider.getSuggestions(pattern, locations);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          ctrl.text = suggestion;
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Please select a location';
          }
          return null;
        },
        onSaved: (value) => ctrl.text = value);
  }

  @override
  Widget build(context) {
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    AppConfig appConfig = AppConfig.of(context);

    return FutureBuilder<List<Location>>(
        future:
            locationsProvider.fetchLocations(context, appConfig, authProvider),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _locationField(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
