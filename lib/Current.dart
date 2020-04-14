import 'dart:ui';
import 'Login.dart';
import 'package:flutter/material.dart';
import 'size_config.dart';

class Current extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule',
          style:
              TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SFPro'),
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
      body: Column(
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
                          child: Text(
                            "Current Ride",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold),
                          )),
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
                            child: Text(
                              "Ride Status",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontFamily: 'SFPro',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      orderTimeline()
                    ],
                  )),
            ),
            flex: 8,
          ),
          Expanded(
            child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(2),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: SizeConfig.safeBlockHorizontal * 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig.safeBlockHorizontal * 7,
                            ),
                          ),
                          SizedBox(
                              height: 50,
                              width: 50,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  imageUrl,
                                ),
                                radius: 20,
                                backgroundColor: Colors.transparent,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFPro',
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.phone),
                                    SizedBox(width: 10),
                                    Text(
                                      "+1 657-500-1311",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'SFPro',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: SizeConfig.safeBlockHorizontal * 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2),
                      color: Colors.grey[100],
                    ),
                  ],
                )),
            flex: 2,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: SizedBox(
                  width: double.maxFinite,
                  height: 20,
                  child: RepeatRideButton()),
            ),
            flex: 2,
          ),
        ],
      ),
    );
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
                height: 160,
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
        bottom: SizeConfig.safeBlockHorizontal * 7,
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

  Widget rideText (String text, double size, Color color) {
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
