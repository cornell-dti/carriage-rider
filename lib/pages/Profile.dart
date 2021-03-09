import 'dart:io';
import 'dart:ui';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/pages/Upcoming.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:flutter/rendering.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import '../providers/RiderProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;

  @override
  void initState() {
    super.initState();
  }

  Future _getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _editEmail(context) {}

  void _editNumber(context) {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => ProfileNumber()));
  }

  void _editPronouns(context) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => ProfilePronouns()));
  }

  @override
  Widget build(context) {
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
          '-' +
          phoneNumber.substring(3, 6) +
          '-' +
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
                padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 8.0),
                child: Text('Your Profile',
                    style: CarriageTheme.largeTitle),
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
                                    _image == null
                                        ? authProvider
                                            .googleSignIn.currentUser.photoUrl
                                        : Image.file(_image),
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
                                      onPressed: () {
                                        _getImage();
                                      },
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
                          clipBehavior: Clip.none,
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
                                                  EditProfileName(
                                                      riderProvider.info)));
                                    },
                                  )
                                ]),
                            Positioned(
                              child:
                                  Text('Joined ' + riderProvider.info.joinDate,
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
              ProfileInfo('Account Info', [
                Icons.mail_outline,
                Icons.phone
              ], [
                riderProvider.info.email,
                fPhoneNumber == null ? 'Add your number' : fPhoneNumber
              ], [
                () => _editEmail(context),
                () => _editNumber(context)
              ]),
              SizedBox(height: 6),
              ProfileInfo('Personal Info', [
                Icons.person_outline,
              ], [
                riderProvider.info.pronouns == null
                    ? 'How should we address you?'
                    : riderProvider.info.pronouns
              ], [
                () => _editPronouns(context)
              ]),
              SizedBox(height: 120),
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
  ProfileInfo(this.title, this.icons, this.fields, this.callback);

  final String title;
  final List<IconData> icons;
  final List<String> fields;
  final List<Function> callback;

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  Widget infoRow(
      context, IconData icon, String text, void Function() onEditPressed) {
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
              onPressed: onEditPressed,
            )
          ],
        ));
  }

  @override
  Widget build(context) {
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
                Text(widget.title, style: CarriageTheme.title3),
                ListView.separated(
                    padding: EdgeInsets.all(2),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.icons.length,
                    itemBuilder: (context, int index) {
                      return infoRow(context, widget.icons[index],
                          widget.fields[index], widget.callback[index]);
                    },
                    separatorBuilder: (context, int index) {
                      return Divider(height: 0, color: Colors.black);
                    })
              ],
            )));
  }
}

class EditProfileName extends StatefulWidget {
  EditProfileName(this.rider);

  final Rider rider;

  @override
  _EditProfileNameState createState() => _EditProfileNameState();
}

class _EditProfileNameState extends State<EditProfileName> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();

  final titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 25,
  );

  @override
  Widget build(context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    String _firstName = widget.rider.firstName;
    String _lastName = widget.rider.lastName;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      child: Text('Cancel', style: CarriageTheme.cancelStyle),
                      onTap: () {
                        Navigator.pop(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Profile()));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child:
                        Text('How should we address you?', style: titleStyle),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        initialValue: riderProvider.info.firstName,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onSaved: (input) {
                          setState(() {
                            _firstName = input;
                          });
                        },
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        onFieldSubmitted: (value) =>
                            FocusScope.of(context).nextFocus()),
                    SizedBox(height: 20.0),
                    TextFormField(
                        initialValue: riderProvider.info.lastName,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onSaved: (input) {
                          setState(() {
                            _lastName = input;
                          });
                        },
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                    SizedBox(height: 10.0)
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(children: <Widget>[
                Flexible(
                    child: Text(
                        'By continuing, I accept the Terms of Services and Privacy Policies',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[500])))
              ]),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        height: 45.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              riderProvider.setNames(AppConfig.of(context),
                                  authProvider, _firstName, _lastName);
                              Navigator.pop(context);
                            }
                          },
                          elevation: 3.0,
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text('Done'),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}

class ProfilePronouns extends StatefulWidget {
  @override
  _ProfilePronounsState createState() => _ProfilePronounsState();
}

class _ProfilePronounsState extends State<ProfilePronouns> {
  int selectedRadio = 0;

  String pronouns = '';

  setPronouns(String pronoun) {
    pronouns = pronoun;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  final titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 25,
  );

