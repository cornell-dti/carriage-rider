import 'dart:ui';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/widgets/ScheduleBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Contact extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ScheduleBar(Colors.black, Theme.of(context).scaffoldBackgroundColor),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 8.0),
                    child: Text('Contact CULift', style: CarriageTheme.largeTitle),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8),
                      PhoneNumberRow('Questions about scheduled rides can be made by calling the CULift dispatcher at:', '6072548293'),
                      ContactRow(Icons.mail, "If it's before 3:45pm, you can also send an email to:", 'culift@cornell.edu', 'mailto:culift@cornell.edu'),
                      PhoneNumberRow('For night rides after 3:45pm, call the CULift dispatcher at:', '6072296010'),
                    ],
                  ),
                )
              ]
          ),
        )
    );
  }
}

class ContactRow extends StatelessWidget {
  ContactRow(this.icon, this.intro, this.text, this.url, {this.isPhoneNumber = false});
  final IconData icon;
  final String intro;
  final String text;
  final String url;
  final bool isPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(intro,
                style: CarriageTheme.body
              ),
              Row(
                children: <Widget>[
                  Icon(icon),
                  SizedBox(width: 19),
                  Expanded(
                    child: Text(
                      text,
                      semanticsLabel: isPhoneNumber ? text.characters.fold('', (previousValue, element) => previousValue + ' ' + element) : text,
                      style: TextStyle(
                        fontSize: 17,
                        color: CarriageTheme.gray1,
                      ),
                    ),
                  ),
                  ArrowURLButton(url)
                ],
              ),
              Divider()
            ],
          )
      ),
    );
  }
}

class PhoneNumberRow extends StatelessWidget {
  PhoneNumberRow(this.text, this.phoneNumber);
  final String text;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    String phoneNumberFormatted = '(${phoneNumber.substring(0,3)}) ${phoneNumber.substring(3,6)}-${phoneNumber.substring(6)}';
    return ContactRow(Icons.phone, text, phoneNumberFormatted, 'tel:' + phoneNumber, isPhoneNumber: true);
  }
}

class ArrowURLButton extends StatelessWidget {
  ArrowURLButton(this.url);
  final String url;

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
            onTap: () async {
              if (await UrlLauncher.canLaunch(url)) {
                await UrlLauncher.launch(url);
              } else {
                print('Could not launch $url');
              }
            },
          ),
        )
    );
  }
}