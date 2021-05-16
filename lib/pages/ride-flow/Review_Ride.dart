import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/pages/ride-flow/Ride_Confirmation.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:carriage_rider/widgets/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/pages/ride-flow/FlowWidgets.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

class ReviewRide extends StatefulWidget {
  final Ride ride;

  ReviewRide({Key key, this.ride}) : super(key: key);

  @override
  _ReviewRideState createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {
  bool requestLoading = false;
  
  @override
  Widget build(context) {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);

    double buttonsHeight = 48;
    double buttonsVerticalPadding = 16;

    return Scaffold(
      body: LoadingOverlay(
        color: Colors.white,
        isLoading: requestLoading,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 20.0, right: 20.0, bottom: buttonsHeight + 2*buttonsVerticalPadding + 40),
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
                      widget.ride.buildSummary(context),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: buttonsVerticalPadding),
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
                  child: Row(
                      children: [
                        BackArrowButton(buttonsHeight),
                        SizedBox(width: 24),
                        Expanded(
                          child: CButton(
                            text: rideFlowProvider.editing ? 'Update Request' : 'Send Request',
                            height: buttonsHeight,
                            onPressed: () async {
                              setState(() {
                                requestLoading = true;
                              });
                              String startLoc = locationsProvider.isPreset(widget.ride.startLocation) ? locationsProvider.locationByName(widget.ride.startLocation).id : widget.ride.startLocation;
                              String endLoc = locationsProvider.isPreset(widget.ride.endLocation) ? locationsProvider.locationByName(widget.ride.endLocation).id : widget.ride.endLocation;
                              bool successfulRequest;
                              if (rideFlowProvider.editing) {
                                // fake instance for recurring ride
                                if (widget.ride.parentRide != null) {
                                  successfulRequest = await rideFlowProvider.updateRecurringRide(
                                      AppConfig.of(context),
                                      context,
                                      widget.ride.parentRide.id,
                                      widget.ride.origDate,
                                      startLoc,
                                      endLoc,
                                      widget.ride.startTime,
                                      widget.ride.endTime,
                                      widget.ride.recurring,
                                      recurringDays: widget.ride.recurringDays,
                                      endDate: widget.ride.endDate
                                  );
                                }
                                // real instance
                                else {
                                  successfulRequest = await rideFlowProvider.updateRide(
                                      AppConfig.of(context),
                                      context,
                                      widget.ride.id,
                                      startLoc,
                                      endLoc,
                                      widget.ride.startTime,
                                      widget.ride.endTime,
                                      widget.ride.recurring,
                                      recurringDays: widget.ride.recurringDays,
                                      endDate: widget.ride.endDate
                                  );
                                }
                              }
                              else {
                                successfulRequest = await rideFlowProvider.createRide(
                                    AppConfig.of(context),
                                    context,
                                    startLoc,
                                    endLoc,
                                    widget.ride.startTime,
                                    widget.ride.endTime,
                                    widget.ride.recurring,
                                    recurringDays: widget.ride.recurringDays,
                                    endDate: widget.ride.endDate
                                );
                              }
                              if (successfulRequest) {
                                rideFlowProvider.clearControllers();
                                rideFlowProvider.setError(false);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => RideConfirmation()
                                ));
                              }
                              else {
                                rideFlowProvider.setError(true);
                                SemanticsService.announce('An error occurred, please enter valid locations.', TextDirection.ltr);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        )
                      ]
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
