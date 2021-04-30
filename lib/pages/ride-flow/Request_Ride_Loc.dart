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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  rideFlowProvider.requestHadError ? Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Invalid location(s), please try again.', style: TextStyle(color: Colors.red, fontSize: 16)),
                  ) : Container(),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LocationInput(
                          label: 'From',
                          ride: widget.ride,
                          finished: rideFlowProvider.locationsFinished(),
                          isToLocation: false,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                            locationsProvider.isPreset(fromCtrl.text)
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
                          label: 'To',
                          ride: widget.ride,
                          finished: rideFlowProvider.locationsFinished(),
                          isToLocation: true,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                            locationsProvider.isPreset(toCtrl.text)
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
                                //FlowBackDuo(),
                                //SizedBox(width: 50),
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
                              ]) : Container(),
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

class SelectLocationPage extends StatefulWidget {
  final Ride ride;
  final bool isToLocation;
  final String label;
  final Widget page;
  final List<String> initSuggestions;

  SelectLocationPage(
      {Key key,
        this.ride,
        this.isToLocation,
        this.label,
        this.page,
        this.initSuggestions})
      : super(key: key);

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
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

    Widget customLocationOption = Column(
        children: [
          InkWell(
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => widget.page
            )),
            child: Container(
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
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
                      ],
                    )
                )
            ),
          ),
          Divider()
        ]
    );

    ListView suggestionList = ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Container(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(suggestions[index], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(locationsProvider.isPreset(suggestions[index]) ? locationsProvider.addressByName(suggestions[index]) : suggestions[index] + ', Ithaca, NY 14850',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 12),
                    ]
                ),
              ),
              onTap: () {
                if (widget.isToLocation) {
                  toCtrl.text = suggestions[index];
                }
                else {
                  fromCtrl.text = suggestions[index];
                }
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => widget.page
                ));
              },
            ),
            Divider()
          ],
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

class LocationInput extends StatelessWidget {
  final Ride ride;
  final String label;
  final bool finished;
  final bool isToLocation;

  LocationInput(
      {Key key,
        this.ride,
        this.label,
        this.finished,
        this.isToLocation})
      : super(key: key);

  Widget _locationInputField(BuildContext context) {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    TextEditingController fromCtrl = rideFlowProvider.fromCtrl;
    TextEditingController toCtrl = rideFlowProvider.toCtrl;

    List<String> initSuggestions;
    if (isToLocation && toCtrl.text != null && toCtrl.text != '') {
      initSuggestions = locationsProvider.getSuggestions(toCtrl.text);
    }
    else if (!isToLocation && fromCtrl.text != null && fromCtrl.text != '') {
      initSuggestions = locationsProvider.getSuggestions(fromCtrl.text);
    }
    else {
      initSuggestions = [];
      if (initSuggestions.length < 5) {
        List<Ride> pastRides = ridesProvider.pastRides;
        List<String> pastLocations = pastRides
            .map((ride) => isToLocation ? ride.endLocation : ride.startLocation)
            .where((loc) => !initSuggestions.contains(loc))
            .toSet()
            .toList();
        List<String> suggestedPastLocations = pastLocations.sublist(0, min(5 - initSuggestions.length, pastLocations.length));
        initSuggestions.addAll(suggestedPastLocations);
      }
      if (initSuggestions.length < 5) {
        List<String> locations = locationsProvider.locations.map((loc) => loc.name).toList()..sort();
        List<String> alphabeticalLocations = locations
            .where((loc) => !initSuggestions.contains(loc))
            .toList();
        List<String> suggestedAlphabeticalLocations = alphabeticalLocations.sublist(0, min(5 - initSuggestions.length, alphabeticalLocations.length));
        initSuggestions.addAll(suggestedAlphabeticalLocations);
      }
    }

    bool screenReader = MediaQuery.of(context).accessibleNavigation;

    void onTap () {
      rideFlowProvider.setError(false);
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => SelectLocationPage(
                ride: ride,
                label: label,
                isToLocation: isToLocation,
                page: RequestRideLoc(ride: ride),
                initSuggestions: initSuggestions
            ),
          )
      );
    }

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
