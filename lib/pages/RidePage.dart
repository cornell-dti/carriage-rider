import 'package:carriage_rider/pages/ride-flow/Request_Ride_Loc.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/utils/MeasureSize.dart';
import 'package:carriage_rider/widgets/DriverCard.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Cancel_Ride.dart';
import '../models/Ride.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

class RidePage extends StatelessWidget {
  RidePage(this.ride, {this.parentRideID});

  final Ride ride;
  final String parentRideID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ScheduleBar(
            Colors.black, Theme.of(context).scaffoldBackgroundColor),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 8, top: 16),
                      child: Text(
                          DateFormat('MMM')
                                  .format(ride.startTime)
                                  .toUpperCase() +
                              ' ' +
                              ordinal(int.parse(
                                  DateFormat('d').format(ride.startTime))) +
                              ' ' +
                              DateFormat('jm').format(ride.startTime),
                          style: CarriageTheme.largeTitle),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 32),
                          DriverCard(
                              color: ride.type == 'unscheduled'
                                  ? CarriageTheme.gray4
                                  : Colors.black,
                              ride: ride,
                              showButtons: false),
                          SizedBox(height: 48),
                          TimeLine(ride, true, false, false),
                          SizedBox(height: 50),
                          ride.type == 'past'
                              ? Container()
                              : RideAction(
                                  text: 'Cancel Ride',
                                  color: Colors.red,
                                  icon: Icons.close,
                                  action: () => Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              CancelRidePage(ride)))),
                          SizedBox(height: 48),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ride.type == 'unscheduled' ? EditRide() : Container()),
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

class EditRide extends StatelessWidget {
  const EditRide(this.ride);
  final Ride ride;

  @override
  Widget build(BuildContext context) {
    RideFlowProvider createRideProvider =
        Provider.of<RideFlowProvider>(context);

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
                      createRideProvider.setLocControllers(
                          ride.startLocation, ride.endLocation);
                      createRideProvider.setPickupTimeCtrl(
                          TimeOfDay.fromDateTime(ride.startTime)
                              .format(context));
                      createRideProvider.setDropoffTimeCtrl(
                          TimeOfDay.fromDateTime(ride.endTime).format(context));
                      createRideProvider.setStartDateCtrl(ride.startTime);
                      createRideProvider.setEditing(true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RequestRideLoc(ride: ride.copy())));
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

String noShowMessage = 'No Show';

class TimeLineRow extends StatelessWidget {
  TimeLineRow(
      {this.text,
      this.infoWidget,
      @required this.useCarIcon,
      @required this.isCurrentRide});

  final String text;
  final Widget infoWidget;
  final bool useCarIcon;
  final bool isCurrentRide;

  @override
  Widget build(BuildContext context) {
    double circleRadius = 13;
    Widget stopCircle =
        Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
      Container(
          width: circleRadius * 2,
          height: 26,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [CarriageTheme.boxShadow])),
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
          child: useCarIcon
              ? SvgPicture.asset('assets/images/carIcon.svg')
              : stopCircle);
    }

    return Row(children: [
      locationCircle(),
      SizedBox(width: 16),
      text == null
          ? infoWidget
          : text == noShowMessage
              ? Text(noShowMessage,
                  style: TextStyle(fontSize: 16, color: Color(0xFFF44336)))
              : isCurrentRide
                  ? Text(text,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))
                  : Text(text,
                      style:
                          TextStyle(fontSize: 16, color: CarriageTheme.gray4))
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
  double lastRowHeight;
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

    bool doneRender() =>
        timelineHeight != null &&
        firstRowKey.currentContext != null &&
        lastRowKey.currentContext != null &&
        firstRowHeight != null &&
        lastRowHeight != null;

    Widget buildLine() {
      if (doneRender()) {
        double length = getLastRowPos() -
            getFirstRowPos() -
            (firstRowHeight / 2) +
            (lastRowHeight / 2);
        return Positioned(
          top: firstRowHeight / 2,
          child: Container(
            margin: EdgeInsets.only(left: width / 2 - (lineWidth / 2)),
            width: 4,
            height: length,
            color: Color(0xFFECEBED),
          ),
        );
      }
      return CircularProgressIndicator();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          line != null && firstRowHeight != null && lastRowHeight != null
              ? line
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
                      useCarIcon: widget.isCarIcon,
                      isCurrentRide: widget.isCurrent),
                ),
              ),
              SizedBox(height: 32),
              TimeLineRow(
                  infoWidget: Expanded(
                      child: widget.ride.buildLocationsCard(
                          context, widget.isIcon, true, true)),
                  useCarIcon: false,
                  isCurrentRide: widget.isCurrent),
              SizedBox(height: 32),
              MeasureSize(
                onChange: (size) {
                  if (widget.ride.type != 'past') {
                    setState(() {
                      lastRowHeight = size.height;
                      line = buildLine();
                    });
                  }
                },
                child: Container(
                  key: widget.ride.type != 'past' ? lastRowKey : null,
                  child: TimeLineRow(
                      infoWidget: Expanded(
                          child: widget.ride.buildLocationsCard(
                              context, widget.isIcon, false, false)),
                      useCarIcon: false,
                      isCurrentRide: widget.isCurrent),
                ),
              ),
              widget.ride.type == 'past' ? SizedBox(height: 32) : Container(),
              MeasureSize(
                onChange: (size) {
                  if (widget.ride.type == 'past') {
                    setState(() {
                      lastRowHeight = size.height;
                      line = buildLine();
                    });
                  }
                },
                child: Container(
                  key: widget.ride.type == 'past' ? lastRowKey : null,
                  child: widget.ride.type == 'past'
                      ? widget.ride.status == RideStatus.NO_SHOW
                          ? TimeLineRow(
                              text: noShowMessage,
                              useCarIcon: false,
                              isCurrentRide: widget.isCurrent)
                          : TimeLineRow(
                              text: 'Arrived!',
                              useCarIcon: false,
                              isCurrentRide: widget.isCurrent)
                      : Container(),
                ),
              ),
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
  const RideAction(
      {@required this.text,
      @required this.color,
      @required this.icon,
      @required this.action});
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
