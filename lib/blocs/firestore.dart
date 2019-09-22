import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/blocs/userauth.dart';

class FirestoreBLoC {
  static final Firestore _db = Firestore.instance;
  static DocumentReference userDoc;

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