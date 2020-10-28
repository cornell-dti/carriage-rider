import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Upcoming extends StatefulWidget {
  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: PageTitle(title: 'Schedule'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Header(header: 'Upcoming Ride'),
                    SizedBox(height: 10),
                    SubHeader(subHeader1: 'Ride Info', subHeader2: 'Confirmed'),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          TimeLine(),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  InformationRow(
                                      loc: 'Upson Hall',
                                      address: '124 Hoy Rd, Ithaca, NY 14850',
                                      action: 'Pickup Passenger 1',
                                      time: '3:15 PM'),
                                  SizedBox(height: 20),
                                  InformationRow(
                                      loc: 'Gates Hall',
                                      address: '107 Hoy Rd, Ithaca, NY 14853',
                                      action: 'Pickup Passenger 2',
                                      time: '3:20 PM'),
                                  SizedBox(height: 20),
                                  InformationRow(
                                      loc: 'Statler Hall',
                                      address: '109 Tower Rd, Ithaca, NY 14850',
                                      action: 'Dropoff Passenger 1',
                                      time: '3:25 PM'),
                                  SizedBox(height: 20),
                                  InformationRow(
                                      loc: 'Rhodes Hall',
                                      address: '109 Tower Rd, Ithaca, NY 14850',
                                      action: 'Dropoff Passenger 2',
                                      time: '4:20 PM'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20)
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    CustomDivider(),
                    SizedBox(height: 15),
                    Contact(),
                    SizedBox(height: 15),
                    CustomDivider(),
                    SizedBox(height: 20),
                    RideAction(
                        rideAction: "Cancel Ride",
                        color: Colors.red,
                        icon: Icons.not_interested),
                    SizedBox(height: MediaQuery.of(context).size.height / 8),
                  ],
                )
              ],
            ),
            EditRide()
          ],
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
  const Contact({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: <Widget>[
          Icon(Icons.account_circle, size: 50),
          SizedBox(width: 15),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Davea Butler',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'SFPro')),
                SizedBox(height: 5),
                Container(
                  child: Row(
                    children: <Widget>[Text('CULift Van')],
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width / 4),
          GestureDetector(
              onTap: () => UrlLauncher.launch("tel://13232315234"),
              child: Icon(Icons.phone, size: 25))
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
        color: Colors.white,
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
                    icon: Icon(Icons.mode_edit),
                    label: Text('Edit Ride')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimeLine extends StatelessWidget {
  const TimeLine({Key key}) : super(key: key);

  Widget locationCircle() {
    return Container(
      width: 18,
      height: 18,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: new Border.all(
            color: Colors.white, width: 6.0, style: BorderStyle.solid),
        boxShadow: [
          new BoxShadow(
            color: Colors.grey[900],
            blurRadius: 5.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(left: 6),
                        width: 4,
                        height: 200,
                        color: Colors.black,
                      ),
                      locationCircle(),
                      Positioned(
                        top: 60,
                        child: locationCircle(),
                      ),
                      Positioned(
                        top: 120,
                        child: locationCircle(),
                      ),
                      Positioned(
                        top: 182,
                        child: locationCircle(),
                      )
                    ],
                  ),
                ),
              ],
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
  const RideAction({Key key, this.rideAction, this.color, this.icon})
      : super(key: key);

  final String rideAction;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: color),
        SizedBox(width: 10),
        Text(rideAction,
            style: TextStyle(color: color, fontSize: 18, fontFamily: 'SFPro'))
      ],
    );
  }
}
