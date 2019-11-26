import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autodo/blocs/userauth.dart';

class FirestoreBLoC {
  static final Firestore _db = Firestore.instance;
  FirebaseUser _curUser;
  static DocumentReference userDoc;
  StreamSubscription _authListener; // ignore: cancel_subscriptions

  void _onAuthChange(FirebaseUser user) {
    if (_curUser != null && _curUser == user) {
      // signing out
      userDoc = null;
    } else if (user != null && user.uid != null) {
      setUserDocument(user.uid);
    }
    _curUser = user;
  }

  void initialize() {
    _authListener ??= Auth().listen(_onAuthChange);
  }

  Future<void> createUserDocument(String uuid) async {
    userDoc = _db.collection('users').document(uuid);
    await userDoc.setData(Map<String, Object>());
  }

  void setUserDocument(String uuid) {
    userDoc = _db.collection('users').document(uuid);
  }

  DocumentReference getUserDocument() {
    return userDoc;
  }

  void deleteUserDocument() {
    userDoc.delete();
  }

  // Make the object a Singleton
  static final FirestoreBLoC _auth = FirestoreBLoC._internal();
  factory FirestoreBLoC() {
    return _auth;
  }
  FirestoreBLoC._internal();
}