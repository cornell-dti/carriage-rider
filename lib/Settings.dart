import 'dart:ui';
import 'package:flutter/material.dart';
import 'Login.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Schedule',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: 'SFPro'),
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
                                  "Settings",
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
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "+1 657-500-1311",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: 'SFPro',
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: 'SFPro',
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 20,
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
                    padding: EdgeInsets.only(
                        left: 15, right: 32, top: 10, bottom: 32),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                              child: Text(
                                "Locations",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFPro',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ]),
                        SizedBox(
                          height: 5,
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
                                  Icons.home,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Add Home",
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontFamily: "SFPro",
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 194,
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
                                  Icons.star_border,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Add Favorites",
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontFamily: "SFPro",
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 170,
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
                    padding: EdgeInsets.only(
                        left: 15, right: 32, top: 10, bottom: 32),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                              child: Text(
                                "Privacy",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFPro',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ]),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Choose what data you share with us",
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontFamily: "SFPro",
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 50,
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                              child: Text(
                                "Legal",
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
                                  width: 10,
                                ),
                                Text(
                                  "Terms of service & Private Policy",
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontFamily: "SFPro",
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 75,
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
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.exit_to_app),
                            SizedBox(width: 10),
                            Text(
                              'Sign out',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "SFPro",
                                  fontSize: 15),
                            )
                          ],
                        ),
                        onPressed: () {
                          googleSignIn.signOut();
                        },
                      )),
                ],
              ),
            ),
          ],
        ));
  }
}
