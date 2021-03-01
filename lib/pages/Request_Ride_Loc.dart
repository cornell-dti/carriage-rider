import 'package:carriage_rider/pages/Request_Ride_Time.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Home.dart';
import 'package:carriage_rider/models/RideObject.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/utils/TextThemes.dart';

class RequestRideLoc extends StatefulWidget {
  final RideObject ride;

  RequestRideLoc({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideLocState createState() => _RequestRideLocState();
}

class _RequestRideLocState extends State<RequestRideLoc> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fromCtrl = TextEditingController();
  TextEditingController toCtrl = TextEditingController();

  @override
  Widget build(context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      child: Text('Cancel', style: TextThemes.cancelStyle),
                      onTap: () {
                        Navigator.pop(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Home()));
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
                    child: Icon(Icons.location_on),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.brightness_1,
                        color: Colors.grey[350], size: 12.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.brightness_1,
                        color: Colors.grey[350], size: 12.0),
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
                    child: Text('Where do you want to go?',
                        style: TextThemes.title1),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    FromLocation(fromCtrl: fromCtrl),
                    SizedBox(height: 10.0),
                    ToLocation(toCtrl: toCtrl),
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
                        height: 50.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          RequestRideTime(ride: widget.ride)));
                              widget.ride.fromLocation = fromCtrl.text;
                              widget.ride.toLocation = toCtrl.text;
                            }
                          },
                          elevation: 3.0,
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    )),
              )
            ],
          ),
        )));
  }
}

class FromLocation extends StatefulWidget {
  final TextEditingController fromCtrl;

  FromLocation({Key key, this.fromCtrl}) : super(key: key);

  @override
  _FromLocationState createState() => _FromLocationState();
}

class _FromLocationState extends State<FromLocation> {
  Widget _fromField(context, List<Location> locations) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: widget.fromCtrl,
          decoration: InputDecoration(
              labelText: 'From',
              labelStyle: TextStyle(color: Colors.black, fontSize: 15))),
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
        widget.fromCtrl.text = suggestion;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please select a location';
        }
        return null;
      },
      onSaved: (value) => widget.fromCtrl.text = value,
    );
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
            return _fromField(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class ToLocation extends StatefulWidget {
  final TextEditingController toCtrl;

  ToLocation({Key key, this.toCtrl}) : super(key: key);

  @override
  _ToLocationState createState() => _ToLocationState();
}

class _ToLocationState extends State<ToLocation> {
  Widget _toField(context, List<Location> locations) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: widget.toCtrl,
          decoration: InputDecoration(
              labelText: 'To',
              labelStyle: TextStyle(color: Colors.black, fontSize: 15))),
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
        widget.toCtrl.text = suggestion;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please select a location';
        }
        return null;
      },
      onSaved: (value) => widget.toCtrl.text = value,
    );
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
            return _toField(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
