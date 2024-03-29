import 'package:carriage_rider/widgets/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Home.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfService extends StatelessWidget {
  Widget acceptButton(BuildContext context) {
    return CButton(
        text: 'Accept All',
        height: 50,
        onPressed: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home())));
  }

  void openGuidelines() async {
    String url =
        'https://sds.cornell.edu/accommodations-services/transportation/culift-guidelines';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonHeight = 48;
    double buttonVerticalPadding = 16;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    top: 40.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: buttonHeight + 2 * buttonVerticalPadding + 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Semantics(
                      label:
                          'By using Carriage, you agree to follow CULift guidelines',
                      link: true,
                      onTap: () => openGuidelines(),
                      child: ExcludeSemantics(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text('By using Carriage,',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: 5.0),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text('you agree to follow',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: 10.0),
                            Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Container(
                                  height: 48,
                                  child: TextButton(
                                      onPressed: () => openGuidelines(),
                                      child: Text('CULift guidelines',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ))),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    ExcludeSemantics(
                        child: Image(
                            image: AssetImage('assets/images/readingman.png'))),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 34),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      spreadRadius: 5,
                      blurRadius: 11,
                      color: Colors.black.withOpacity(0.11))
                ]),
                child: Container(
                    width: double.maxFinite, child: acceptButton(context)),
              ),
            )
          ],
        )));
  }
}
