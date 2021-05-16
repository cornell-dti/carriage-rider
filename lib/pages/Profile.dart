import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:carriage_rider/pages/Login.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:flutter/rendering.dart';
import 'dart:core';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/RiderProvider.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;

    Widget sectionDivider = Container(height: 6, color: Colors.grey[200]);

    void selectImage() async {
      ImagePicker picker = ImagePicker();
      PickedFile pickedFile = await picker.getImage(
          source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
      Uint8List bytes = await File(pickedFile.path).readAsBytes();
      String base64Image = base64Encode(bytes);
      riderProvider.updateRiderPhoto(AppConfig.of(context),
          Provider.of<AuthProvider>(context, listen: false), base64Image);
    }

    if (riderProvider.hasInfo()) {
      return Scaffold(
        appBar: ScheduleBar(
            Colors.black, Theme.of(context).scaffoldBackgroundColor),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 8.0),
                    child: Text('Your Profile', style: CarriageTheme.largeTitle),
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
                                      padding:
                                      EdgeInsets.only(bottom: _picDiameter * 0.05),
                                      child: Container(
                                        height: _picDiameter,
                                        width: _picDiameter,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: riderProvider.info.photoLink == null
                                                ? Image.asset(
                                              'assets/images/person.png',
                                              width: _picDiameter,
                                              height: _picDiameter,
                                              semanticLabel: 'your profile',
                                            )
                                                : Image.network(
                                              riderProvider.info.photoLink,
                                              fit: BoxFit.cover,
                                              semanticLabel: 'your profile',
                                              loadingBuilder:
                                                  (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child:
                                                    CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                        child: Container(
                                          height: _picBtnDiameter,
                                          width: _picBtnDiameter,
                                          child: FittedBox(
                                              child: Semantics(
                                                button: true,
                                                onTap: selectImage,
                                                label: 'Add Profile Picture',
                                                child: ExcludeSemantics(
                                                  child: FloatingActionButton(
                                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                                    backgroundColor: Colors.black,
                                                    child: Icon(Icons.add,
                                                        size: 32),
                                                    onPressed: selectImage,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        left: _picDiameter * 0.61,
                                        top: _picDiameter * 0.66)
                                  ],
                                )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(riderProvider.info.fullName(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  SizedBox(height: 4),
                                  Semantics(
                                    container: true,
                                    child: Text('Joined ' + riderProvider.info.joinDate,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).accentColor,
                                        )),
                                  )
                                ],
                              ),
                            )
                          ]))),
                  sectionDivider,
                  InfoGroup(
                    'Account Info',
                    [
                      InfoRow(
                          Icons.mail_outline,
                          riderProvider.info.email,
                          'Email'
                      ),
                      InfoRow(
                        Icons.phone,
                        riderProvider.info.phoneNumber,
                        'Phone number',
                        editPage: EditPhoneNumber(riderProvider.info.phoneNumber),
                        readDigits: true,
                      ),
                      InfoRow(
                        Icons.person,
                        riderProvider.info.firstName +
                            ' ' +
                            riderProvider.info.lastName,
                        'Name',
                        editPage: EditName(riderProvider.info.firstName,
                            riderProvider.info.lastName),
                      ),
                    ],
                  ),
                  sectionDivider,
                  TermsInfo(),
                  sectionDivider,
                  SignOutButton(),
                ],
              )),
        ),
      );
    } else {
      return SafeArea(child: Center(child: CircularProgressIndicator()));
    }
  }
}

class TermsInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void openGuidelines() async {
      String url = 'https://sds.cornell.edu/accommodations-services/transportation/culift-guidelines';
      if (await canLaunch(url)) {
        await launch(url);
      }
    }

    return Semantics(
      label: 'By using Carriage, you agree to follow CULift guidelines',
      link: true,
      onTap: () => openGuidelines(),
      child: ExcludeSemantics(
        child: Container(
          padding: EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('By using Carriage, you agree to follow',
                  style: CarriageTheme.body),
              Material(
                type: MaterialType.transparency,
                child: FlatButton(
                    onPressed: () => openGuidelines(),
                    child: Text(
                        'CULift guidelines',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        )
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArrowButton extends StatelessWidget {
  ArrowButton(this.page);

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.arrow_forward_ios, size: 20),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => page));
            },
          ),
        )
    );
  }
}

class InfoRow extends StatelessWidget {
  InfoRow(this.icon, this.text, this.semanticsLabel, {this.editPage, this.readDigits = false});

  final IconData icon;
  final String text;
  final String semanticsLabel;
  final Widget editPage;
  final bool readDigits; // for phone number screen reader format

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: editPage == null ? 16 : 8),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: 19),
            Expanded(
              child: Text(
                text,
                semanticsLabel: semanticsLabel + ': ' +
                    (readDigits ?  text.characters.fold('', (previousValue, element) => previousValue + ' ' + element) : text),
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromRGBO(74, 74, 74, 1),
                ),
              ),
            ),
            editPage != null ? Semantics(
                button: true,
                child: ArrowButton(editPage)
            ) : Container()
          ],
        ));
  }
}

class SettingRow extends StatelessWidget {
  SettingRow(this.title, this.description, this.page);

