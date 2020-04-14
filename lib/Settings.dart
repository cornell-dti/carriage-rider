import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Login.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 3;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 8;

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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Padding(
          padding: EdgeInsets.only(left: 24.0, top: 10.0, bottom: 8.0),
          child: Text('Settings', style: Theme.of(context).textTheme.headline),
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
                          padding: EdgeInsets.only(bottom: _picDiameter * 0.05),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              imageUrl,
                            ),
                            radius: _picRadius,
                          )),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Row(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(name,
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ]),
                      Positioned(
                        child: Text("+1 657-500-1311",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor,
                            )),
                        top: 25,
                      ),
                      Positioned(
                        child: Text(email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor,
                            )),
                        top: 45,
                      )
                    ],
                  )),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        alignment: Alignment.topRight,
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {},
                      )))
            ])),
        SizedBox(height: 6),
        Locations(),
        SizedBox(height: 6),
        PrivacyLegalInfo(),
        SizedBox(height: 6),
        SignOutButton()
      ]),
    );
  }
}

class Locations extends StatefulWidget {
  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  Widget infoRow(BuildContext context, IconData icon, String text) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
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
    List<IconData> icons = [Icons.person_outline, Icons.accessible];
    List<String> text = ["Add Home", "Add Favorites"];

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
                Text('Locations',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return infoRow(context, icons[index], text[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: Colors.black);
                    })
              ],
            )));
  }
}

class PrivacyLegalInfo extends StatefulWidget {
  @override
  _PrivacyLegalInfoState createState() => _PrivacyLegalInfoState();
}

class _PrivacyLegalInfoState extends State<PrivacyLegalInfo> {
  Widget infoRow(BuildContext context, String heading, String text) {
    return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(heading,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                        child: IconButton(
                      alignment: Alignment.topRight,
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    )),
                  ],
                )),
            SizedBox(
              height: 2,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<String> headings = ["Privacy", "Legal"];
    final List<String> subText = [
      "Choose what data you share with us",
      "Terms of service \& Privacy Policy"
    ];

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
                ListView.separated(
                    padding: EdgeInsets.all(2),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: subText.length,
                    itemBuilder: (BuildContext context, int index) {
                      return infoRow(context, headings[index], subText[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 0, color: Colors.white);
                    })
              ],
            )));
  }
}

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        height: 80,
        child: MaterialButton(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.exit_to_app),
              SizedBox(width: 10),
              Text(
                'Sign out',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black, fontFamily: "SFPro", fontSize: 15),
              )
            ],
          ),
          onPressed: () {
            googleSignIn.signOut();
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ));
  }
}
