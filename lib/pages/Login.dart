import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(context) {
    AuthProvider authProvider = Provider.of(context);
    try {
      authProvider.signInSilently();
    } catch (e) {
      print('Login - tried to sign in silently - $e');
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
                    child: Semantics(
                      header: true,
                      child: Text('Welcome to Carriage',
                          style: TextStyle(fontSize: 33, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Sign in using your Cornell email',
                        style:
                            TextStyle(fontSize: 15, color: Colors.grey[300])),
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
      constraints: BoxConstraints(
          minHeight: 40, minWidth: MediaQuery.of(context).size.width),
      child: ButtonTheme(
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) return Colors.grey;
                return null;
              })),
          onPressed: () async {
            await authProvider.signIn();
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage('assets/images/google_logo.png'),
                    height: 18.0),
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                        fontSize: 14,
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