  final String title;
  final String description;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: title + ', ' + description,
      button: true,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: ExcludeSemantics(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontFamily: 'SFDisplay',
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(description,
                        style: TextStyle(
                            fontFamily: 'SFDisplay',
                            fontSize: 17,
                            color: CarriageTheme.gray1)),
                  ],
                ),
                Spacer(),
                ArrowButton(page)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoGroup extends StatelessWidget {
  InfoGroup(this.title, this.rows);

  final String title;
  final List<InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: TextStyle(
                        fontFamily: 'SFDisplay',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: rows.length,
                    itemBuilder: (BuildContext context, int index) {
                      return rows[index];
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(left: 40),
                          child: Container(
                            height: 1,
                            color: Color.fromRGBO(151, 151, 151, 1),
                          ));
                    })
              ],
            )));
  }
}

class EditName extends StatefulWidget {
  EditName(this.initialFirstName, this.initialLastName);

  final String initialFirstName;
  final String initialLastName;

  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  bool requestedUpdate = false;

  @override
  void initState() {
    super.initState();
    firstNameCtrl.text = widget.initialFirstName;
    lastNameCtrl.text = widget.initialLastName;
  }

  @override
  Widget build(BuildContext context) {
    RiderProvider userInfoProvider = Provider.of<RiderProvider>(context);
    FocusScopeNode focus = FocusScope.of(context);

    return Scaffold(
        body: LoadingOverlay(
          isLoading: requestedUpdate,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ProfileBackButton(),
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                  Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              autofocus: true,
                              controller: firstNameCtrl,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                focus.nextFocus();
                              },
                              decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(color: CarriageTheme.gray2),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)),
                                  suffixIcon: Semantics(
                                    button: true,
                                    container: true,
                                    label: 'Clear input for first name',
                                    child: ExcludeSemantics(
                                      child: IconButton(
                                        onPressed: firstNameCtrl.clear,
                                        icon: Icon(Icons.cancel_outlined,
                                            size: 16, color: Colors.black),
                                      ),
                                    ),
                                  )),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please enter your first name.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: lastNameCtrl,
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(color: CarriageTheme.gray2),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)),
                                  suffixIcon: Semantics(
                                    button: true,
                                    container: true,
                                    label: 'Clear input for last name',
                                    child: ExcludeSemantics(
                                      child: IconButton(
                                        onPressed: lastNameCtrl.clear,
                                        icon: Icon(Icons.cancel_outlined,
                                            size: 16, color: Colors.black),
                                      ),
                                    ),
                                  )),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please enter your last name.';
                                }
                                return null;
                              },
                            )
                          ])),
                  Spacer(),
                  Container(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          height: 50.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  setState(() {
                                    requestedUpdate = true;
                                  });
                                  userInfoProvider.setNames(
                                      AppConfig.of(context),
                                      Provider.of<AuthProvider>(context,
                                          listen: false),
                                      firstNameCtrl.text,
                                      lastNameCtrl.text);
                                  Navigator.pop(context);
                                }
                              },
                              elevation: 3.0,
                              color: Colors.black,
                              textColor: Colors.white,
                              child: Text('Update Name',
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold))),
                        ),
                      ))
                ])),
          ),
        ));
  }
}

class EditPhoneNumber extends StatefulWidget {
  EditPhoneNumber(this.initialPhoneNumber);

  final String initialPhoneNumber;

  @override
  _EditPhoneNumberState createState() => _EditPhoneNumberState();
}

class _EditPhoneNumberState extends State<EditPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberCtrl = TextEditingController();
  bool requestedUpdate = false;

  @override
  void initState() {
    super.initState();
    phoneNumberCtrl.text = widget.initialPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);

    return Scaffold(
        body: LoadingOverlay(
          isLoading: requestedUpdate,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ProfileBackButton(),
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                  Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        autofocus: true,
                        controller: phoneNumberCtrl,
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(color: CarriageTheme.gray2),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            suffixIcon: Semantics(
                              button: true,
                              container: true,
                              label: 'Clear input for phone number',
                              child: ExcludeSemantics(
                                child: IconButton(
                                  onPressed: phoneNumberCtrl.clear,
                                  icon: Icon(Icons.cancel_outlined,
                                      size: 16, color: Colors.black),
                                ),
                              ),
                            )),
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please enter your phone number.';
                          } else if (input.length != 10) {
                            return 'Phone number should be 10 digits.';
                          } else if (int.tryParse(input) == null) {
                            return 'Phone number should be all numbers.';
                          }
                          return null;
                        },
                      )),
                  Spacer(),
                  Container(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          height: 50.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  setState(() {
                                    requestedUpdate = true;
                                  });
                                  riderProvider.setPhone(
                                      AppConfig.of(context),
                                      Provider.of<AuthProvider>(context,
                                          listen: false),
                                      phoneNumberCtrl.text);
                                  Navigator.pop(context);
                                }
                              },
                              elevation: 3.0,
                              color: Colors.black,
                              textColor: Colors.white,
                              child: Text('Update Phone Number',
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold))),
                        ),
                      ))
                ])),
          ),
        ));
  }
}

class ProfileBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: ExcludeSemantics(
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  @override
  Widget build(context) {
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
                    color: Colors.black, fontFamily: 'SFPro', fontSize: 15),
              )
            ],
          ),
          onPressed: () {
            authProvider.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login())
            );
          },
        ));
  }
}
