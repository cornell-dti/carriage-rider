import 'package:carriage_rider/utils/MeasureSize.dart';
import 'dart:math';
import 'package:flutter_svg/svg.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'Cancel_Ride.dart';
import '../models/Ride.dart';
import '../PopButton.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

Color grey = Color(0xFF9B9B9B);

class UpcomingRidePage extends StatefulWidget {
  UpcomingRidePage(this.ride, {this.parentRideID});

  final Ride ride;
  final String parentRideID;

  @override
  _UpcomingRidePageState createState() => _UpcomingRidePageState();
}

class _UpcomingRidePageState extends State<UpcomingRidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: PageTitle(title: 'Schedule'),
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 8, top: 8),
                      child: Text(
                          DateFormat('MMM')
                                  .format(widget.ride.startTime)
                                  .toUpperCase() +
                              ' ' +
                              ordinal(int.parse(DateFormat('d')
                                  .format(widget.ride.startTime))) +
                              ' ' +
                              DateFormat('jm').format(widget.ride.startTime),
                          style: CarriageTheme.largeTitle),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 32),
                          ContactCard(color: Colors.grey, ride: widget.ride),
                          SizedBox(height: 60),
                          TimeLine(widget.ride, true, false, false),
                          SizedBox(height: 50),
                          widget.ride.type == 'past'
                              ? Container()
                              : RideAction(
                                  text: 'Cancel Ride',
                                  color: Colors.red,
                                  icon: Icons.close,
                                  action: () => Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              CancelRidePage(widget.ride)))),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: widget.ride.type == 'past' ? Container() : EditRide(),
              )
            ],
          ),
        ));
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(title,
              style: TextStyle(
                  color: Colors.black, fontSize: 20, fontFamily: 'SFPro')),
        )
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key key, this.header}) : super(key: key);
  final String header;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
          child: Text(header,
              style: TextStyle(
                color: Colors.black,
                fontSize: 34,
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.bold,
              )),
        )
      ],
    );
  }
}

class SubHeader extends StatelessWidget {
  const SubHeader({Key key, this.subHeader1, this.subHeader2})
      : super(key: key);

  final String subHeader1;
  final String subHeader2;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: <Widget>[
          Text(subHeader1,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 20,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 10.0),
          Text(subHeader2,
              style: TextStyle(color: Colors.green[500], fontSize: 11))
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 4,
      color: Colors.grey[200],
    );
  }
}

class ContactCard extends StatelessWidget {
  final Color color;
  final Ride ride;

  const ContactCard({Key key, this.color, this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ride.driver == null || ride.driver.photoLink == null
              ? Icon(Icons.account_circle, size: 64, color: grey)
              : CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://${ride.driver.photoLink}'),
                  radius: 35),
          SizedBox(width: 15),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ride.driver == null ? 'Driver TBD' : ride.driver.fullName(),
                  style: TextStyle(
                      color: color, fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: grey, blurRadius: 2, spreadRadius: 0)
                          ]),
                      child: IconButton(
                        icon: Icon(Icons.phone, size: 16),
                        color: color,
                        onPressed: () => UrlLauncher.launch(
                            'tel://${ride.driver.phoneNumber}'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: grey, blurRadius: 2, spreadRadius: 0)
                          ]),
                      child: IconButton(
                        icon: Icon(Icons.warning, size: 16),
                        color: color,
                        onPressed: () {
                          //TODO: add action on press
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditRide extends StatelessWidget {
  const EditRide({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 8,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              spreadRadius: 5,
              blurRadius: 11,
              color: Colors.black.withOpacity(0.11))
        ]),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: 50.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: RaisedButton.icon(
                    onPressed: () {
                      //TODO: navigate to edit flow
                    },
                    elevation: 3.0,
                    color: Colors.black,
                    textColor: Colors.white,
                    icon: Icon(Icons.edit),
                    label: Text('Edit Ride',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimeLineRow extends StatelessWidget {
  TimeLineRow(
      {this.text,
      this.infoWidget,
      this.decorationWidth,
      this.carIcon,
      this.currentRide});

  final String text;
  final Widget infoWidget;
  final bool carIcon;
  final bool currentRide;
  final double decorationWidth;

  @override
  Widget build(BuildContext context) {
    double circleRadius = 13;
    Widget stopCircle =
        Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
      Container(
          width: circleRadius * 2,
          height: 26,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          )),
      Container(
          width: 8,
          height: 8,
          decoration: new BoxDecoration(
            color: Color(0xFF9B9B9B),
            shape: BoxShape.circle,
          ))
    ]);

    Widget locationCircle() {
      return Container(
          width: 26,
          child: carIcon
              ? SvgPicture.asset('assets/images/carIcon.svg')
              : stopCircle);
    }

    return Row(children: [
      locationCircle(),
      SizedBox(width: 16),
      text == null
          ? infoWidget
          : currentRide
              ? Text(text,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))
              : Text(text, style: TextStyle(fontSize: 16, color: grey))
    ]);
  }
}

