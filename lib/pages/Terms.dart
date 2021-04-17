import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Login.dart';

class TermsOfService extends StatelessWidget {
  Widget acceptButton(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.8,
              height: 50.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => Login()));
                  },
                  elevation: 2.0,
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text('Accept All',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17)))),
        ),
      ),
    );
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (ctx) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.80,
                      child: Expanded(
                          child: Padding(
                        padding:
                            EdgeInsets.only(top: 15.0, left: 15.0, right: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text('Terms & Conditions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28)),
                              ),
                              SizedBox(height: 20),
                              Flexible(
                                  child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quam aliquam vestibulum egestas amet euismod tellus. '
                                      'Augue suspendisse nunc vitae suspendisse fringilla. Nisl semper sed vehicula volutpat risus, id. Vitae,'
                                      ' malesuada euismod lectus duis nibh. Lorem fames nunc porttitor vulputate molestie est. Eu id lorem egestas in id '
                                      'iaculis tristique. A tristique phasellus sapien tempus, urna, nisl. Commodo pretium lectus egestas sit in ut et, '
                                      'ornare amet. Fringilla integer senectus egestas viverra sed cursus ac pellentesque diam. Pharetra volutpat aliquam '
                                      'eget velit, accumsan eleifend lorem. Eu vitae turpis turpis id sollicitudin leo mauris ut curabitur. Massa rutrum '
                                      'eu in nunc aliquet. Pellentesque rhoncus mollis tortor diam. Sapien senectus posuere libero urna tempus, in proin morbi tempus.',
                                      style: TextStyle(fontSize: 17))),
                            ]),
                      )))),
              Positioned(bottom: 0, child: acceptButton(context))
            ],
          );
        });
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
              Text('Do you agree to',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 5.0),
              Text("Carriage's",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () => displayBottomSheet(context),
                child: RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Terms and Conditions',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      TextSpan(text: '?', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image(image: AssetImage('assets/images/readingman.png')),
              acceptButton(context)
            ],
          ),
        )));
  }
}
