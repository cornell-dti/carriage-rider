import 'package:carriage_rider/MeasureSize.dart';
import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'Cancel_Ride.dart';
import 'Ride.dart';
import 'TextThemes.dart';

Color grey = Color(0xFF9B9B9B);

class UpcomingRidePage extends StatefulWidget {
  UpcomingRidePage(this.ride);
  final Ride ride;
  @override
  _UpcomingRidePageState createState() => _UpcomingRidePageState();
}

class _UpcomingRidePageState extends State<UpcomingRidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 16),
                        child: Row(
                            children: [
                              Icon(Icons.arrow_back_ios, color: Colors.black),
                              Text('Schedule', style: TextStyle(fontSize: 17))
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
                      child: Text(DateFormat('MMM').format(widget.ride.startTime).toUpperCase() +
                          ' ' + ordinal(int.parse(DateFormat('d').format(widget.ride.startTime))) +
                          ' ' + DateFormat('jm').format(widget.ride.startTime),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),

                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 32),
                          Contact(color: Colors.grey),
                          SizedBox(height: 60),
                          TimeLine(widget.ride, false),
                          SizedBox(height: 70),
                          RideAction(
                              text: "Cancel Ride",
                              color: Colors.red,
                              icon: Icons.close,
                              action: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CancelRidePage(widget.ride)))
                          ),
                          SizedBox(height: 20),
                          EditRide(),
                        ],
                      ),
                    )
                  ],
                ),
              ),

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
                  fontSize: 30,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.bold)),
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

class Contact extends StatelessWidget {
  final Color color;
  const Contact({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.account_circle, size: 64, color: grey),
          SizedBox(width: 15),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Driver TBD',
                  style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
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
                                color: grey,
                                blurRadius: 2,
                                spreadRadius: 0
                            )
                          ]
                      ),
                      child: IconButton(
                        icon: Icon(Icons.phone, size: 16),
                        color: color,
                        onPressed: () => UrlLauncher.launch("tel://13232315234"),
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
                                color: grey,
                                blurRadius: 2,
                                spreadRadius: 0
                            )
                          ]
                      ),
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
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 5,
                  blurRadius: 11,
                  color: Colors.black.withOpacity(0.11)
              )
            ]
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: 45.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                child: RaisedButton.icon(
                    onPressed: () {},
                    elevation: 3.0,
                    color: Colors.black,
                    textColor: Colors.white,
                    icon: Icon(Icons.edit),
                    label: Text('Edit Ride', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimeLineRow extends StatelessWidget {
  TimeLineRow({this.text, this.infoWidget, this.decorationWidth});
  final String text;
  final Widget infoWidget;
  final double decorationWidth;

  Widget locationCircle() {
    return Container(
      width: decorationWidth,
      height: decorationWidth,
      child: Icon(Icons.circle, size: 9.75, color: grey),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: grey,
                blurRadius: 2,
                spreadRadius: 0
            )
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          locationCircle(),
          SizedBox(width: 16),
          text == null ? infoWidget : Text(text, style: TextStyle(fontSize: 16, color: grey))
        ]
    );
  }
}

class TimeLine extends StatefulWidget {
  TimeLine(this.ride, this.isIcon);
  final Ride ride;
  final bool isIcon;

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  double width = 26;
  double timelineHeight;
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
      return timelineHeight != null && firstRowKey.currentContext != null &&
          lastRowKey.currentContext != null ? Container(
        margin: EdgeInsets.only(left: width / 2 - (lineWidth / 2)),
        width: 4,
        height: getLastRowPos() - getFirstRowPos(),
        color: Color(0xFFECEBED),
      ) : CircularProgressIndicator();
    }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: <Widget>[
            line == null ? CircularProgressIndicator() : line,
            MeasureSize(
              onChange: (size) {
                setState(() {
                  timelineHeight = size.height;
                  line = buildLine();
                });
              },
              child: Column(
                  children: [
                    Container(
                      key: firstRowKey,
                      child: TimeLineRow(
                          text: 'Your driver is on the way.',
                          decorationWidth: width
                      ),
                    ),
                    SizedBox(height: 32),
                    TimeLineRow(
                        text: 'Driver has arrived.',
                        decorationWidth: width
                    ),
                    SizedBox(height: 32),
                    TimeLineRow(
                        infoWidget: Expanded(
                            child: widget.ride.buildLocationsCard(context, widget.isIcon)
                        ),
                        decorationWidth: width
                    ),
                    SizedBox(height: 32),
                    Container(
                      key: lastRowKey,
                      child: TimeLineRow(
                          text: 'Arrived!',
                          decorationWidth: width
                      ),
                    )
                  ]
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

class UpcomingRideCard extends StatelessWidget {
  UpcomingRideCard(this.ride);
  final Ride ride;

  final confirmationStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => UpcomingRidePage(ride))
        );
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        child: Card(
          elevation: 3.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ride.type == 'active' ? Text('Ride Confirmed', style: confirmationStyle.copyWith(color: Color(0xFF4CAF50))) :
                  Text('Ride Requested', style: confirmationStyle.copyWith(color: Color(0xFFFF9800))),
                  SizedBox(height: 4),
                  ride.buildStartTime(),
                  SizedBox(height: 16),
                  Text('From', style: TextThemes.directionStyle),
                  Text(ride.startLocation, style: TextThemes.rideInfoStyle),
                  SizedBox(height: 8),
                  Text('To', style: TextThemes.directionStyle),
                  Text(ride.endLocation, style: TextThemes.rideInfoStyle),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        //TODO: replace temp phone number
                        onTap: () => UrlLauncher.launch("tel://13232315234"),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.25))),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(Icons.phone, size: 20, color: Color(0xFF9B9B9B)),
                            )
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Driver', style: TextStyle(fontSize: 11)),
                          Text(ride.type == 'active' ? 'Confirmed' : 'TBD', style: TextThemes.rideInfoStyle)
                        ],
                      )
                    ],
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}
class UpcomingRides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: <Widget>[
          //TODO: remove temporary data
          UpcomingRideCard(
              Ride(
                type: 'active',
                startLocation: 'Cornell University',
                startAddress: '100 Carriage Way',
                endLocation: 'Cascadilla Hall',
                endAddress: '101 DTI St, Ithaca, NY 14850',
                startTime: DateTime(2020, 10, 18, 13, 0),
                endTime: DateTime(2020, 10, 18, 13, 15),
              )
          )
        ],
      ),
    );
  }
}
