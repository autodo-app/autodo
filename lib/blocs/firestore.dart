import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreBLoC {
  static final Firestore _db = Firestore.instance;
  static DocumentReference userDoc;
  static StreamSubscription authState;

  static void onAuthChanged(FirebaseUser user) {
    print('firestore bloc');
    if (user != null && user.uid != null) {
      userDoc = _db.collection('users').document(user.uid);
    }
  }

  static void startListen() {
    authState = FirebaseAuth.instance.onAuthStateChanged.listen(onAuthChanged);
  }

  static void stopListen() {
    authState.cancel();
  }  

  static Future<DocumentReference> fetchUserDocument() async {
    await Auth().fetchUser();
    if (Auth().getCurrentUser() == '') return null;
    userDoc = _db
          .collection('users')
          .document(Auth().getCurrentUser());
    return userDoc;
  }

  static DocumentReference getUserDocument() {
    return userDoc;
  }

  static bool isLoading() {
    if (userDoc == null) return true;
    return false;
  }
}