  @override
  Widget build(context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: InkWell(
                    child: Text('Cancel', style: CarriageTheme.cancelStyle),
                    onTap: () {
                      Navigator.pop(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Profile()));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0),
            Row(
              children: <Widget>[
                Flexible(child: Text('Share your pronouns', style: titleStyle))
              ],
            ),
            SizedBox(height: 15.0),
            Row(children: <Widget>[
              Flexible(
                  child: Text(
                      'Help us get better at addressing you by selecting your pronouns',
                      style: TextStyle(fontSize: 15, color: Colors.grey)))
            ]),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RadioListTile(
                  title: Text('They/Them/Theirs'),
                  value: 1,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                    setPronouns('They/Them/Theirs');
                  },
                ),
                RadioListTile(
                  title: Text('She/Her/Hers'),
                  value: 2,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                    setPronouns('She/Her/Hers');
                  },
                ),
                RadioListTile(
                  title: Text('He/Him/His'),
                  value: 3,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                    setPronouns('He/Him/His');
                  },
                ),
                RadioListTile(
                  title: Text('Others'),
                  value: 4,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                    setPronouns('Others');
                  },
                ),
                RadioListTile(
                  title: Text('Prefer not to say'),
                  value: 5,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                    setPronouns('');
                  },
                ),
              ],
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: 45.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      child: RaisedButton(
                        onPressed: () {
                          riderProvider.setPronouns(
                              AppConfig.of(context), authProvider, pronouns);
                          Navigator.pop(context, false);
                        },
                        elevation: 3.0,
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text('Done'),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileNumber extends StatefulWidget {
  ProfileNumber({Key key}) : super(key: key);

  @override
  _ProfileNumberState createState() => _ProfileNumberState();
}

class _ProfileNumberState extends State<ProfileNumber> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  TextEditingController currentCtrl = TextEditingController();
  TextEditingController newCtrl = TextEditingController();

  Widget _currentNumberField() {
    return Container(
        margin: EdgeInsets.all(20),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: currentCtrl,
          focusNode: focusNode,
          decoration: InputDecoration(
              labelText: 'Current Phone Number',
              labelStyle: TextStyle(color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder()),
          textInputAction: TextInputAction.next,
          validator: (input) {
            if (input.isEmpty) {
              return 'Please enter your current phone number';
            }
            return null;
          },
          style: TextStyle(color: Colors.black, fontSize: 15),
          onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
        ));
  }

  Widget _newNumberField() {
    return Container(
        margin: EdgeInsets.all(20),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: newCtrl,
          decoration: InputDecoration(
              labelText: 'New Phone Number',
              labelStyle: TextStyle(color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder()),
          textInputAction: TextInputAction.done,
          validator: (input) {
            if (input.isEmpty) {
              return 'Please enter your new phone number';
            }
            return null;
          },
          style: TextStyle(color: Colors.black, fontSize: 15),
        ));
  }

  @override
  Widget build(context) {
    //RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    //AuthProvider authProvider = Provider.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: PageTitle(title: 'Profile'),
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: SafeArea(
            child: Container(
          color: Colors.white,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 24.0, top: 10.0, bottom: 8.0),
                    child: Text('Your Number',
                        style: CarriageTheme.title1),
                  ),
                )),
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Text(
                              'For security, please enter your current phone number and then then number you want to change it to.',
                              style: TextStyle(fontSize: 15)),
                        ),
                        SizedBox(height: 10.0),
                        _currentNumberField(),
                        _newNumberField(),
                        SizedBox(height: 10.0)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80),
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.only(
                            left: 30,
                          ),
                          child: Text(
                              'By continuing, you may receive a SMS for verification. Message and data rates apply.',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                        )))),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          height: 45.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => NumberVerify(
                                            number: newCtrl.text)));
                              }
                            },
                            elevation: 3.0,
                            color: Colors.black,
                            textColor: Colors.white,
                            child: Text('Verify New Number'),
                          ),
                        ),
                      )),
                )
              ]),
        )));
  }
}

class NumberVerify extends StatefulWidget {
  final String number;

  NumberVerify({Key key, this.number}) : super(key: key);

  @override
  _NumberVerifyState createState() => _NumberVerifyState();
}

class _NumberVerifyState extends State<NumberVerify> {
  @override
  Widget build(context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: PageTitle(title: 'Profile'),
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: SafeArea(
            child: Container(
          color: Colors.white,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 24.0, top: 10.0, bottom: 8.0),
                    child: Text('Your Number',
                        style: CarriageTheme.title1),
                  ),
                )),
                Expanded(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        VerificationCode(
                          keyboardType: TextInputType.number,
                          length: 4,
                          autofocus: false,
                          underlineColor: Colors.green,
                          onCompleted: (String value) {
                            riderProvider.setPhone(AppConfig.of(context),
                                authProvider, widget.number);
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Profile()));
                            Navigator.pop(context, false);
                          },
                          onEditing: (bool value) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                )),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(height: 20)),
                )
              ]),
        )));
  }
}
