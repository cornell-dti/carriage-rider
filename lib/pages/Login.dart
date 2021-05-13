import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';

class Login extends StatelessWidget {

  @override
  Widget build(context) {
    AuthProvider authProvider = Provider.of(context);
    try {
      authProvider.signInSilently();
    } catch (e) {
      print(
          'User has not logged in previously, therefore, we should not proceed');
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Welcome to Carriage',
                        style: TextStyle(fontSize: 33, color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Sign in using your Cornell email',
                        style: TextStyle(fontSize: 15, color: Colors.grey[300])),
                  ),
                ],
              ),
              ExcludeSemantics(
                child: Image.asset(
                  'assets/images/Logo-No text.png',
                  height: 270,
                  width: 270,
                ),
              ),
              Spacer(),
              SignInButton()
            ],
          ),
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(context) {
    AuthProvider authProvider = Provider.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: 48),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.8,
        child: FlatButton(
          color: Colors.white,
          splashColor: Colors.grey,
          onPressed: () {
            authProvider.signIn();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage('assets/images/google_logo.png'),
                    height: 20.0),
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
