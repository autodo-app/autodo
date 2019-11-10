import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreBLoC {
  static final Firestore _db = Firestore.instance;
  static DocumentReference userDoc;

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