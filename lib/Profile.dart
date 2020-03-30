import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'Login.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Padding(
          padding: EdgeInsets.only(left: 24.0, top: 10.0, bottom: 8.0),
          child:
              Text('Your Profile', style: Theme.of(context).textTheme.headline),
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
                            backgroundImage: _image == null
                                ? NetworkImage(
                                    imageUrl,
                                  )
                                : FileImage(_image),
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
                                onPressed: getImage,
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
                          //crossAxisAlignment: CrossAxisAlignment.end,
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
        AccountInfo(),
        SizedBox(height: 6),
        PersonalInfo(),
      ]),
    );
  }
}

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
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
    final List<IconData> icons = new List();
    icons.add(Icons.mail_outline);
    icons.add(Icons.phone);
    final List<String> tempText = new List();
    tempText.add(email);
    tempText.add("Add your number");

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
                    itemCount: icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return infoRow(context, icons[index], tempText[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0,
                      );
                    })
              ],
            )));
  }
}

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
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
    final List<IconData> icons = new List();
    icons.add(Icons.person_outline);
    icons.add(Icons.accessible);
    final List<String> tempText = new List();
    tempText.add("How should we address you?");
    tempText.add("Any accessiblility assistance?");
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
                Text('Personal Info',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return infoRow(context, icons[index], tempText[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0,
                      );
                    })
              ],
            )));
  }
}
