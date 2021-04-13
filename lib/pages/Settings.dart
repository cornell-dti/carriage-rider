import 'dart:ui';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/models/Location.dart';
import 'package:carriage_rider/pages/RidePage.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import '../providers/RiderProvider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(context) {
    AuthProvider authProvider = Provider.of(context);
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picRadius = _picDiameter / 3;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 8;

    if (riderProvider.hasInfo()) {
      String phoneNumber = riderProvider.info.phoneNumber;
      String fPhoneNumber = phoneNumber.substring(0, 3) +
          '-' +
          phoneNumber.substring(3, 6) +
          '-' +
          phoneNumber.substring(6, 10);
      return Scaffold(
        appBar: ScheduleBar(Colors.black, Theme.of(context).scaffoldBackgroundColor),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 8.0),
                  child: Text('Settings',
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
                            clipBehavior: Clip.none,
                            children: [
                              Row(
                                  //crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(riderProvider.info.fullName(),
                                        style: TextStyle(
                                          fontSize: 19,
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
                LocationsInfo('Locations'),
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
  final List<T> options;
  Set<T> selected;

  SelectionController(this.options, this.selected);
}

class LocationsSelector extends StatefulWidget {
  final SelectionController<Location> controller;

  LocationsSelector(this.controller);

  @override
  State<LocationsSelector> createState() {
    return LocationsSelectorState();
  }
}

class LocationsSelectorState extends State<LocationsSelector> {
  @override
  Widget build(context) {
    List<Location> options = widget.controller.options;
    Set<Location> selected = widget.controller.selected;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: options.length,
      itemBuilder: (context, index) {
        Location location = options[index];
        return SizedBox(
          height: 80,
          child: FlatButton(
              color: selected.contains(location) ? Colors.grey : Colors.white,
              onPressed: () {
                setState(() {
                  if (selected.contains(location)) {
                    selected.remove(location);
                  } else {
                    selected.add(location);
                  }
                });
              },
              child: Text(location.name)),
        );
      },
      // separatorBuilder: (context, index) => Divider(color: Colors.black)
    );
  }
}

class LocationsInfo extends StatelessWidget {
  LocationsInfo(this.title);

  Widget _addressEditDialog(context) {
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

  Widget _favoritesEditDialog(context, Map<String, Location> locations) {
    RiderProvider riderProvider =
        Provider.of<RiderProvider>(context, listen: false);
    Set<Location> picked = Set<Location>();
    riderProvider.info.favoriteLocations.forEach((e) {
      if (locations.containsKey(e)) picked.add(locations[e]);
    });
    final controller =
        SelectionController<Location>(locations.values.toList(), picked);
    // on pop, returns iterable of ids of selected locations
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, controller.selected.map((e) => e.id));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: PageTitle(title: 'Settings'),
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
  void _editAddress(context) async {
    RiderProvider riderProvider =
        Provider.of<RiderProvider>(context, listen: false);
    String res = await showDialog(
      context: context,
      builder: (context) {
        return _addressEditDialog(context);
      },
    );
    if (res == null) return;

    riderProvider.setAddress(AppConfig.of(context),
        Provider.of<AuthProvider>(context, listen: false), res);
  }

  void _editFavorites(context) async {
    RiderProvider riderProvider =
        Provider.of<RiderProvider>(context, listen: false);
    Map<String, Location> locations =
        locationsById(await fetchLocations(context));
    List<String> res = (await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    _favoritesEditDialog(context, locations))))
        .toList();
    assert(res != null);

    riderProvider.setFavoriteLocations(AppConfig.of(context),
        Provider.of<AuthProvider>(context, listen: false), res);
  }

  final String title;

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
                  Text(title, style: CarriageTheme.title3),
                  Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(children: [
                        infoRow(
                            context,
                            Icons.person_outline,
                            riderProvider.info.address,
                            () => _editAddress(context)),
                        Divider(height: 0, color: Colors.black),
                        infoRow(context, Icons.accessible, 'Add Favorites',
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
  Widget infoRow(context, String heading, String text) {
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
  Widget build(context) {
    List<String> headings = ['Email Preferences', 'Privacy', 'Legal'];
    final List<String> subText = [
      'Set what email you want to receive',
      'Choose what data you share with us',
      'Terms of service \& Privacy Policy'
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
                    itemBuilder: (context, int index) {
                      return infoRow(context, headings[index], subText[index]);
                    },
                    separatorBuilder: (context, int index) {
                      return Divider(height: 0, color: Colors.white);
                    })
              ],
            )));
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
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ));
  }
}
