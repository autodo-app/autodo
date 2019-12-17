import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signInWithCredentials(String email, String password);
  Future<FirebaseUser> signUp(String email, String password);
  Future<FirebaseUser> signUpWithVerification(String email, String password);
  
  Future<void> signOut();
  Future<void> deleteCurrentUser();
  Future<bool> isSignedIn();
  Future<FirebaseUser> getCurrentUser();
  Future<String> getUserEmail();
  Future<String> getUserId();
  Future<void> sendPasswordReset(String email);
}