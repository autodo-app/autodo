import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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
  final Firestore _db = Firestore.instance;
  String currentUser = "", currentUserName = "NO_USER_DATA";

  Future<void> _createUserDocument() async {
    await _db.runTransaction((transaction) async {
      DocumentReference ref = _db.collection('users').document(currentUser);
      await transaction.set(ref, Map<String, Object>());
    });
  }

  Future<String> signIn(String email, String password) async {
    print("here");
    AuthResult res = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = res.user;
    // if (user.uid != null) LocalStorage.save("uuid", user.uid);
    currentUser = user.uid;
    // currentUserName = user.displayName == "" ? user.email : user.displayName;
    currentUserName = user.email;
    await _createUserDocument();
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult res;
    try {
      res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      currentUser = res.user.uid;
      currentUserName = res.user.email;
      await _createUserDocument();
    } on PlatformException {
      print(
          "PlatformException: Cannot create a user with an email that already exists");
      return "";
    }

    FirebaseUser user = res.user;
    return user.uid;
  }

  Future<void> deleteCurrentUser() async {
    FirebaseUser cur = await  _firebaseAuth.currentUser();
    if (cur != null) {
      try {
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
    // FirebaseUser user = await _firebaseAuth.currentUser();
    // if (user != null && user.displayName != "")
    //   return user.displayName;
    // else if (user != null) return user.email;
    // return "NO_USER";
    return currentUserName;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  bool isLoading() {
    if (getCurrentUser() == '') return true;
    else return false;
  }

  // Make the object a Singleton
  static final Auth _auth = Auth._internal();
  factory Auth() {
    return _auth;
  }
  Auth._internal();
}
