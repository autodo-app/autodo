
abstract class AuthRepository {
  // Future<FirebaseUser> signInWithGoogle();
  // Future<FirebaseUser> signInWithCredentials(String email, String password);
  Future<void> signUp(String email, String password, {bool verify});
  // Future<FirebaseUser> signUpWithVerification(String email, String password);
  Future<void> logIn(String email, String password);
  Future<void> logOut();
  Future<void> deleteCurrentUser();
  Future<bool> isLoggedIn();
  Future<String> getCurrentUserEmail();
  Future<String> getCurrentUserToken();
  // Future<String> getUserEmail();
  // Future<String> getUserId();
  Future<void> sendPasswordReset(String email);
  Future<String> refreshAccessToken();

  // Stream<FirebaseUser> get stream;
}
