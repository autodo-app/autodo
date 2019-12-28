import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

import 'package:autodo/repositories/repositories.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignin extends Mock implements GoogleSignIn {}

class MockGoogleAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleAuth extends Mock implements GoogleSignInAuthentication {}

class MockCredential extends Mock implements AuthCredential {}

class MockAuthResult extends Mock implements AuthResult {}

class MockUser extends Mock with EquatableMixin implements FirebaseUser {}

void main() {
  group('FirebaseAuthRepository', () {
    final firebase = MockFirebaseAuth();
    test('signInWithGoogle', () {
      final googleSignIn = MockGoogleSignin();
      final account = MockGoogleAccount();
      final auth = MockGoogleAuth();
      when(googleSignIn.signIn()).thenAnswer((_) async => account);
      when(account.authentication).thenAnswer((_) async => auth);
      when(auth.accessToken).thenAnswer((_) => '');
      when(auth.idToken).thenAnswer((_) => '');
      final credential = MockCredential();
      final authResult = MockAuthResult();
      when(firebase.signInWithCredential(credential))
          .thenAnswer((_) async => authResult);
      when(authResult.user).thenAnswer((_) => MockUser());
      final repository = FirebaseAuthRepository(
          firebaseAuth: firebase,
          googleSignin: googleSignIn,
          getGoogleCredential: ({accessToken, idToken}) => credential);
      expect(repository.signInWithGoogle(), completion(MockUser()));
    });
    test('normal signin', () {
      final authResult = MockAuthResult();
      when(firebase.signInWithEmailAndPassword(email: '', password: ''))
          .thenAnswer((_) async => authResult);
      when(authResult.user).thenAnswer((_) => MockUser());
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.signInWithCredentials('', ''), completion(MockUser()));
    });
    test('normal signup', () {
      final authResult = MockAuthResult();
      when(firebase.createUserWithEmailAndPassword(email: '', password: ''))
          .thenAnswer((_) async => authResult);
      when(authResult.user).thenAnswer((_) => MockUser());
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.signUp('', ''), completion(MockUser()));
    });
    test('signup with verification', () {
      final authResult = MockAuthResult();
      final user = MockUser();
      when(firebase.createUserWithEmailAndPassword(email: '', password: ''))
          .thenAnswer((_) async => authResult);
      when(authResult.user).thenAnswer((_) => user);
      when(user.sendEmailVerification()).thenAnswer((_) async {});
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.signUpWithVerification('', ''), completion(user));
    });
    test('signout', () {
      final googleSignIn = MockGoogleSignin();
      when(firebase.signOut()).thenAnswer((_) async {});
      when(googleSignIn.signOut()).thenAnswer((_) async => MockGoogleAccount());
      final repository = FirebaseAuthRepository(
          firebaseAuth: firebase, googleSignin: googleSignIn);
      expect(repository.signOut(), completes);
    });
    test('delete user', () {
      final user = MockUser();
      when(firebase.currentUser()).thenAnswer((_) async => user);
      when(user.delete()).thenAnswer((_) async {});
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.deleteCurrentUser(), completes);
    });
    test('signed in?', () {
      final user = MockUser();
      when(firebase.currentUser()).thenAnswer((_) async => user);
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.isSignedIn(), completion(true));
    });
    test('current user', () {
      final user = MockUser();
      when(firebase.currentUser()).thenAnswer((_) async => user);
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.getCurrentUser(), completion(user));
    });
    test('delete user', () {
      final user = MockUser();
      when(firebase.currentUser()).thenAnswer((_) async => user);
      when(user.email).thenAnswer((_) => '');
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.getUserEmail(), completion(''));
    });
    test('user id', () {
      final user = MockUser();
      when(firebase.currentUser()).thenAnswer((_) async => user);
      when(user.uid).thenAnswer((_) => '');
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.getUserId(), completion(''));
    });
    test('password reset', () {
      when(firebase.sendPasswordResetEmail(email: '')).thenAnswer((_) async {});
      final repository = FirebaseAuthRepository(
        firebaseAuth: firebase,
      );
      expect(repository.sendPasswordReset(''), completes);
    });
  });
}
