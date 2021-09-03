import 'dart:math';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/widgets/RideCard.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingRides extends StatelessWidget {
  Widget _emptyUpcomingRides(context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 15),
        Text('You have no upcoming rides!')
      ],
    );
  }

  Widget _mainUpcoming(context, List<Ride> rides) {
    List<Widget> rideCards = [];
    for (int i = 0; i < rides.length; i++) {
      if (i == 0) {
        rideCards.add(SizedBox(width: 16));
      }
      rideCards.add(Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: RideCard(rides[i],
            showConfirmation: true, showCallDriver: false, showArrow: false),
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

  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    List<Ride> upcomingRides = ridesProvider.upcomingRides;

    if (!ridesProvider.hasData()) {
      return Center(child: CircularProgressIndicator());
    } else if (upcomingRides.length == 0) {
      return _emptyUpcomingRides(context);
    } else {
      return _mainUpcoming(
          context, upcomingRides.sublist(0, min(5, upcomingRides.length)));
    }
  }
}

class UpcomingSeeMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RidesProvider ridesProvider =
        Provider.of<RidesProvider>(context, listen: false);
    List<Ride> upcomingRides = ridesProvider.upcomingRides;

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
                  child:
                      Text('Upcoming Rides', style: CarriageTheme.largeTitle)),
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
                    itemCount: upcomingRides.length,
                    itemBuilder: (context, index) {
                      return RideCard(
                        upcomingRides[index],
                        showConfirmation: true,
                        showCallDriver: false,
                        showArrow: true,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                  ),
                ),
              ),
            )
          ]),
        )));
  }
}
