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
            flex: 10,
          ),
          Expanded(
            child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(3),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: SizeConfig.safeBlockHorizontal * 3,
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
                      padding: EdgeInsets.all(3),
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

  Widget timelineRow(String title, String subTile) {
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
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    border: new Border.all(
                        color: Colors.white,
                        width: 6.0,
                        style: BorderStyle.solid),
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
              ),
              Container(
                width: 3,
                height: 50,
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
              Text('$title\n $subTile',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 19,
                      color: Colors.black54)),
            ],
          ),
        ),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: new Border.all(
                        color: Colors.white,
                        width: 6.0,
                        style: BorderStyle.solid),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 30.0,
                      )
                    ],
                  ),
                  child: Text(
                    "",
                  ),
                ),
              ),
              Container(
                width: 3,
                height: 125,
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
              Row(
                children: <Widget>[
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[],
                  )),
                ],
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
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    border: new Border.all(
                        color: Colors.white,
                        width: 6.0,
                        style: BorderStyle.solid),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 30.0,
                      )
                    ],
                  ),
                  child: Text(
                    "",
                  ),
                ),
              ),
              Container(
                width: 3,
                height: 20,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
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
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$title\n $subTile',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 19,
                      color: Colors.black54)),
            ],
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
  Widget infoRow(BuildContext context, String textCenter, String textEnd) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Text(
              "•",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 2),
            Expanded(
              child: Text(
                textCenter,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).accentColor,
                ),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> text = new List();
    text.add("Uris Hall");
    text.add("Gates Hall");
    text.add("Statler Hall");
    text.add("Uris Hall");
    final List<String> tempText = new List();
    tempText.add("Dropoff Passenger 1");
    tempText.add("Pickup Passenger 2");
    tempText.add("Dropoff Passenger 2");
    tempText.add("Expected Dropoff");

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(15, 0, 0, 0),
                offset: Offset(0, 4.0),
                blurRadius: 10.0,
                spreadRadius: 1.0)
          ],
        ),
        child: Padding(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Account Info',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: text.length,
                    itemBuilder: (BuildContext context, int index) {
                      return infoRow(context, text[index], tempText[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 0, color: Colors.black);
                    })
              ],
            )));
  }
}

class Bullet extends Text {
  const Bullet(
    String data, {
    Key key,
    TextStyle style,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor,
    int maxLines,
    String semanticsLabel,
  }) : super(
          '• $data',
          key: key,
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
        );
}
