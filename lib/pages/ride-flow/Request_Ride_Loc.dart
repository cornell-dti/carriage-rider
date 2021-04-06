import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Request_Ride_Time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
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
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LocationInput(
                      fromCtrl: fromCtrl,
                      label: 'From',
                      ride: widget.ride,
                      finished: isFinished(),
                      isToLocation: false,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                        locationsProvider.checkLocation(fromCtrl.text)
                            ? locationsProvider
                                        .locationByName(fromCtrl.text)
                                        .info ==
                                    null
                                ? ' '
                                : locationsProvider
                                    .locationByName(fromCtrl.text)
                                    .info
                            : ' ',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    SizedBox(height: 30.0),
                    LocationInput(
                      toCtrl: toCtrl,
                      label: 'To',
                      ride: widget.ride,
                      finished: isFinished(),
                      isToLocation: true,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                        locationsProvider.checkLocation(toCtrl.text)
                            ? locationsProvider
                                        .locationByName(toCtrl.text)
                                        .info ==
                                    null
                                ? ' '
                                : locationsProvider
                                    .locationByName(toCtrl.text)
                                    .info
                            : ' ',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              isFinished() ? Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(children: <Widget>[FlowBack()]))),
              ) : Container(),
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
              BackText(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: widget.isToLocation
                        ? Text('Where do you want to be dropped off?',
                            style: CarriageTheme.title1)
                        : Text('Where do you want to be picked up?',
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
                      label: widget.label,
                      page: widget.page,
                    ),
                  ],
                ),
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
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LocationInput(
                      fromCtrl: fromCtrl,
                      label: 'From',
                      ride: widget.ride,
                      finished: isFinished(),
                      isToLocation: false,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                        locationsProvider.checkLocation(fromCtrl.text)
                            ? locationsProvider
                                        .locationByName(fromCtrl.text)
                                        .info ==
                                    null
                                ? ' '
                                : locationsProvider
                                    .locationByName(fromCtrl.text)
                                    .info
                            : ' ',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    SizedBox(height: 30.0),
                    LocationInput(
                        toCtrl: toCtrl,
                        label: 'To',
                        ride: widget.ride,
                        finished: isFinished(),
                        isToLocation: true),
                    SizedBox(height: 10.0),
                    Text(
                        locationsProvider.checkLocation(toCtrl.text)
                            ? locationsProvider
                                        .locationByName(toCtrl.text)
                                        .info ==
                                    null
                                ? ' '
                                : locationsProvider
                                    .locationByName(toCtrl.text)
                                    .info
                            : ' ',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
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
            builder: (context) => RequestLoc(
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
          )),
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
  final Widget page;

  LocationField(
      {Key key, this.ctrl, this.filled, this.label, this.navigator, this.page})
      : super(key: key);

  @override
  Widget build(context) {
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
    return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: ctrl,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: label,
              labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
            )),
        suggestionsCallback: (pattern) {
          return locationsProvider.getSuggestions(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
              title: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Text(suggestion, style: TextStyle(fontSize: 14)),
                Text(locationsProvider.locationByName(suggestion).address,
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Divider(),
              ])));
        },
        noItemsFoundBuilder: (context) => GestureDetector(
              onTap: () => {
                Navigator.push(
                    context, new MaterialPageRoute(builder: (context) => page))
              },
              child: Container(
                  child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ctrl.text,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('Ithaca NY',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          Divider(),
                        ],
                      ))),
            ),
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          ctrl.text = suggestion;
          Navigator.push(
              context, new MaterialPageRoute(builder: (context) => page));
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Please select a location';
          }
          return null;
        },
        onSaved: (value) => ctrl.text = value);
  }
}
