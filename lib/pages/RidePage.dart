import 'package:carriage_rider/pages/ride-flow/Request_Ride_Loc.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/utils/MeasureSize.dart';
import 'package:carriage_rider/utils/Ordinal.dart';
import 'package:carriage_rider/widgets/DriverCard.dart';
import 'package:carriage_rider/widgets/RecurringRideInfo.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Cancel_Ride.dart';
import '../models/Ride.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';

class RidePage extends StatefulWidget {
  RidePage(this.ride);

  final Ride ride;

  @override
  _RidePageState createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  double rideActionsHeight = 0;
  bool showRideActions = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DateTime dayBeforeRide = widget.ride.startTime.subtract(Duration(days: 1));
    DateTime dayBeforeRide10 = DateTime(
        dayBeforeRide.year, dayBeforeRide.month, dayBeforeRide.day, 10, 0);
    DateTime hourBeforeRide =
        widget.ride.startTime.subtract(Duration(hours: 1));
    bool beforeEditDeadline = DateTime.now().isBefore(dayBeforeRide10);

    bool editable = widget.ride.type == 'unscheduled' && beforeEditDeadline;
    bool cancellable = DateTime.now().isBefore(hourBeforeRide);

    void setRideActionVisibility(bool visible) {
      setState(() {
        showRideActions = visible;
      });
    }

    return Scaffold(
      key: scaffoldKey,
      appBar:
          ScheduleBar(Colors.black, Theme.of(context).scaffoldBackgroundColor),
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
                    child: Semantics(
                      header: true,
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
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 32),
                        DriverCard(
                            color: widget.ride.type == 'unscheduled'
                                ? CarriageTheme.gray4
                                : Colors.black,
                            ride: widget.ride,
                            showButtons: false),
                        SizedBox(height: 48),
                        TimeLine(widget.ride, true, false, false),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                  widget.ride.parentRide != null
                      ? Column(children: [
                          Container(
                              height: 6,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            color: Colors.white,
                            child: RecurringRideInfo(widget.ride.parentRide),
                          ),
                        ])
                      : Container(),
                  showRideActions && !editable && cancellable
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CancelRideButton(widget.ride)),
                        )
                      : Container(),
                  showRideActions
                      ? SizedBox(height: rideActionsHeight)
                      : Container()
                ],
              ),
            ),
            showRideActions && editable && cancellable
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: showRideActions &&
                            widget.ride.type == 'unscheduled' &&
                            beforeEditDeadline
                        ? MeasureSize(
                            child: RideActions(widget.ride,
                                setRideActionVisibility, scaffoldKey),
                            onChange: (size) {
                              setState(() {
                                rideActionsHeight = size.height;
                              });
                            },
                          )
                        : Container())
                : Container()
          ],
        ),
      ),
    );
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
                  color: Colors.black, fontSize: 20, fontFamily: 'Inter')),
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
                fontFamily: 'Inter',
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
                  fontFamily: 'Inter',
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

