import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http/http.dart' as http;
import 'Ride.dart';
import 'app_config.dart';

Color grey = Color(0xFF9B9B9B);

class Upcoming extends StatefulWidget {
  Upcoming(this.ride);
  final Ride ride;
  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
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
                          Contact(),
                          SizedBox(height: 60),
                          TimeLine(widget.ride),
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
          child: Text('Schedule',
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
  const Contact({Key key}) : super(key: key);

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
                      color: grey,
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
                        color: grey,
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
                        color: grey,
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
  TimeLineRow({this.text, this.infoWidget});
  final String text;
  final Widget infoWidget;
  final double width = 26;

  Widget locationCircle() {
    return Container(
      width: width,
      height: width,
      child: Icon(Icons.circle, size: 8, color: grey),
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

class TimeLine extends StatelessWidget {
  TimeLine(this.ride);
  final double width = 26;
  final Ride ride;

  @override
  Widget build(BuildContext context) {
    double lineWidth = 4;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          //TODO: figure out how to not hard code this?
          Container(
            margin: EdgeInsets.only(left: width / 2 - (lineWidth / 2)),
            width: 4,
            height: 250,
            color: Color(0xFFECEBED),
          ),
          Column(
              children: [
                TimeLineRow(text: 'Your driver is on the way.'),
                SizedBox(height: 32),
                TimeLineRow(text: 'Driver has arrived.'),
                SizedBox(height: 32),
                TimeLineRow(
                    infoWidget: Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                    color: Colors.black.withOpacity(0.15)
                                )
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ride.startLocation, style: TextStyle(fontSize: 15, color: Color(0xFF1A051D))),
                                  //TODO: change to address
                                  Text(ride.startLocation, style: TextStyle(fontSize: 15, color: Color(0xFF1A051D).withOpacity(0.5))),
                                  SizedBox(height: 16),
                                  Text('Estimated pick up time: ', style: TextStyle(fontSize: 13, color: Color(0xFF3F3356)))
                                ]
                            ),
                          )
                      ),
                    )
                ),
                SizedBox(height: 32),
                TimeLineRow(text: 'Arrived!')
              ]
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

class CancelRidePage extends StatefulWidget {
  CancelRidePage(this.ride);
  final Ride ride;

  @override
  _CancelRidePageState createState() => _CancelRidePageState();
}

class _CancelRidePageState extends State<CancelRidePage> {
  bool cancelRepeating;

  @override
  void initState() {
    super.initState();
    setState(() {
      cancelRepeating  = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      child: Text('Cancel', style: TextStyle(fontSize: 17)),
                      onTap: () {
                        Navigator.of(context).pop();
                      }
                  ),
                  SizedBox(height: 32),
                  Text('Are you sure you want to cancel this ride?',
                      style: TextStyle(fontSize: 32, fontFamily: 'SFProDisplay', fontWeight: FontWeight.w500)),
                  CheckboxListTile(
                    activeColor: grey,
                    controlAffinity: ListTileControlAffinity.leading,
                      value: cancelRepeating,
                      onChanged: (bool newValue) {
                        setState(() {
                          cancelRepeating = newValue;
                        });
                      },
                      title: Text('Cancel all repeating rides', style: TextStyle(fontSize: 18, color: grey, fontWeight: FontWeight.normal))
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: double.infinity,

                      child: FlatButton(
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Cancel Ride', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                          ),
                        ),
                        onPressed: () async {
                          http.Response response = await http.delete(AppConfig.of(context).baseUrl + '/rides/${widget.ride.id}',
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              }
                          );
                          if (response.statusCode == 200) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CancelConfirmation()));
                          }
                        },
                      ),
                    ),
                  )
                ]
            ),
          ),
        )
    );
  }
}

class CancelConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                children: [
                  SizedBox(height: 176),
                  Image.asset('assets/images/cancel_ride_confirmed.png'),
                  SizedBox(height: 32),
                  Center(child: Text('Your ride is cancelled!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
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
                          child: Text('Done', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }
}