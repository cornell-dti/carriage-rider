import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Login.dart';
import 'Rider.dart';

Future<Rider> fetchRider() async {
  final response = await http.get("http://10.0.2.2:3001");

  if (response.statusCode == 200) {
    return Rider.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load rider info');
  }
}

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Rider> user;

  @override
  void initState() {
    super.initState();
    user = fetchRider();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 2;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 24.0, top: 10.0, bottom: 8.0),
            child: Text('Your Profile',
                style: Theme.of(context).textTheme.headline),
          ),
          Container(
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
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: _picMarginLR,
                        right: _picMarginLR,
                        top: _picMarginTB,
                        bottom: _picMarginTB),
                    child: Stack(
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(bottom: _picDiameter * 0.05),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                imageUrl,
                              ),
                              radius: _picRadius,
                            )),
                        Positioned(
                            child: Container(
                              height: _picBtnDiameter,
                              width: _picBtnDiameter,
                              child: FittedBox(
                                child: FloatingActionButton(
                                  backgroundColor: Colors.black,
                                  child: Icon(Icons.add, size: _picBtnDiameter),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            left: _picDiameter * 0.61,
                            top: _picDiameter * 0.66)
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )),
                              IconButton(
                                icon: Icon(Icons.edit, size: 20),
                                onPressed: () {},
                              )
                            ]),
                        Positioned(
                          child: Text("Joined 03/2020",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).accentColor,
                              )),
                          top: 45,
                        )
                      ],
                    ))
              ])),
          SizedBox(height: 6),
          ProfileInfo("Account Info", [Icons.mail_outline, Icons.phone],
              [email, "Add your number"]),
          SizedBox(height: 6),
          ProfileInfo("Personal Info", [Icons.person_outline, Icons.accessible],
              ["How should we address you?", "Any accessiblility assistance?"]),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatefulWidget {
  ProfileInfo(this.title, this.icons, this.fields);

  final String title;
  final List<IconData> icons;
  final List<String> fields;

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  Widget infoRow(BuildContext context, IconData icon, String text) {
    double paddingTB = 10;
    return Padding(
        padding: EdgeInsets.only(top: paddingTB, bottom: paddingTB),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: 19),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
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
                Text(widget.title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ListView.separated(
                    padding: EdgeInsets.all(2),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return infoRow(
                          context, widget.icons[index], widget.fields[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 0, color: Colors.black);
                    })
              ],
            )));
  }
}
