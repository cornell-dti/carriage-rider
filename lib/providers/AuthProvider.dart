import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/app_config.dart';

Future<String> auth(String baseUrl, String token, String email) async {
  Uri endpoint = Uri.parse(baseUrl + '/auth');
  Map<String, dynamic> requestBody = {
    'token': token,
    'email': email,
    'clientId': Platform.isAndroid
        ? '241748771473-0r3v31qcthi2kj09e5qk96mhsm5omrvr.apps.googleusercontent.com'
        : '241748771473-7rfda2grc8f7p099bmf98en0q9bcvp18.apps.googleusercontent.com',
    'table': 'Riders'
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
  StreamSubscription _userAuthSub;
  GoogleSignIn googleSignIn;
  FlutterSecureStorage secureStorage;

  AuthProvider(AppConfig config) {
    secureStorage = FlutterSecureStorage();
    googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ]);
    _userAuthSub = googleSignIn.onCurrentUserChanged.listen((newUser) async {
      if (newUser != null) {
        String googleToken = await tokenFromAccount(newUser);
        Map<String, dynamic> authResponse =
            jsonDecode(await auth(config.baseUrl, googleToken, newUser.email));
        String token = authResponse['jwt'];
        Map<String, dynamic> jwt = JwtDecoder.decode(token);
        id = jwt['id'];
        await secureStorage.write(key: 'token', value: token);
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
    if (_userAuthSub != null) {
      _userAuthSub.cancel();
      _userAuthSub = null;
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
