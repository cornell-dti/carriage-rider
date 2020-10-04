import 'package:carriage_rider/Account_Name.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/Home.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class AccountLogin extends StatefulWidget {
  @override
  _AccountLoginState createState() => _AccountLoginState();
}

class _AccountLoginState extends State<AccountLogin> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();

  Widget _buildEmailField() {
    return TextFormField(
      controller: controllerOne,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      style: TextStyle(color: Colors.white, fontSize: 15),
      onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: controllerTwo,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      textInputAction: TextInputAction.done,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      style: TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  final cancelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w100,
    fontSize: 15,
  );

  final titleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      child: Text("Cancel", style: cancelStyle),
                      onTap: () {
                        Navigator.pop(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Home()));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.0),
              Row(
                children: <Widget>[
                  Text("Welcome to Carriage", style: titleStyle),
                ],
              ),
              SizedBox(height: 15.0),
              Row(children: <Widget>[
                Text("Sign in using your Cornell email",
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
              ]),
              SizedBox(height: 40.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailField(),
                    SizedBox(height: 20.0),
                    _buildPasswordField(),
                    SizedBox(height: 10.0)
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(children: <Widget>[
                GestureDetector(
                    onTap: () => _launchURL(),
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    )),
              ]),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        height: 45.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => AccountName()));
                          },
                          elevation: 3.0,
                          color: Colors.white,
                          textColor: Colors.black,
                          child: Text('Sign In'),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  _launchURL() async {
    const url =
        'https://netid.cornell.edu/netidforgotpassword/forgotPasswordStart.htm';
    if (await UrlLauncher.canLaunch(url)) {
      await UrlLauncher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
