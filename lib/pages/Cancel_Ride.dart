import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/widgets/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../models/Ride.dart';
import 'package:provider/provider.dart';

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

    double buttonHeight = 48;
    double buttonVerticalPadding = 16;
    return Scaffold(
        body: LoadingOverlay(
          color: Colors.white,
          isLoading: requestedCancel,
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: buttonHeight + 2*buttonVerticalPadding + 40),
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
                      SizedBox(height: 16),
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
                    ]),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 34, vertical: buttonVerticalPadding),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 5,
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.11))
                            ]
                        ),
                        child: CButton(
                          text: 'Cancel Ride',
                          height: buttonHeight,
                          onPressed: () async {
                            setState(() {
                              requestedCancel = true;
                            });
                            if (cancelRepeating) {
                              await ridesProvider.cancelRide(context, widget.ride);
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
                        )
                    )
                )
              ],
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              ExcludeSemantics(child: Image.asset('assets/images/cancel_ride_confirmed.png')),
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
