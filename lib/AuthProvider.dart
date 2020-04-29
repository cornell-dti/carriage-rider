import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import 'Rider.dart';

Future<String> auth(String baseUrl, String token, String email) async {
  String endpoint = baseUrl + '/auth';
  Map<String, dynamic> requestBody = {
    "token": token,
    "email": email,
    "clientID": "241748771473-0r3v31qcthi2kj09e5qk96mhsm5omrvr.apps.googleusercontent.com",
    "table": "Riders"
  };
  return await post(endpoint, body: requestBody).then((res) {
    return res.body;
  });
}

Future<String> tokenFromAccount(GoogleSignInAccount account) async {
  return await account.authentication.then((auth) {
    return auth.idToken;
  }).catchError((e) {
    print('tokenFromAccount - $e');
    return null;
  });
}

class AuthProvider with ChangeNotifier {
  Rider user;
  StreamSubscription userAuthSub;

  AuthProvider(String baseUrl) {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ]);

    userAuthSub = googleSignIn.onCurrentUserChanged.listen((newUser) {
      print('AuthProvider - GoogleSignIn - onCurrentUserChanged - $newUser');
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
}