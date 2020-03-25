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
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Your Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.bold),
                      )
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
                            top: SizeConfig.safeBlockHorizontal * 3,
                            left: SizeConfig.safeBlockHorizontal * 7,
                          ),
                          child: Text(
                            "Ride Status",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    orderTimeline()
                  ],
                )),
            flex: 6,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
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
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
                  child: MaterialButton(
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
                  )),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: MaterialButton(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () {},
                )),
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
          timelineRow("You are on the way!", ""),
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
              Container(
                width: 18,
                height: 18,
                decoration: new BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 3,
                height: 50,
                decoration: new BoxDecoration(
                  color: Colors.green,
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
              Text('${title}\n ${subTile}',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  Widget timelineLastRow(String title, String subTile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: new BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
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
              Text('${title}\n ${subTile}',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
