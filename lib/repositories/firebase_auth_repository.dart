import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository{
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();
  
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signInWithCredentials(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    var res = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<FirebaseUser> signUpWithVerification(String email, String password) async {
    var user = await signUp(email, password);
    await user.sendEmailVerification();
    return _firebaseAuth.currentUser();
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<void> deleteCurrentUser() async {
    var user = await _firebaseAuth.currentUser();
    return user.delete();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return (await _firebaseAuth.currentUser());
  }

  Future<String> getUserEmail() async {
    return (await _firebaseAuth.currentUser()).email;
  }

  Future<String> getUserId() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<void> sendPasswordReset(String email) async {
    return (await _firebaseAuth.sendPasswordResetEmail(email: email));
  }
}