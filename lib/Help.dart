import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Help extends StatefulWidget {
  Help({Key key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Schedule',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: 'SFPro'),
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
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Padding(
              padding: EdgeInsets.only(left: 18.0, top: 10.0, bottom: 8.0),
              child: Text('Help', style: Theme.of(context).textTheme.headline5),
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  notificationRow(context, Icons.info_outline, "Using the app"),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // add information when designs update
                      ]),
                  InkWell(
                      child: notificationRow(
                          context, Icons.library_books, "CULift Guidelines"),
                      onTap: () => UrlLauncher.launch(
                          'https://sds.cornell.edu/accommodations-services/transportation/culift-guidelines')),
                  notificationRow(context, Icons.mail_outline, "Contact Us"),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        infoText(context, 'Student Disability Services:'),
                        infoText(context, '607-254-4545, culift@cornell.edu'),
                        SizedBox(height: 20),
                        //This information is from Bryan
                        infoText(context,
                            'Questions about scheduled rides can be made by calling the CULift dispatcher at: (607) 254-8293 or '
                                'by emailing culift@cornell.edu before 3:45pm or (for night rides) by calling (607) 229-6010 '
                                'after 3:45pm'),
                      ]),
                ],
              ),
            )
          ]),
        ));
  }

  Widget infoText(BuildContext context, String text) {
    return Padding(
        padding: EdgeInsets.only(left: 20),
        child: Flexible(
            child: Text(text,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black, fontSize: 15, fontFamily: 'SFPro'))));
  }

  Widget notificationRow(BuildContext context, IconData icon, String text) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 5, left: 5),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              child: Icon(icon),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ));
  }
}
