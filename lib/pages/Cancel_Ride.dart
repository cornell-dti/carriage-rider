import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../utils/app_config.dart';
import '../models/Ride.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';

class CancelRidePage extends StatefulWidget {
  CancelRidePage(this.ride);

  final Ride ride;

  @override
  _CancelRidePageState createState() => _CancelRidePageState();
}

class _CancelRidePageState extends State<CancelRidePage> {
  bool cancelRepeating;
  bool requestedCancel;

  @override
  void initState() {
    super.initState();
    setState(() {
      cancelRepeating = false;
      requestedCancel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);

    return Scaffold(
        body: LoadingOverlay(
          color: Colors.white,
          isLoading: requestedCancel,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                BackText(),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text('Cancel your ride', style: CarriageTheme.title1),
                    )
                  ],
                ),
                TabBarTop(
                    colorOne: Colors.black,
                    colorTwo: Colors.black,
                    colorThree: Colors.black),
                TabBarBot(
                    colorOne: Colors.green,
                    colorTwo: Colors.green,
                    colorThree: Colors.black),
                SizedBox(height: 30),
                widget.ride.buildSummary(context),
                SizedBox(height: 32),
                widget.ride.parentRide != null ? CheckboxListTile(
                    activeColor: CarriageTheme.gray2,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: cancelRepeating,
                    onChanged: (bool newValue) {
                      setState(() {
                        cancelRepeating = newValue;
                      });
                    },
                    title: Text('Cancel all repeating rides',
                        style: TextStyle(
                            fontSize: 18,
                            color: CarriageTheme.gray2,
                            fontWeight: FontWeight.normal))
                ) : Container(),
                Spacer(),
                Center(
                  child: ButtonTheme(
                    minWidth:
                    MediaQuery.of(context).size.width * 0.8,
                    height: 50.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: RaisedButton(
                      onPressed: () async {
                        setState(() {
                          requestedCancel = true;
                        });
                        if (cancelRepeating) {
                          await ridesProvider.cancelRide(context, widget.ride.parentRide);
                        }
                        else {
                          if (widget.ride.parentRide != null) {
                            await ridesProvider.cancelRepeatingRideOccurrence(context, widget.ride);
                          }
                          else {
                            await ridesProvider.cancelRide(context, widget.ride);
                          }
                        }

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => CancelConfirmation())
                        );
                      },
                      elevation: 3.0,
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('Cancel Ride', style: CarriageTheme.button),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}

class CancelConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
              SizedBox(height: 176),
              Image.asset('assets/images/cancel_ride_confirmed.png'),
              SizedBox(height: 32),
              Center(
                  child: Text('Your ride is cancelled!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(34),
                child: Container(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Done',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () async {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                ),
              )
            ])));
  }
}
