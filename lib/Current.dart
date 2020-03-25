import 'dart:ui';
import 'Login.dart';
import 'package:flutter/material.dart';

class Current extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            ),
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
                        SizedBox(
                          width: 20,
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
            flex: 2,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
