import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Login.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule',
          style:
              TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'SFPro'),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Your Profile",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 32, right: 32, top: 32),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                          height: 90,
                          width: 90,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              imageUrl,
                            ),
                            radius: 60,
                            backgroundColor: Colors.transparent,
                          )),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Joined 06/2019",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: 'SFPro',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
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
                                width: 4,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 32, top: 10, bottom: 32),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Text(
                              "Account Info",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ]),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.email,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontFamily: "SFPro",
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: 140,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        height: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Add your number",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontFamily: "SFPro",
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: 145,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
                                width: 4,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 32, top: 10, bottom: 32),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Text(
                              "Personal Info",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ]),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.person_outline,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "How should we address you?",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontFamily: "SFPro",
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: 59,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        height: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.accessible,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Any accessibility assistance?",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontFamily: "SFPro",
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: 59,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
                                width: 4,
                              ),
                            ],
                          ),
                        ],
                      ),
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
