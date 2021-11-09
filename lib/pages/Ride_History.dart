import 'dart:math';
import 'package:carriage_rider/widgets/RideCard.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

class RideHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    List<Ride> pastRides = ridesProvider.pastRides;

    Widget _emptyRideHist() {
      return Row(
        children: <Widget>[
          SizedBox(width: 15),
          Text('You have no ride history!')
        ],
      );
    }

    Widget _mainHist(List<Ride> rides) {
      List<Widget> rideCards = [];
      for (int i = 0; i < rides.length; i++) {
        if (i == 0) {
          rideCards.add(SizedBox(width: 16));
        }
        rideCards.add(Container(
          width: MediaQuery.of(context).size.width * 0.65,
          child: RideCard(rides[i],
              showConfirmation: false, showCallDriver: false, showArrow: false),
        ));
        rideCards.add(SizedBox(width: 16));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: rideCards),
          ),
        ],
      );
    }

    if (pastRides.length == 0) {
      return _emptyRideHist();
    } else {
      return _mainHist(pastRides.sublist(0, min(5, pastRides.length)));
    }
  }
}

class HistorySeeMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider =
        Provider.of<RidesProvider>(context, listen: false);
    List<Ride> pastRides = ridesProvider.pastRides;

    return Scaffold(
        appBar: ScheduleBar(
            Colors.black, Theme.of(context).scaffoldBackgroundColor),
        body: SafeArea(
            child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              child: Semantics(
                  header: true,
                  child: Text('Ride History', style: CarriageTheme.largeTitle)),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: pastRides.length,
                      itemBuilder: (context, index) {
                        return RideCard(
                          pastRides[index],
                          showConfirmation: false,
                          showCallDriver: false,
                          showArrow: true,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                    )),
              ),
            )
          ]),
        )));
  }
}
