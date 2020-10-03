import 'dart:ui';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:flutter/rendering.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import 'RiderProvider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 2;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;

    if (riderProvider.hasInfo()) {
      String phoneNumber = riderProvider.info.phoneNumber;
      String fPhoneNumber = phoneNumber.substring(0, 3) +
          "-" +
          phoneNumber.substring(3, 6) +
          "-" +
          phoneNumber.substring(6, 10);
      return Scaffold(
        appBar: AppBar(
          title: PageTitle(title: 'Schedule'),
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
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24.0, top: 10.0, bottom: 8.0),
                child: Text('Your Profile',
                    style: Theme.of(context).textTheme.headline5),
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
                  child: SingleChildScrollView(
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
                                    authProvider
                                        .googleSignIn.currentUser.photoUrl,
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
                                      child: Icon(Icons.add,
                                          size: _picBtnDiameter),
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
                                  Text(riderProvider.info.fullName(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfile(riderProvider.info)));
                                    },
                                  )
                                ]),
                            Positioned(
                              child:
                                  Text("Joined " + riderProvider.info.joinDate,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).accentColor,
                                      )),
                              top: 45,
                            )
                          ],
                        ))
                  ]))),
              SizedBox(height: 6),
              ProfileInfo("Account Info", [Icons.mail_outline, Icons.phone],
                  [riderProvider.info.email, fPhoneNumber]),
              SizedBox(height: 6),
              ProfileInfo("Personal Info", [
                Icons.person_outline,
                Icons.accessible
              ], [
                riderProvider.info.pronouns,
                "Any accessiblility assistance?"
              ]),
              SizedBox(height: 6),
            ],
          )),
        ),
      );
    } else {
      return SafeArea(child: Center(child: CircularProgressIndicator()));
    }
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

class EditProfile extends StatefulWidget {
  EditProfile(this.rider);

  final Rider rider;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    String _firstName = widget.rider.firstName;
    String _lastName = widget.rider.lastName;
    String _phoneNumber = widget.rider.phoneNumber;
    // TODO: implement build
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: 24.0, top: 10.0, bottom: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Edit Profile', style: Theme.of(context).textTheme.headline5),
        SizedBox(height: 20),
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('First Name',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextFormField(
                  decoration: InputDecoration(icon: Icon(Icons.person)),
                  initialValue: _firstName,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please enter your first name.';
                    }
                    return null;
                  },
                  onSaved: (input) {
                    setState(() {
                      _firstName = input;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Last Name',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextFormField(
                  decoration: InputDecoration(icon: Icon(Icons.person)),
                  initialValue: _lastName,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please enter your last name.';
                    }
                    return null;
                  },
                  onSaved: (input) {
                    setState(() {
                      _lastName = input;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Phone Number',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextFormField(
                  decoration: InputDecoration(icon: Icon(Icons.phone)),
                  initialValue: _phoneNumber,
                  keyboardType: TextInputType.number,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please enter your phone number.';
                    }
                    return null;
                  },
                  onSaved: (input) {
                    setState(() {
                      _phoneNumber = input;
                    });
                  },
                ),
              ],
            )),
        SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          RaisedButton(
            child: Text("Save"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                riderProvider.updateRider(AppConfig.of(context),
                    authProvider, _firstName, _lastName, _phoneNumber);
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(width: 30),
          RaisedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              })
        ])
      ]),
    ));
  }
}
