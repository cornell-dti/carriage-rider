import 'package:carriage_rider/Upcoming.dart';
import 'package:flutter/material.dart';

class Current extends StatefulWidget {
  @override
  _CurrentState createState() => _CurrentState();
}

class _CurrentState extends State<Current> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Schedule',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'SFPro'),
          ),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  BackgroundHeader(
                      widget: Text("Current Ride",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'SFPro',
                              fontWeight: FontWeight.bold,))),
                  BackgroundHeader(
                    widget: SizedBox(height: 10),
                  ),
                  SizedBox(height: 15),
                  SubHeader(subHeader1: 'Ride Info', subHeader2: 'Confirmed'),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                InformationRow(
                                    loc: 'Upson Hall',
                                    address: '109 Tower Rd, Ithaca, NY 14850',
                                    action: 'Pickup',
                                    time: '3:15 PM'),
                                SizedBox(height: 20),
                                InformationRow(
                                    loc: 'Gates Hall',
                                    address: '107 Hoy Rd, Ithaca, NY 14850',
                                    action: 'Dropoff',
                                    time: '3:20 PM'),
                                SizedBox(height: 20)
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
                      text: "Cancel Ride",
                      color: Colors.red,
                      icon: Icons.clear),
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                ],
              ),
            )
          ],
        )));
  }
}

class BackgroundHeader extends StatelessWidget {
  const BackgroundHeader({Key key, this.widget}) : super(key: key);
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        children: <Widget>[
         Expanded(child: Padding(
           padding: EdgeInsets.only(left: 10),
           child: widget
         )),
        ],
      ),
    );
  }
}
