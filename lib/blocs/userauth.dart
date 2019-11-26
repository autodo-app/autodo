import 'dart:async';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SignInFailure implements Exception {
  String errMsg() => "Firebase Auth rejected attempt to register new user";
}

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<void> deleteCurrentUser();
  String getCurrentUser();
  Future<void> signOut();
  bool isLoading();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String currentUser = "", currentUserName = "NO_USER_DATA";

  Future<String> signIn(String email, String password) async {
    AuthResult res = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = res.user;
    currentUser = user.uid;
    currentUserName = user.email;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult res;
    try {
      res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      currentUser = res.user.uid;
      currentUserName = res.user.email;
    } on PlatformException {
      print(
          "PlatformException: Cannot create a user with an email that already exists");
      return "";
    }
    return res.user.uid;
  }
  
  Future<String> waitForVerification(FirebaseUser user) async {
    while(!user.isEmailVerified) {
      await Future.microtask(() async {
        // reload the user's values
        await Future.delayed(const Duration(milliseconds: 500), () async {
          user = await FirebaseAuth.instance.currentUser();
          user.reload();
        });
      });
    }
    return user.uid;
  }

  Future<FirebaseUser> signUpWithVerification(String email, String password) async {
    AuthResult res;
    try {
      res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await res.user.sendEmailVerification();
    } on PlatformException {
      print(
          "PlatformException: Cannot create a user with an email that already exists");
      return null;
    }
    return res.user;
  }

  Future<void> deleteCurrentUser() async {
    FirebaseUser cur = await  _firebaseAuth.currentUser();
    if (cur != null) {
      try {
        FirestoreBLoC().deleteUserDocument();
        await cur.delete();
      } catch (e) {
        print(e);
      }
    }
  }

  String getCurrentUser() {
    return currentUser;
  }

  Future<String> fetchUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null) return "NO_USER";
    currentUser = user.uid;
    return user.uid;
  }

  Future<String> getCurrentUserName() async {
    return currentUserName;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  bool isLoading() {
    if (getCurrentUser() == '') return true;
    else return false;
  }

  StreamSubscription<FirebaseUser> listen(Function(FirebaseUser) fn) {
    return _firebaseAuth.onAuthStateChanged.listen(fn);
  }

  // Make the object a Singleton
  static final Auth _auth = Auth._internal();
  factory Auth() {
    return _auth;
  }
  Auth._internal();
}
