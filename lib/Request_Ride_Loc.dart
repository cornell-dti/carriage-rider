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
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text("Location",
                        style: RideRequestStyles.question(context)),
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
                    child: Text("Set your pickup and dropoff location",
                        style: RideRequestStyles.question(context)),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    LocationInput(
                        ctrl: fromCtrl, label: 'From', ride: widget.ride, finished: false,),
                    SizedBox(height: 30.0),
                    LocationInput(ctrl: toCtrl, label: 'To', ride: widget.ride, finished: true,),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}

class LocationRequestSelection extends StatefulWidget {
  final RideObject ride;
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
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text("Location",
                        style: RideRequestStyles.question(context)),
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
                    child: Text("Where do you want to be picked up? (1/3)",
                        style: RideRequestStyles.question(context)),
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
                      repeatPage: false,
                    ),
                    SizedBox(width: 30.0),
                    SelectionButton(
                      page: widget.page,
                      text: 'Off-Campus',
                      repeatPage: false,
                    )
                  ]),
              FlowBack()
            ],
          ),
        )));
  }
}

class RequestLoc extends StatefulWidget {
  final RideObject ride;
  final TextEditingController ctrl;
  final String label;
  final Widget page;

  RequestLoc({Key key, this.ride, this.ctrl, this.label, this.page})
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
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              FlowCancel(),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text("Location",
                        style: RideRequestStyles.question(context)),
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
                    child: Text("Where do you want to be picked up? (2/3)",
                        style: RideRequestStyles.question(context)),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    LocationField(ctrl: widget.ctrl, label: widget.label),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(children: <Widget>[
                          FlowBackDuo(),
                          SizedBox(width: 50),
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
                              child: Text("Next"),
                            ),
                          ),
                        ]))),
              ),
            ],
          ),
        )));
  }
}

class RequestRideLocConfirm extends StatefulWidget {
  final RideObject ride;

  RequestRideLocConfirm({Key key, this.ride}) : super(key: key);

  @override
  _RequestRideLocConfirmState createState() => _RequestRideLocConfirmState();
}

class _RequestRideLocConfirmState extends State<RequestRideLocConfirm> {
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
                  FlowCancel(),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text("Location",
                            style: RideRequestStyles.question(context)),
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
                        child: Text("Review your pickup and dropoff location",
                            style: RideRequestStyles.question(context)),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        LocationInput(
                            ctrl: fromCtrl, label: 'From', ride: widget.ride, finished: false),
                        SizedBox(height: 30.0),
                        LocationInput(ctrl: toCtrl, label: 'To', ride: widget.ride, finished: true),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(children: <Widget>[
                              FlowBackDuo(),
                              SizedBox(width: 50),
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
                                              builder: (context) => RequestRideTime(ride: widget.ride)));
                                    }
                                  },
                                  elevation: 2.0,
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  child: Text("Set Location"),
                                ),
                              ),
                            ]))),
                  ),
                ],
              ),
            )));
  }
}

class LocationInput extends StatefulWidget {
  final TextEditingController ctrl;
  final RideObject ride;
  final String label;
  final bool finished;

  LocationInput({Key key, this.ctrl, this.ride, this.label, this.finished}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Widget _locationInputField(BuildContext context) {
    return Container(
        child: TextFormField(
      controller: widget.ctrl,
      onTap: () => Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => LocationRequestSelection(
                    ride: widget.ride,
                    page: RequestLoc(
                        ride: widget.ride,
                        ctrl: widget.ctrl,
                        label: widget.label,
                        page: widget.finished ? RequestRideLocConfirm(ride: widget.ride) : RequestRideLoc(ride: widget.ride) ),
                  ))),
      decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never),
      textInputAction: TextInputAction.next,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your current phone number';
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

class LocationField extends StatefulWidget {
  final TextEditingController ctrl;
  final bool filled;
  final String label;
  final Function navigator;

  LocationField({Key key, this.ctrl, this.filled, this.label, this.navigator})
      : super(key: key);

  @override
  _LocationFieldState createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  Widget _locationField(BuildContext context, List<Location> locations) {
    return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: widget.ctrl,
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: widget.label,
                labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
                focusedBorder: OutlineInputBorder())),
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
          widget.ctrl.text = suggestion;
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Please select a location';
          }
          return null;
        },
        onSaved: (value) => widget.ctrl.text = value);
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
            return _locationField(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class SelectionButton extends StatelessWidget {
  final Widget page;
  final String text;
  final bool repeatPage;
  final GestureTapCallback onPressed;

  const SelectionButton(
      {Key key, this.page, this.text, this.repeatPage, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.4,
        height: 50.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context, new MaterialPageRoute(builder: (context) => page));
          },
          elevation: 3.0,
          color: Colors.white,
          textColor: Colors.black,
          child: Text(text,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class FlowCancel extends StatelessWidget {
  const FlowCancel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: InkWell(
            child: Text("Cancel", style: RideRequestStyles.cancel(context)),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ),
      ],
    );
  }
}

class FlowBack extends StatelessWidget {
  const FlowBack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 0.1,
                    height: 50.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 2.0,
                      color: Colors.white,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ))),
    );
  }
}

class FlowBackDuo extends StatelessWidget {
  const FlowBackDuo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width * 0.1,
      height: 50.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        elevation: 2.0,
        color: Colors.white,
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }
}

class TabBarTop extends StatefulWidget {
  final Color colorOne;
  final Color colorTwo;
  final Color colorThree;

  TabBarTop({Key key, this.colorOne, this.colorTwo, this.colorThree})
      : super(key: key);

  @override
  _TabBarTopState createState() => _TabBarTopState();
}

class _TabBarTopState extends State<TabBarTop> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Divider(
                color: widget.colorOne,
                height: 50,
                thickness: 5,
              )),
        ),
        Expanded(
          child: new Container(
              child: Divider(
            color: widget.colorTwo,
            height: 50,
            thickness: 5,
          )),
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: Divider(
                color: widget.colorThree,
                height: 50,
                thickness: 5,
              )),
        ),
      ],
    );
  }
}

class TabBarBot extends StatefulWidget {
  final Color colorOne;
  final Color colorTwo;
  final Color colorThree;

  TabBarBot({Key key, this.colorOne, this.colorTwo, this.colorThree})
      : super(key: key);

  @override
  _TabBarBotState createState() => _TabBarBotState();
}

class _TabBarBotState extends State<TabBarBot> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: new Container(
            transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            margin: const EdgeInsets.only(left: 10.0),
            child: Icon(Icons.location_on_outlined,
                color: widget.colorOne, size: 30),
          ),
        ),
        Expanded(
          child: new Container(
            transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            child: Icon(Icons.web_asset, color: widget.colorTwo, size: 30),
          ),
        ),
        Expanded(
          child: new Container(
            transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            margin: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.check, color: widget.colorThree, size: 30),
          ),
        ),
      ],
    );
  }
}
