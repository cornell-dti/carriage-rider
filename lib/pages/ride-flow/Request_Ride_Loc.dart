import 'dart:math';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Request_Ride_Time.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';


class RequestRideLoc extends StatefulWidget {
  final Ride ride;

  RequestRideLoc({Key key, @required this.ride}) : super(key: key);

  @override
  _RequestRideLocState createState() => _RequestRideLocState();
}

class _RequestRideLocState extends State<RequestRideLoc> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    TextEditingController fromCtrl = rideFlowProvider.fromCtrl;
    TextEditingController toCtrl = rideFlowProvider.toCtrl;

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
                        child: Text((rideFlowProvider.locationsFinished() ? 'Review your ' : 'Set your ') + 'pickup and dropoff location',
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
                          finished: rideFlowProvider.locationsFinished(),
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
                          finished: rideFlowProvider.locationsFinished(),
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
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: rideFlowProvider.locationsFinished() ? Row(
                                children: <Widget>[
                                  FlowBackDuo(),
                                  SizedBox(width: 50),
                                  ButtonTheme(
                                    minWidth: MediaQuery.of(context).size.width * 0.65,
                                    height: 50.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Expanded(
                                        child: RaisedButton(
                                            onPressed: () {
                                              if (_formKey.currentState.validate()) {
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => rideFlowProvider.editing ? RequestRideDateTime(ride: widget.ride) : RequestRideType(ride: widget.ride)
                                                )
                                                );
                                                widget.ride.startLocation = fromCtrl.text;
                                                widget.ride.endLocation = toCtrl.text;
                                              }
                                            },
                                            elevation: 2.0,
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text('Set Location',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold)
                                            )
                                        )
                                    ),
                                  ),
                                ]) : Row(
                                children: [FlowBack()]
                            )
                        )
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}

class RequestLoc extends StatefulWidget {
  final Ride ride;
  final bool isToLocation;
  final String label;
  final Widget page;
  final List<String> initSuggestions;

  RequestLoc(
      {Key key,
        this.ride,
        this.isToLocation,
        this.label,
        this.page,
        this.initSuggestions})
      : super(key: key);

  @override
  _RequestLocState createState() => _RequestLocState();
}

class _RequestLocState extends State<RequestLoc> {
  List<String> suggestions;

  @override
  void initState() {
    super.initState();
    suggestions = widget.initSuggestions;
  }

  @override
  Widget build(BuildContext context) {
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    TextEditingController fromCtrl = rideFlowProvider.fromCtrl;
    TextEditingController toCtrl = rideFlowProvider.toCtrl;
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    List<String> locationNames = locationsProvider.favLocations.map((loc) => loc.name).toList();

    Widget customLocationOption = GestureDetector(
      onTap: () => {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => widget.page))
      },
      child: Container(
          child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.isToLocation ? toCtrl.text : fromCtrl.text,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold
                      )
                  ),
                  Text('Ithaca, NY 14850',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12
                      )
                  ),
                  Divider(),
                ],
              )
          )
      ),
    );

    ListView suggestionList = ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        bool isFavorite = locationNames.contains(suggestions[index]);
        return GestureDetector(
            onTap: () {
              if (widget.isToLocation) {
                toCtrl.text = suggestions[index];
              }
              else {
                fromCtrl.text = suggestions[index];
              }
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => widget.page)
              );
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Text(suggestions[index], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(locationsProvider.locationByName(suggestions[index]).address,
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                            SizedBox(height: 12),
                          ],
                        ),
                        isFavorite ? Spacer() : Container(),
                        isFavorite ? Icon(Icons.star, size: 16) : Container()
                      ]
                  ),
                  Divider(),
                ]
            )
        );
      },
    );

    return Scaffold(
        resizeToAvoidBottomInset: true,
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
                LocationField(
                  ctrl: widget.isToLocation ? toCtrl : fromCtrl,
                  label: widget.label,
                  page: widget.page,
                  updateSuggestions: (input) {
                    setState(() {
                      suggestions = locationsProvider.getSuggestions(input);
                    });
                  },
                ),
                SizedBox(height: 24),
                suggestions.isEmpty ? customLocationOption : Expanded(child: suggestionList)
              ],
            ),
          ),
        )
    );
  }
}

class RequestRideLocConfirm extends StatefulWidget {
  final Ride ride;

  RequestRideLocConfirm({Key key, this.ride})
      : super(key: key);

  @override
  _RequestRideLocConfirmState createState() => _RequestRideLocConfirmState();
}

class _RequestRideLocConfirmState extends State<RequestRideLocConfirm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    TextEditingController fromCtrl = rideFlowProvider.fromCtrl;
    TextEditingController toCtrl = rideFlowProvider.toCtrl;

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
                          finished: rideFlowProvider.locationsFinished(),
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
                            finished: rideFlowProvider.locationsFinished(),
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
                                minWidth: MediaQuery.of(context).size.width * 0.65,
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
                                                        RequestRideType(
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
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);

    List<String> initSuggestions;
    if (locationsProvider.hasLocations() && locationsProvider.hasFavLocations()) {
      initSuggestions = [];
      List<String> favLocations = locationsProvider.favLocations
          .map((loc) => loc.name)
          .toList();
      initSuggestions.addAll(favLocations);
      print(favLocations);

      if (initSuggestions.length < 5) {
        List<Ride> pastRides = ridesProvider.pastRides;
        List<String> pastLocations = pastRides
            .sublist(0, min(5 - initSuggestions.length + 1, pastRides.length))
            .map((ride) => isToLocation ? ride.endLocation : ride.startLocation)
            .where((loc) => !initSuggestions.contains(loc))
            .toList();
        print(pastLocations);
        initSuggestions.addAll(pastLocations);
      }

      if (initSuggestions.length < 5) {
        List<String> locations = locationsProvider.locations.map((loc) => loc.name).toList()..sort();
        List<String> alphabeticalLocations = locations
            .sublist(0, min(5 - initSuggestions.length + 1, locations.length))
            .where((loc) => !initSuggestions.contains(loc))
            .toList();
        initSuggestions.addAll(alphabeticalLocations);
        print(alphabeticalLocations);
      }
    }

    bool screenReader = MediaQuery.of(context).accessibleNavigation;

    void onTap () => Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => RequestLoc(
              ride: ride,
              label: label,
              isToLocation: isToLocation,
              page: RequestRideLoc(ride: ride),
              initSuggestions: initSuggestions
          ),
        )
    );

    Widget textField = TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      enableInteractiveSelection: false,
      onTap: onTap,
      controller: isToLocation ? toCtrl : fromCtrl,
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
    );

    return screenReader ? Semantics(
      label: isToLocation ? (toCtrl.text != null && toCtrl.text != '' ? 'Selected drop off location: ${toCtrl.text}' : 'Select drop off location') :
      (fromCtrl.text != null && fromCtrl.text != '' ? 'Selected pick up location: ${fromCtrl.text}' : 'Select pick up location'),
      focusable: true,
      onTap: onTap,
      child: IgnorePointer(
          child: textField
      ),
    ) : textField;
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
  final Function updateSuggestions;

  LocationField(
      {Key key, this.ctrl, this.filled, this.label, this.navigator, this.page, this.updateSuggestions})
      : super(key: key);

  @override
  Widget build(context) {
    return TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
        ),
        onChanged: (input) {
          updateSuggestions(input);
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
