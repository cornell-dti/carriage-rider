import 'dart:ui';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Contact extends StatefulWidget {
  Contact({Key key}) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ScheduleBar(Colors.black, Theme.of(context).scaffoldBackgroundColor),
        body: SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 8.0),
              child: Text('Contact', style: CarriageTheme.largeTitle),
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
                      style: CarriageTheme.title2,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 18, bottom: 15),

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
                      context, Icons.phone, '###-###-####', _launchPhoneURL),
                  Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Divider(
                      height: 0,
                      color: Colors.black,
                    ),
                  ),
                  infoRow(context, Icons.mail_outline, 'culift@cornell.edu',
                      _launchMailURL),
                ],
              ),
            )
          ]),
        ));
  }

  void _launchPhoneURL() async {
    String number = '13232315234';
    String url = 'tel://$number';
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
