import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
    AuthResult res = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = res.user;
    // if (user.uid != null) LocalStorage.save("uuid", user.uid);
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print("$user");
    if (user != null) return user.uid;
    return "NO_USER";
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
