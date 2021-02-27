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
              child: Text('Help', style: Theme
                  .of(context)
                  .textTheme
                  .headline5),
            ),
            Container(
              color: Colors.white,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 18, bottom: 5),
                    child: Text(
                      'Contact CULift',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 18, bottom: 5),

                      child: Text(
                        'Did your driver miss your ride? Or need any immediate '
                            'assistance? Contact CULift for help',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  infoRow(
                      context, Icons.phone, "###-###-####", _launchPhoneURL),
                  Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Divider(
                      height: 0,
                      color: Colors.black,
                    ),
                  ),
                  infoRow(context, Icons.mail_outline, "culift@cornell.edu",
                      _launchMailURL),
                ],
              ),
            )
          ]),
        ));
  }

  void _launchPhoneURL() async {
    String number = "13232315234";
    String url = "tel://$number";
    if (await UrlLauncher.canLaunch(url)) {
      await UrlLauncher.launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void _launchMailURL() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'culift@cornell.edu',
    );

    String url = params.toString();
    if (await UrlLauncher.canLaunch(url)) {
      await UrlLauncher.launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Widget infoRow(BuildContext context, IconData icon, String text,
      void Function() onPressed) {
    return Padding(
        padding: EdgeInsets.only(left: 18),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: 19),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[500],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: onPressed,
            )
          ],
        ));
  }
}
