import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Home.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfService extends StatelessWidget {
  Widget acceptButton(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.8,
              height: 50.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        new MaterialPageRoute(builder: (context) => Home()));
                  },
                  elevation: 2.0,
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text('Accept All',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17)
                  )
              )
          ),
        )
    );
  }

  void openGuidelines() async {
    String url = 'https://sds.cornell.edu/accommodations-services/transportation/culift-guidelines';
    if (await canLaunch(url)) {
    await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Semantics(
                    label: 'By using Carriage, you agree to follow CULift guidelines',
                    button: true,
                    onTap: () => openGuidelines(),
                    child: ExcludeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('By using Carriage,',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5.0),
                          Text('you agree to follow',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () => openGuidelines(),
                            child: Text(
                                'CULift guidelines',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                )
                            )
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ExcludeSemantics(child: Image(image: AssetImage('assets/images/readingman.png'))),
                  Expanded(child: acceptButton(context))
                ],
              ),
            )));
  }
}
