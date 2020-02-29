import 'package:flutter/material.dart';
import 'dart:convert';
import 'app_config.dart';
import 'main_common.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Profile.dart';

String name;
String email;
String imageUrl;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

_handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<String> tokenFromAccount(GoogleSignInAccount account) async {
  GoogleSignInAuthentication auth;
  try {
    auth = await account.authentication;
    print('okay');
  } catch (error) {
    print('error');
  }
  return auth.idToken;
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignInAccount currentUser;
  bool success;

  setCurrentUser(GoogleSignInAccount account) {
    setState(() {
      currentUser = account;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = null;
    success = false;
    try {
      _googleSignIn.signInSilently();
    } catch (error) {
      _googleSignIn.signIn();
    }
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setCurrentUser(account);
      tokenFromAccount(currentUser).then((token) async {
        return await authenticationRequest(
            AppConfig.of(context).baseUrl, token);
      }).then((response) {
        var json = jsonDecode(response);
        setState(() {
          success = json['success'] == 'true' ? true : false;
        });



        print(json['success']);
        return json['success'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // add guard based on backend verification later
    if (currentUser == null) {
      return Scaffold(
          body: Container(
              color: Colors.white,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 150),
                  SizedBox(height: 50),
                  SignInButton()
                ],
              ))));
    } else {
      assert(_googleSignIn.currentUser.email != null);
      assert(_googleSignIn.currentUser.displayName != null);
      assert(_googleSignIn.currentUser.photoUrl != null);
      name = _googleSignIn.currentUser.displayName;
      email = _googleSignIn.currentUser.email;
      imageUrl = _googleSignIn.currentUser.photoUrl;
      return Profile();
    }
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          _handleSignIn();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage('assets/images/google_logo.png'),
                    height: 35.0),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                )
              ],
            )));
  }
}
