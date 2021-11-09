import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Ride_Confirmation.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/widgets/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

class ReviewRide extends StatefulWidget {
  ReviewRide({Key key}) : super(key: key);

  @override
  _ReviewRideState createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {
  bool requestLoading = false;

  @override
  Widget build(context) {
    RideFlowProvider rideFlowProvider =
        Provider.of<RideFlowProvider>(context, listen: false);

    double buttonsHeight = 48;
    double buttonsVerticalPadding = 16;

    Ride ride = rideFlowProvider.assembleRide(context);

    return Scaffold(
      body: LoadingOverlay(
        color: Colors.white,
        isLoading: requestLoading,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      top: 24,
                      left: 20.0,
                      right: 20.0,
                      bottom: buttonsHeight + 2 * buttonsVerticalPadding + 40),
                  child: Column(
                    children: <Widget>[
                      FlowCancel(),
                      SizedBox(height: 20.0),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text("Review", style: CarriageTheme.title1),
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
                      ride.buildSummary(
                          context,
                          (rideFlowProvider.creating() &&
                                  rideFlowProvider.recurring) ||
                              rideFlowProvider.editingAll()),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: buttonsVerticalPadding),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 11,
                        color: Colors.black.withOpacity(0.11))
                  ]),
                  child: Row(children: [
                    BackArrowButton(buttonsHeight),
                    SizedBox(width: 24),
                    Expanded(
                      child: CButton(
                        text: rideFlowProvider.creating()
                            ? 'Send Request'
                            : 'Update Request',
                        height: buttonsHeight,
                        onPressed: () async {
                          setState(() {
                            requestLoading = true;
                          });
                          bool successfulRequest =
                              await rideFlowProvider.request(context);
                          if (successfulRequest) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RideConfirmation()));
                            rideFlowProvider.clear();
                          } else {
                            rideFlowProvider.setError(true);
                            SemanticsService.announce(
                                'An error occurred, please enter valid locations.',
                                TextDirection.ltr);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
