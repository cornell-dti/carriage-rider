import 'dart:ui';
import 'package:carriage_rider/pages/Upcoming.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24.0, top: 10.0, bottom: 8.0),
                child: Text('Notifications',
                    style: Theme.of(context).textTheme.headline4),
              ),
              Detail(),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 5,
              )
            ]),
      )
    );
  }
}

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  List<Color> colors = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.red,
    Colors.black,
    Colors.red
  ];

  List<IconData> icons = [
    Icons.directions_car,
    Icons.check,
    Icons.directions_car,
    Icons.edit,
    Icons.directions_car,
    Icons.cancel
  ];

  List<String> text = [
    "Your driver is on the way! Wait outside to meet your driver.",
    "Your ride on MM/DD/YYYY has been confirmed",
    "How was your ride with Jennifer? Leave a review so we can improve our service",
    "Your ride information has been edited by the admin. Please review your ride info.",
    "Your driver is here! Meet your driver at the pickup point.",
    "Your driver cancelled the ride because the driver was unable to find you."
  ];

  Widget notificationRow(BuildContext context, Color color, IconData icon, String text) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 22,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: color,
                foregroundColor: Colors.white,
                child: Icon(icon),
              ),
            ),
            SizedBox(width: 19),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
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
              children: <Widget>[
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return notificationRow(context, colors[index], icons[index], text[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0, color: Colors.white,
                      );
                    }
                )
              ],
            )));
  }
}
