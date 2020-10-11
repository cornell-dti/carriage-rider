import 'dart:ui';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'size_config.dart';
import 'dart:core';
import 'RiderProvider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Current extends StatefulWidget {
  @override
  _CurrentState createState() => _CurrentState();
}

class _CurrentState extends State<Current> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    SizeConfig().init(context);

    if (riderProvider.hasInfo()) {
      String phoneNumber = riderProvider.info.phoneNumber;
      String fPhoneNumber = phoneNumber.substring(0, 3) +
          "-" +
          phoneNumber.substring(3, 6) +
          "-" +
          phoneNumber.substring(6, 10);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Schedule',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'SFPro'),
          ),
          backgroundColor: Colors.black,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(
                                left: SizeConfig.safeBlockHorizontal * 7,
                              ),
                              child:
                              headerText("Current Ride", Colors.white, 35)),
                        ],
                      ),
                    ],
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(
                                    top: SizeConfig.safeBlockHorizontal * 7,
                                    left: SizeConfig.safeBlockHorizontal * 7,
                                    bottom: SizeConfig.safeBlockHorizontal * 3,
                                  ),
                                  child: headerText(
                                      "Ride Status", Colors.black, 24)),
                            ],
                          ),
                          orderTimeline()
                        ],
                      )),
                ),
                flex: 8,
              ),
              Expanded(
                child: profileInfo(context, phoneNumber, fPhoneNumber),
                flex: 3,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: SizedBox(
                      width: double.maxFinite,
                      height: 10,
                      child: RepeatRideButton()),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(child: Center(child: CircularProgressIndicator()));
    }
  }

  Widget headerText(String text, Color color, double size) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'SFPro',
          fontWeight: FontWeight.bold),
    );
  }

  Widget infoDivider() {
    return Container(
      padding: EdgeInsets.all(2),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }

  Widget profileInfo(
      BuildContext context, String phoneNumber, String fPhoneNumber) {
    AuthProvider authProvider = Provider.of(context);
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            infoDivider(),
            Container(
                padding: EdgeInsets.only(
                  top: SizeConfig.safeBlockHorizontal * 4,
                )
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  SizedBox(
                      height: 50,
                      width: 50,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          authProvider.googleSignIn.currentUser.photoUrl,
                        ),
                        radius: 20,
                        backgroundColor: Colors.transparent,
                      )),
                  SizedBox(width: 15),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(authProvider.googleSignIn.currentUser.displayName,
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
                      onTap: () => UrlLauncher.launch("tel://$phoneNumber"),
                      child: Icon(Icons.phone, size: 25))
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.safeBlockHorizontal * 4,
                )
            ),
            infoDivider(),
          ],
        ));
  }

  Widget orderTimeline() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(
        bottom: SizeConfig.safeBlockHorizontal * 3,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.safeBlockHorizontal * 3,
        left: SizeConfig.safeBlockHorizontal * 7,
        bottom: SizeConfig.safeBlockHorizontal * 3,
      ),
      child: Column(
        children: <Widget>[
          timelineRow("Your driver is on the way.", ""),
          timelineRow("Driver has arrived.", ""),
          timelineCurrentRow("You are on the way!", ""),
          timelineLastRow("Arrived!", ""),
        ],
      ),
    );
  }

  Widget coloredCircle(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: 18,
        height: 18,
        decoration: new BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: new Border.all(
              color: Colors.white, width: 6.0, style: BorderStyle.solid),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey[300],
              blurRadius: 10.0,
            )
          ],
        ),
        child: Text(
          "",
        ),
      ),
    );
  }

  Widget nonHighlightLine(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        coloredCircle(Colors.grey),
        Container(
          width: 3,
          height: 20,
          decoration: new BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
          child: Text(""),
        ),
      ],
    );
  }

  Widget timeLineTitle(String title, String subTile, Color color) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$title\n $subTile',
            style:
            TextStyle(fontFamily: "regular", fontSize: 19, color: color)),
      ],
    );
  }

  Widget timelineRow(String title, String subTile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30),
        Expanded(flex: 1, child: nonHighlightLine(Colors.black)),
        Expanded(flex: 9, child: timeLineTitle(title, subTile, Colors.black54)),
      ],
    );
  }

  Widget timelineCurrentRow(String title, String subTile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30),
        Expanded(
          flex: 1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              coloredCircle(Colors.black),
              Container(
                width: 3,
                height: 200,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$title',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 19,
                      color: Colors.black)),
              Column(
                children: <Widget>[RideStatus()],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget timelineLastRow(String title, String subTile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(flex: 1, child: nonHighlightLine(Colors.transparent)),
        Expanded(
          flex: 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[timeLineTitle(title, subTile, Colors.black54)],
          ),
        ),
      ],
    );
  }
}

class RepeatRideButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.only(
        bottom: SizeConfig.safeBlockHorizontal * 6,
      ),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.repeat),
          SizedBox(width: 10),
          Text(
            'Repeat This Ride',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "SFPro",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
      onPressed: () {},
    );
  }
}

class RideStatus extends StatefulWidget {
  @override
  _RideStatusState createState() => _RideStatusState();
}

class _RideStatusState extends State<RideStatus> {
  Widget rideText(String text, double size, Color color) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          color: color,
        ),
      ),
    );
  }

  Widget titleRow(BuildContext context, String fst, String snd) {
    return Row(
      children: <Widget>[
        Text(
          "•",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'SFPro',
              fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 4),
        rideText(fst, 15, Colors.black),
        rideText(snd, 10, Colors.grey)
      ],
    );
  }

  Widget descriptionRow(BuildContext context, String fst, String snd) {
    return Row(
      children: <Widget>[
        SizedBox(width: 4),
        rideText(fst, 10, Colors.grey),
        SizedBox(width: 10),
        rideText(snd, 10, Colors.grey)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> text = [
      "Uris Hall",
      "Gates Hall",
      "Statler Hall",
      "Uris Hall"
    ];
    List<String> actionText = [
      "Dropoff Passenger 1",
      "Pickup Passenger 2",
      "Dropoff Passenger 2",
      "Expected Dropoff"
    ];
    List<String> locText = [
      "109 Tower Rd, Ithaca, NY 14850",
      "107 Hoy Rd, Ithaca, NY 14853",
      "7 East Ave, Ithaca, NY 14853",
      "109 Tower Rd, Ithaca, NY 14850"
    ];
    List<String> timeText = [
      "3:20 PM",
      "3:15 PM",
      "ETA 3:18 PM",
      "ETA 3:19 PM"
    ];
    return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 2, left: 2, right: 2),
            child: Column(
              children: <Widget>[
                titleRow(context, text[0], actionText[0]),
                descriptionRow(context, locText[0], timeText[0]),
                titleRow(context, text[1], actionText[1]),
                descriptionRow(context, locText[1], timeText[1]),
                titleRow(context, text[2], actionText[2]),
                descriptionRow(context, locText[2], timeText[2]),
                titleRow(context, text[3], actionText[3]),
                descriptionRow(context, locText[3], timeText[3]),
              ],
            )));
  }
}