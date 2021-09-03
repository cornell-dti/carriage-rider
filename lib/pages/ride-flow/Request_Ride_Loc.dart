import 'dart:math';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Request_Ride_Time.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/widgets/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';

class RequestRideLoc extends StatefulWidget {
  RequestRideLoc({Key key}) : super(key: key);

  @override
  _RequestRideLocState createState() => _RequestRideLocState();
}

class _RequestRideLocState extends State<RequestRideLoc> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    TextEditingController fromCtrl = rideFlowProvider.startLocCtrl;
    TextEditingController toCtrl = rideFlowProvider.endLocCtrl;

    double buttonHeight = 48;
    double buttonVerticalPadding = 16;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    top: 24,
                    left: 20.0,
                    right: 20.0,
                    bottom: buttonHeight + 2 * buttonVerticalPadding + 40),
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
                          child: Text(
                              (rideFlowProvider.locationsFinished()
                                      ? 'Review your '
                                      : 'Set your ') +
                                  'pickup and dropoff location',
                              style: CarriageTheme.title1),
                        )
                      ],
                    ),
                    rideFlowProvider.requestHadError
                        ? Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                                'Invalid location(s), please try again.',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16)),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LocationInput(
                            label: 'From',
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
                                      ? ''
                                      : locationsProvider
                                          .locationByName(fromCtrl.text)
                                          .info
                                  : '',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          SizedBox(height: 30.0),
                          LocationInput(
                            label: 'To',
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
                                      ? ''
                                      : locationsProvider
                                          .locationByName(toCtrl.text)
                                          .info
                                  : '',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 34, vertical: buttonVerticalPadding),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 11,
                        color: Colors.black.withOpacity(0.11))
                  ]),
                  child: CButton(
                    text: 'Set Location',
                    height: buttonHeight,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    (rideFlowProvider.creating())
                                        ? RequestRideType()
                                        : RequestRideDateTime()));
                      } else {
                        SemanticsService.announce(
                            'Error, please check your locations',
                            TextDirection.ltr);
                      }
                    },
                  )),
            )
          ],
        )));
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
    TextEditingController fromCtrl = rideFlowProvider.startLocCtrl;
    TextEditingController toCtrl = rideFlowProvider.endLocCtrl;
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);

    String input = widget.isToLocation ? toCtrl.text : fromCtrl.text;
    String ithaca = 'Ithaca, NY 14850';

    Widget customLocationOption = Column(children: [
      InkWell(
        onTap: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => widget.page)),
        child: Semantics(
          label: input + ', ' + ithaca,
          child: Container(
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(input,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(ithaca,
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ))),
        ),
      ),
      Divider()
    ]);

    ListView suggestionList = ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        String name = suggestions[index];
        String address = locationsProvider.isPreset(suggestions[index])
            ? locationsProvider.addressByName(suggestions[index])
            : 'Ithaca, NY 14850';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Container(
                width: double.infinity,
                child: Semantics(
                  label: name + ', ' + address,
                  child: ExcludeSemantics(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(name,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          !locationsProvider.isPreset(suggestions[index])
                              ? Text(address,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12))
                              : Container(),
                          SizedBox(height: 16),
                        ]),
                  ),
                ),
              ),
              onTap: () {
                if (widget.isToLocation) {
                  toCtrl.text = suggestions[index];
                } else {
                  fromCtrl.text = suggestions[index];
                }
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => widget.page));
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
            margin: EdgeInsets.only(top: 24, left: 20.0, right: 20.0),
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
                suggestions.isEmpty
                    ? customLocationOption
                    : Expanded(child: suggestionList)
              ],
            ),
          ),
        ));
  }
}

class LocationInput extends StatelessWidget {
  final Ride ride;
  final String label;
  final bool finished;
  final bool isToLocation;

  LocationInput(
      {Key key, this.ride, this.label, this.finished, this.isToLocation})
      : super(key: key);

  Widget _locationInputField(BuildContext context) {
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    TextEditingController fromCtrl = rideFlowProvider.startLocCtrl;
    TextEditingController toCtrl = rideFlowProvider.endLocCtrl;

    List<String> initSuggestions;
    if (isToLocation && toCtrl.text != null && toCtrl.text != '') {
      initSuggestions = locationsProvider.getSuggestions(toCtrl.text);
    } else if (!isToLocation && fromCtrl.text != null && fromCtrl.text != '') {
      initSuggestions = locationsProvider.getSuggestions(fromCtrl.text);
    } else {
      initSuggestions = [];
      if (initSuggestions.length < 5) {
        List<Ride> pastRides = ridesProvider.pastRides;
        List<String> pastLocations = pastRides
            .map((ride) => isToLocation ? ride.endLocation : ride.startLocation)
            .where((loc) => !initSuggestions.contains(loc))
            .toSet()
            .toList();
        List<String> suggestedPastLocations = pastLocations.sublist(
            0, min(5 - initSuggestions.length, pastLocations.length));
        initSuggestions.addAll(suggestedPastLocations);
      }
      if (initSuggestions.length < 5) {
        List<String> locations =
            locationsProvider.locations.map((loc) => loc.name).toList()..sort();
        List<String> alphabeticalLocations =
            locations.where((loc) => !initSuggestions.contains(loc)).toList();
        List<String> suggestedAlphabeticalLocations =
            alphabeticalLocations.sublist(0,
                min(5 - initSuggestions.length, alphabeticalLocations.length));
        initSuggestions.addAll(suggestedAlphabeticalLocations);
      }
    }

    String semanticsLabel = isToLocation
        ? (toCtrl.text != null && toCtrl.text != ''
            ? 'Selected drop off location: ${toCtrl.text}'
            : 'Select drop off location')
        : (fromCtrl.text != null && fromCtrl.text != ''
            ? 'Selected pick up location: ${fromCtrl.text}'
            : 'Select pick up location');

    void onTap() {
      rideFlowProvider.setError(false);
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => SelectLocationPage(
                ride: ride,
                label: label,
                isToLocation: isToLocation,
                page: RequestRideLoc(),
                initSuggestions: initSuggestions),
          ));
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
          return 'Please enter your ' +
              (isToLocation ? 'drop off' : 'pick up') +
              ' location';
        }
        return null;
      },
      style: TextStyle(color: Colors.black, fontSize: 17),
      onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
    );

    return Semantics(
        label: semanticsLabel,
        focusable: true,
        onTap: onTap,
        button: true,
        child: ExcludeSemantics(child: textField));
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
      {Key key,
      this.ctrl,
      this.filled,
      this.label,
      this.navigator,
      this.page,
      this.updateSuggestions})
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
