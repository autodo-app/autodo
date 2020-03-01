import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_repository.dart';

typedef GetGoogleCredentialsFn = AuthCredential Function(
    {String accessToken, String idToken});

class FirebaseAuthRepository extends AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignin,
    GetGoogleCredentialsFn getGoogleCredential,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _getGoogleCredential =
            getGoogleCredential ?? GoogleAuthProvider.getCredential;

  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn;

  final GetGoogleCredentialsFn _getGoogleCredential;

  FirebaseUser _cachedCurrentUser;

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = _getGoogleCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final res = await _firebaseAuth.signInWithCredential(credential);
    _cachedCurrentUser = res.user;
    return res.user;
  }

  @override
  Future<FirebaseUser> signInWithCredentials(
      String email, String password) async {
    final res = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _cachedCurrentUser = res.user;
    return res.user;
  }

  @override
  Future<FirebaseUser> signUp(String email, String password) async {
    final res = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _cachedCurrentUser = res.user;
    return res.user;
  }

  @override
  Future<FirebaseUser> signUpWithVerification(
      String email, String password) async {
    final user = await signUp(email, password);
    await user.sendEmailVerification();
    return user;
  }

  @override
  Future<void> signOut() async {
    _cachedCurrentUser = null;
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<void> deleteCurrentUser() async {
    try {
      final user = _cachedCurrentUser ?? await _firebaseAuth.currentUser();
      print(user);
      print('cache $_cachedCurrentUser');
      _cachedCurrentUser = null;
      return user.delete();
    } on PlatformException catch (e) {
      // if exception is thrown because user doesn't exist, ignore it for now
      print(e);
    }
  }

  @override
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  @override
  Future<FirebaseUser> getCurrentUser() {
    return _firebaseAuth.currentUser();
  }

  @override
  Future<String> getUserEmail() async {
    return (await _firebaseAuth.currentUser()).email;
  }

  @override
  Future<String> getUserId() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Stream<FirebaseUser> get stream => _firebaseAuth.onAuthStateChanged;
}