class TimeLine extends StatefulWidget {
  TimeLine(this.ride, this.isIcon, this.isCurrent, this.isCarIcon);

  final Ride ride;
  final bool isIcon;
  final bool isCurrent;
  final bool isCarIcon;

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  double width = 26;
  double timelineHeight;
  double firstRowHeight;
  Widget line;

  @override
  Widget build(BuildContext context) {
    double lineWidth = 4;
    GlobalKey firstRowKey = GlobalKey();
    GlobalKey lastRowKey = GlobalKey();

    double getFirstRowPos() {
      RenderBox firstRowBox = firstRowKey.currentContext.findRenderObject();
      return firstRowBox.localToGlobal(Offset.zero).dy;
    }

    double getLastRowPos() {
      RenderBox lastRowBox = lastRowKey.currentContext.findRenderObject();
      return lastRowBox.localToGlobal(Offset.zero).dy;
    }

    Widget buildLine() {
      double length = getLastRowPos() - getFirstRowPos() - (firstRowHeight / 2);
      return timelineHeight != null &&
              firstRowKey.currentContext != null &&
              lastRowKey.currentContext != null &&
              firstRowHeight != null
          ? Container(
              margin: EdgeInsets.only(left: width / 2 - (lineWidth / 2)),
              width: 4,
              height: length + length / 4,
              color: Color(0xFFECEBED),
            )
          : CircularProgressIndicator();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          line != null && firstRowHeight != null
              ? Positioned(top: firstRowHeight / 2, child: line)
              : Container(),
          MeasureSize(
            onChange: (size) {
              setState(() {
                timelineHeight = size.height;
              });
            },
            child: Column(children: [
              MeasureSize(
                onChange: (size) {
                  setState(() {
                    firstRowHeight = size.height;
                    line = buildLine();
                  });
                },
                child: Container(
                  key: firstRowKey,
                  child: TimeLineRow(
                      text: 'Your driver is on the way.',
                      decorationWidth: width,
                      carIcon: widget.isCarIcon,
                      currentRide: widget.isCurrent),
                ),
              ),
              SizedBox(height: 32),
              TimeLineRow(
                  infoWidget: Expanded(
                      child: widget.ride.buildLocationsCard(
                          context, widget.isIcon, true, true)),
                  decorationWidth: width,
                  carIcon: false),
              SizedBox(height: 32),
              Container(
                key: lastRowKey,
                child: TimeLineRow(
                    infoWidget: Expanded(
                        child: widget.ride.buildLocationsCard(
                            context, widget.isIcon, false, false)),
                    decorationWidth: width,
                    carIcon: false),
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class InformationRow extends StatelessWidget {
  const InformationRow(
      {Key key, this.loc, this.address, this.action, this.time})
      : super(key: key);

  final String loc;
  final String address;
  final String action;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(loc,
                style: TextStyle(
                    color: Colors.black, fontSize: 18, fontFamily: 'SFPro')),
            Text(action,
                style: TextStyle(
                    color: Colors.grey, fontSize: 13, fontFamily: 'SFPro')),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(address,
                style: TextStyle(
                    color: Colors.grey, fontSize: 12, fontFamily: 'SFPro')),
            Text(time,
                style: TextStyle(
                    color: Colors.grey, fontSize: 12, fontFamily: 'SFPro'))
          ],
        )
      ],
    );
  }
}

class RideAction extends StatelessWidget {
  const RideAction({Key key, this.text, this.color, this.icon, this.action})
      : super(key: key);
  final String text;
  final Color color;
  final IconData icon;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        action();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color),
          SizedBox(width: 10),
          Text(text,
              style: TextStyle(color: color, fontSize: 18, fontFamily: 'SFPro'))
        ],
      ),
    );
  }
}

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
            showConfirmation: true,
            showCallDriver: true,
            showArrow: false),
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

    if (upcomingRides.length == 0) {
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
    List<Ride> originalRides = ridesProvider.upcomingRides;
    RecurringRidesGenerator ridesGenerator =
        RecurringRidesGenerator(originalRides);

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: PopButton(context, 'Schedule'),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text('Upcoming Rides', style: CarriageTheme.largeTitle),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ridesGenerator.buildUpcomingRidesList(),
            ),
          ),
        )
      ]),
    )));
  }
}