class CancelRideButton extends StatelessWidget {
  CancelRideButton(this.ride);

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    void openCancelPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CancelRidePage(ride)));
    }

    return Semantics(
      label: 'Cancel Ride',
      button: true,
      onTap: openCancelPage,
      child: ExcludeSemantics(
        child: TextButton(
          onPressed: openCancelPage,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.close, color: Colors.red),
                SizedBox(width: 10),
                Text('Cancel Ride',
                    style: TextStyle(
                        color: Colors.red, fontSize: 18, fontFamily: 'Inter'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RideActions extends StatelessWidget {
  const RideActions(this.ride, this.visibilityCallback, this.scaffoldKey);

  final Ride ride;
  final Function visibilityCallback;
  final GlobalKey scaffoldKey;

  @override
  Widget build(BuildContext context) {
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);

    void editSingle(BuildContext context, Ride ride) {
      print(ride.id);
      rideFlowProvider.setEditingSingle(context, ride);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RequestRideLoc()));
    }

    void editAll(BuildContext context, Ride parentRide) {
      rideFlowProvider.setEditingAll(context, parentRide);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RequestRideLoc()));
    }

    Widget editSingleButton(BuildContext context) => ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 3.0,
              primary: Colors.black,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50.0)),
          child: Text('Edit This Ride',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          onPressed: () {
            if (ride.parentRide != null || ride.recurring) {
              rideFlowProvider.setEditingRecurringSingle(context, ride);
            } else {
              rideFlowProvider.setEditingSingle(context, ride);
            }
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RequestRideLoc()));
          },
        );

    Widget editAllButton(BuildContext context) => ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 3.0,
              primary: Colors.black,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50.0)),
          child: Text('Edit All Repeating Rides',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          onPressed: () {
            if (ride.parentRide != null) {
              editAll(context, ride.parentRide);
            } else if (ride.recurring) {
              editAll(context, ride);
            } else {
              throw Exception(
                  'Editing all repeating rides failed for ride ${ride.id} with recurring=${ride.recurring} and parentRide=${ride.parentRide}');
            }
          },
        );

    Future<void> showEditDialog() async {
      visibilityCallback(false);
      await showDialog(
          context: scaffoldKey.currentContext,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (context) {
            return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              editSingleButton(context),
              SizedBox(height: 2),
              editAllButton(context),
              SizedBox(height: 8),
              Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 3.0,
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.8, 50.0)),
                    child: Text('Cancel',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      visibilityCallback(true);
                    },
                  )),
            ]);
          });
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            spreadRadius: 5,
            blurRadius: 11,
            color: Colors.black.withOpacity(0.11))
      ]),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        if (ride.parentRide != null || ride.recurring) {
                          showEditDialog();
                        } else {
                          editSingle(context, ride);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 3.0,
                          primary: Colors.black,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.8, 50.0)),
                      icon: Icon(Icons.edit),
                      label: Text('Edit Ride',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold))),
                ),
              ),
              CancelRideButton(ride)
            ],
          )
        ],
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
      return ExcludeSemantics(
        child: Container(
            width: 26,
            child: useCarIcon
                ? SvgPicture.asset('assets/images/carIcon.svg')
                : stopCircle),
      );
    }

    return Row(children: [
      locationCircle(),
      SizedBox(width: 16),
      text == null
          ? infoWidget
          : text == noShowMessage
              ? Expanded(
                  child: Text(noShowMessage,
                      style: TextStyle(fontSize: 16, color: Color(0xFFF44336))),
                )
              : isCurrentRide
                  ? Expanded(
                      child: Text(text,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    )
                  : Expanded(
                      child: Text(text,
                          style: TextStyle(
                              fontSize: 16, color: CarriageTheme.gray4)),
                    )
    ]);
  }
}

class TimeLine extends StatefulWidget {
  TimeLine(this.ride, this.hasLocationIcon, this.isCurrent, this.isCarIcon);

  final Ride ride;
  final bool hasLocationIcon;
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

  void displayBottomSheet(BuildContext context, Ride ride, bool isStart) {
    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);

