import 'dart:ui';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Rider.dart';
import 'app_config.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<Rider> fetchRider(String id) async {
    final response =
        await http.get(AppConfig.of(context).baseUrl + "/riders/" + id);

    if (response.statusCode == 200) {
      return Rider.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load rider info');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);
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
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<Rider>(
            future: fetchRider(authProvider.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String phoneNumber = "+1 " +
                    snapshot.data.phoneNumber.substring(0, 3) +
                    "-" +
                    snapshot.data.phoneNumber.substring(3, 6) +
                    "-" +
                    snapshot.data.phoneNumber.substring(6, 10);
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                        EdgeInsets.only(left: 20.0, top: 5.0, bottom: 8.0),
                        child: Text('Settings',
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
                                        padding: EdgeInsets.only(
                                            bottom: _picDiameter * 0.05),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            authProvider.googleSignIn.currentUser
                                                .photoUrl,
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
                                          Text(
                                              authProvider.googleSignIn
                                                  .currentUser.displayName,
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                        ]),
                                    Positioned(
                                      child: Text(phoneNumber,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).accentColor,
                                          )),
                                      top: 25,
                                    ),
                                    Positioned(
                                      child: Text(
                                          authProvider
                                              .googleSignIn.currentUser.email,
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
                      LocationsInfo(
                          "Locations",
                          [Icons.person_outline, Icons.accessible],
                          ["Add Home", "Add Favorites"]),
                      SizedBox(height: 6),
                      PrivacyLegalInfo(),
                      SizedBox(height: 6),
                      SignOutButton()
                    ]);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        )
      ),
    );
  }
}

class LocationsInfo extends StatefulWidget {
  LocationsInfo(this.title, this.icons, this.fields);

  final String title;
  final List<IconData> icons;
  final List<String> fields;

  @override
  _LocationsInfoState createState() => _LocationsInfoState();
}

class _LocationsInfoState extends State<LocationsInfo> {
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
    AuthProvider authProvider = Provider.of(context);
    return SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 9,
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
            authProvider.signOut();
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ));
  }
}
