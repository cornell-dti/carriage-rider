import 'package:carriage_rider/Request_Ride_Time.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/Home.dart';
import 'package:carriage_rider/RideObject.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/LocationsProvider.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:provider/provider.dart';

class RideRequestStyles {
  static TextStyle cancel(BuildContext context) {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w100,
      fontSize: 15,
    );
  }

  static TextStyle question(BuildContext context) {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontSize: 25,
    );
  }

  static TextStyle toggle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 15,
    );
  }

  static TextStyle description(BuildContext context) {
    return TextStyle(
        color: Colors.grey, fontWeight: FontWeight.w100, fontSize: 13);
  }

  static TextStyle label(BuildContext context) {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.w300, fontSize: 11);
  }

  static TextStyle info(BuildContext context) {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);
  }
}

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
  Widget build(BuildContext context) {
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
                      child: Text("Cancel",
                          style: RideRequestStyles.cancel(context)),
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
                    child: Text("Where do you want to go?",
                        style: RideRequestStyles.question(context)),
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
                        height: 45.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
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
                          child: Text('Next'),
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
  Widget _fromField(BuildContext context, List<Location> locations) {
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
  Widget build(BuildContext context) {
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    AppConfig appConfig = AppConfig.of(context);

    return FutureBuilder<List<Location>>(
        future: locationsProvider.fetchLocations(appConfig, authProvider),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _fromField(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
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
  Widget _toField(BuildContext context, List<Location> locations) {
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
  Widget build(BuildContext context) {
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    AppConfig appConfig = AppConfig.of(context);

    return FutureBuilder<List<Location>>(
        future: locationsProvider.fetchLocations(appConfig, authProvider),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _toField(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