    String info = 'No Location Info';
    if (isStart) {
      if (locationsProvider.isPreset(ride.startLocation)) {
        String potentialStartInfo =
            locationsProvider.locationByName(ride.startLocation).info;
        if (potentialStartInfo != null) {
          info = potentialStartInfo;
        }
      }
    } else {
      if (locationsProvider.isPreset(ride.endLocation)) {
        String potentialEndInfo =
            locationsProvider.locationByName(ride.endLocation).info;
        if (potentialEndInfo != null) {
          info = potentialEndInfo;
        }
      }
    }
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (ctx) {
          return MergeSemantics(
            child: Container(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              isStart ? ride.startLocation : ride.endLocation,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              semanticsLabel: (isStart
                                      ? ride.startLocation
                                      : ride.endLocation) +
                                  '.',
                            ),
                          ),
                          SizedBox(height: 10),
                          Flexible(
                            child: Text(info, style: TextStyle(fontSize: 16)),
                          ),
                        ]))),
          );
        });
  }

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

    //Widget displaying a custom built card with information about a ride's start location and start time.
    //[isIcon] determines whether the card needs an icon.
    Widget buildLocationsCard(BuildContext context, bool isStart) {
      LocationsProvider locationsProvider =
          Provider.of<LocationsProvider>(context, listen: false);
      String location =
          isStart ? widget.ride.startLocation : widget.ride.endLocation;
      String address =
          isStart ? widget.ride.startAddress : widget.ride.endAddress;

      return Semantics(
        container: true,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [CarriageTheme.boxShadow]),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(location,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF1A051D)),
                                      semanticsLabel: (isStart
                                              ? 'Start location: ' +
                                                  widget.ride.startLocation
                                              : 'End location: ' +
                                                  widget.ride.endLocation) +
                                          '.'),
                                  !locationsProvider.isPreset(location)
                                      ? Text(address,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF1A051D)
                                                  .withOpacity(0.5)),
                                          semanticsLabel:
                                              'Address: ' + address + '.')
                                      : Container()
                                ]),
                          ),
                          SizedBox(height: 16),
                          Text(
                              'Estimated ${isStart ? 'pick up time' : 'drop off time'}: ' +
                                  DateFormat('jm').format(isStart
                                      ? widget.ride.startTime
                                      : widget.ride.endTime),
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF3F3356)))
                        ]),
                  ),
                  widget.hasLocationIcon
                      ? Semantics(
                          button: true,
                          container: true,
                          label: (isStart ? 'Start ' : 'End ') +
                              'location details',
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              onTap: () => displayBottomSheet(
                                  context, widget.ride, isStart),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.black.withOpacity(0.25)),
                                ),
                                child: Icon(Icons.location_on),
                              ),
                            ),
                          ))
                      : Container()
                ],
              ),
            )),
      );
    }

    Widget driverOnTheWay() {
      return TimeLineRow(
          text: 'Your driver is on the way.',
          useCarIcon: widget.isCarIcon,
          isCurrentRide: widget.isCurrent);
    }

    Widget startLocationCard() {
      return TimeLineRow(
          infoWidget: Expanded(child: buildLocationsCard(context, true)),
          useCarIcon: false,
          isCurrentRide: widget.isCurrent);
    }

    Widget endLocationCard() {
      return TimeLineRow(
          infoWidget: Expanded(child: buildLocationsCard(context, false)),
          useCarIcon: false,
          isCurrentRide: widget.isCurrent);
    }

    Widget noShow() {
      return TimeLineRow(
          text: noShowMessage,
          useCarIcon: false,
          isCurrentRide: widget.isCurrent);
    }

    Widget arrived() {
      return TimeLineRow(
          text: 'Arrived!', useCarIcon: false, isCurrentRide: widget.isCurrent);
    }

    List<Widget> timeLineRows = [startLocationCard(), endLocationCard()];
    if (widget.isCurrent || widget.ride.type == 'past') {
      timeLineRows.insert(0, driverOnTheWay());
    }
    if (widget.ride.type == 'past') {
      if (widget.ride.status == RideStatus.NO_SHOW) {
        timeLineRows.add(noShow());
      } else {
        timeLineRows.add(arrived());
      }
    }

    timeLineRows.first = MeasureSize(
      onChange: (size) {
        setState(() {
          firstRowHeight = size.height;
          line = buildLine();
        });
      },
      child: Container(key: firstRowKey, child: timeLineRows.first),
    );

    timeLineRows.last = MeasureSize(
      onChange: (size) {
        setState(() {
          lastRowHeight = size.height;
          line = buildLine();
        });
      },
      child: Container(key: lastRowKey, child: timeLineRows.last),
    );

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
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: timeLineRows.length,
              itemBuilder: (context, index) {
                return timeLineRows[index];
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 30);
              },
            ),
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
                    color: Colors.black, fontSize: 18, fontFamily: 'Inter')),
            Text(action,
                style: TextStyle(
                    color: Colors.grey, fontSize: 13, fontFamily: 'Inter')),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(address,
                style: TextStyle(
                    color: Colors.grey, fontSize: 12, fontFamily: 'Inter')),
            Text(time,
                style: TextStyle(
                    color: Colors.grey, fontSize: 12, fontFamily: 'Inter'))
          ],
        )
      ],
    );
  }
}
