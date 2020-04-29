import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

Future<String> auth(String baseUrl, String token, String email) async {
  String endpoint = baseUrl + '/auth';
  Map<String, dynamic> requestBody = {
    "token": token,
    "email": email,
    "clientID": "241748771473-0r3v31qcthi2kj09e5qk96mhsm5omrvr.apps.googleusercontent.com",
    "table": "Riders"
  };
  return post(endpoint, body: requestBody).then((res) {
    return res.body;
  });
}

Future<String> tokenFromAccount(GoogleSignInAccount account) async {
  return account.authentication.then((auth) {
    return auth.idToken;
  }).catchError((e) {
    print('tokenFromAccount - $e');
    return null;
  });
}

class AuthProvider with ChangeNotifier {
  String id;
  StreamSubscription userAuthSub;
  GoogleSignIn googleSignIn;

  AuthProvider() {
    googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ]);
    userAuthSub = googleSignIn.onCurrentUserChanged.listen((newUser) async {
      print('AuthProvider - GoogleSignIn - onCurrentUserChanged - $newUser');
      if (newUser != null) {
        id = await tokenFromAccount(newUser).then((token) async {
          print(token);
          return auth("http://192.168.1.19:3001", token, newUser.email);
        }).then((response) {
          Map<String, dynamic> json = jsonDecode(response);
          if (!json.containsKey('id')) {
            return null;
          }
          print(json['id']);
          return json['id'];
        });
      } else {
        id = null;
      }
        notifyListeners();

    }, onError: (e) {
      print('AuthProvider - GoogleSignIn - onCurrentUserChanged - $e');
    });
  }

  @override
  void dispose() {
    if(userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

  bool get isAuthenticated {
    return id != null;
  }

  void signIn() {
    googleSignIn.signIn();
  }

  void signInSilently() {
    googleSignIn.signInSilently();
  }

  void signOut() {
    googleSignIn.signOut();
    id = null;
}
}