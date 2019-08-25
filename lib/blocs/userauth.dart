import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// import './localstorage.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult res = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = res.user;
    // if (user.uid != null) LocalStorage.save("uuid", user.uid);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult res;
    try {
      res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException {
      print(
          "PlatformException: Cannot create a user with an email that already exists");
      return "";
    }

    FirebaseUser user = res.user;
    // if (user.uid != null) LocalStorage.save("uuid", user.uid);
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) return user.uid;
    return "NO_USER";
  }

  Future<String> getCurrentUserName() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null && user.displayName != "")
      return user.displayName;
    else if (user != null) return user.email;
    return "NO_USER";
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

Auth globalAuth = Auth();
