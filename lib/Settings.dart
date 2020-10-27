import 'dart:ui';
import 'package:carriage_rider/AuthProvider.dart';
import 'package:carriage_rider/Upcoming.dart';
import 'package:carriage_rider/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'RiderProvider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 3;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 8;

    if (riderProvider.hasInfo()) {
      // String phoneNumber = riderProvider.info.phoneNumber;
      String phoneNumber = "9199710670";
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
                  padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 8.0),
                  child: Text('Settings',
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
                                        authProvider.googleSignIn.currentUser
                                            .displayName,
                                        style: TextStyle(
                                          fontSize: 20,
                                        )),
                                  ]),
                              Positioned(
                                child: Text(fPhoneNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).accentColor,
                                    )),
                                top: 25,
                              ),
                              Positioned(
                                child: Text(
                                    authProvider.googleSignIn.currentUser.email,
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
                LocationsInfo("Locations"),
                SizedBox(height: 6),
                PrivacyLegalInfo(),
                SizedBox(height: 6),
                SignOutButton()
              ]),
        )),
      );
    } else {
      return SafeArea(child: Center(child: CircularProgressIndicator()));
    }
  }
}

class SelectionController<T> {
  final List<String> options;
  Set<String> selected;
  SelectionController(this.options, this.selected);
}

class LocationsSelector extends StatefulWidget {
  final SelectionController<String> controller;

  LocationsSelector(this.controller);

  @override
  State<LocationsSelector> createState() {
    return LocationsSelectorState();
  }
}

class LocationsSelectorState extends State<LocationsSelector> {
  @override
  Widget build(BuildContext context) {
    List<String> options = widget.controller.options;
    Set<String> selected = widget.controller.selected;
    return ListView.separated(
        itemCount: options.length,
        itemBuilder: (context, index) {
          String id = options[index];
          String name = options[index];
          return FlatButton(
              color: selected.contains(id) ? Colors.grey : Colors.white,
              onPressed: () {
                setState(() {
                  if (selected.contains(id)) {
                    selected.remove(id);
                  } else {
                    selected.add(id);
                  }
                });
              },
              child: Text(name));
        },
        separatorBuilder: (context, index) => Divider(color: Colors.black));
  }
}

class LocationsInfo extends StatelessWidget {
  LocationsInfo(this.title);

  Widget _addressEditDialog(BuildContext context) {
    RiderProvider riderProvider =
        Provider.of<RiderProvider>(context, listen: false);
    final controller = TextEditingController(text: riderProvider.info.address);
    return new AlertDialog(
      title: const Text('Home address'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[TextField(controller: controller)],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Submit'),
            textColor: Colors.black),
      ],
    );
  }

  Widget _favoritesEditDialog(BuildContext context) {
    RiderProvider riderProvider =
        Provider.of<RiderProvider>(context, listen: false);
    Set<String> picked = Set<String>();
    picked.add("hi");
    final controller = SelectionController<String>(
        ["hi", 'these', 'are', 'test', 'values'], picked);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, controller.selected);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: PageTitle(title: 'Favorite Locations'),
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        body: LocationsSelector(controller),
      ),
    );
  }

  //
  void _editAddress(BuildContext context) async {
    RiderProvider riderProvider =
        Provider.of<RiderProvider>(context, listen: false);
    String res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _addressEditDialog(context);
      },
    );
    if (res == null) return;

    riderProvider.setAddress(AppConfig.of(context),
        Provider.of<AuthProvider>(context, listen: false), res);
  }

  void _editFavorites(BuildContext context) async {
    RiderProvider riderProvider =
        Provider.of<RiderProvider>(context, listen: false);

    Set<String> res = await Navigator.push(
        context, MaterialPageRoute(builder: _favoritesEditDialog));
    assert(res != null);

    riderProvider.setFavoriteLocations(AppConfig.of(context),
        Provider.of<AuthProvider>(context, listen: false), res.toList());
  }

  final String title;
  Widget infoRow(BuildContext context, IconData icon, String text,
      void Function() onEditPressed) {
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
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
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
                  Text(title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(children: [
                        infoRow(
                            context,
                            Icons.person_outline,
                            riderProvider.info.address,
                            () => _editAddress(context)),
                        Divider(height: 0, color: Colors.black),
                        infoRow(context, Icons.accessible, "Add Favorites",
                            () => _editFavorites(context))
                      ]))
                ])));
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
                                fontSize: 18, fontWeight: FontWeight.bold)),
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
                    fontSize: 16,
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
    List<String> headings = ["Email Preferences", "Privacy", "Legal"];
    final List<String> subText = [
      "Set what email you want to receive",
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
