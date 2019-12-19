import 'package:autodo/repositories/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';

import 'package:autodo/blocs/barrel.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockFirebaseUser extends Mock implements FirebaseUser {}

void main() {
  group('Signup Bloc', () {
    test(
      'AuthRepository must not be null',
      () {
        expect(
          () => SignupBloc(authRepository: null),
          throwsA(isAssertionError),
        );
      },
    );
    group('SignupEmailChanged', () {
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Invalid Email, no previous error',
        build: () {
          final authRepository = MockAuthRepository();
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupEmailChanged(email: ''));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
        },
        expect: [
          SignupCredentialsInvalid(emailError: ""),
        ]
      );
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Invalid Email, previous error',
        build: () {
          final authRepository = MockAuthRepository();
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupPasswordChanged(password: ''));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
          bloc.add(SignupEmailChanged(email: ''));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
        },
        expect: [
          SignupCredentialsInvalid(emailError: "", passwordError: ""),
        ]
      );
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Valid Email',
        build: () {
          final authRepository = MockAuthRepository();
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupEmailChanged(email: 'test@test.com'));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
        },
        expect: [
          SignupCredentialsValid(),
        ]
      );
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Valid Email, previous error',
        build: () {
          final authRepository = MockAuthRepository();
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupPasswordChanged(password: ''));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
          bloc.add(SignupEmailChanged(email: 'test@test.com'));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
        },
        expect: [
          SignupCredentialsInvalid(),
        ]
      );
    });
    group('SignupPasswordChanged', () {
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Invalid password',
        build: () {
          final authRepository = MockAuthRepository();
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupPasswordChanged(password: ''));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
        },
        expect: [
          SignupCredentialsInvalid(emailError: ""),
        ]
      );
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Invalid password, previous error',
        build: () {
          final authRepository = MockAuthRepository();
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupEmailChanged(email: ''));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
          bloc.add(SignupPasswordChanged(password: ''));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
        },
        expect: [
          SignupCredentialsInvalid(emailError: ""),
        ]
      );
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Valid password',
        build: () {
          final authRepository = MockAuthRepository();
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupPasswordChanged(password: '123456'));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
        },
        expect: [
          SignupCredentialsValid(),
        ]
      );
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Valid password, previous error',
        build: () {
          final authRepository = MockAuthRepository();
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupEmailChanged(email: ''));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
          bloc.add(SignupPasswordChanged(password: '123456'));
          // account for the debounce time
          await Future.delayed(Duration(milliseconds: 500));
        },
        expect: [
          SignupCredentialsInvalid(),
        ]
      );
    });
    group('SignupWithCredentialsPressed', () {
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Can\'t communicate to servers',
        build: () {
          final authRepository = MockAuthRepository();
          when(authRepository.signInWithCredentials('', ''))
            .thenThrow(PlatformException(code: "UNHANDLED_ERROR"));
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupWithCredentialsPressed(email: '', password: ''));
        },
        expect: [
          SignupEmpty(),
          SignupLoading(),
          SignupError("Error communicating to the auToDo servers."),
        ]
      );
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Weak Password',
        build: () {
          final authRepository = MockAuthRepository();
          when(authRepository.signInWithCredentials('', ''))
            .thenThrow(PlatformException(code: "ERROR_WEAK_PASSWORD"));
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupWithCredentialsPressed(email: '', password: ''));
        },
        expect: [
          SignupEmpty(),
          SignupLoading(),
          SignupError("Your password must be longer than 6 characters."),
        ]
      );
      blocTest<SignupBloc, SignupEvent, SignupState>(
        'Successful login',
        build: () {
          final authRepository = MockAuthRepository();
          when(authRepository.signInWithCredentials('', ''))
            .thenAnswer((_) async => null);
          return SignupBloc(authRepository: authRepository);
        },
        act: (bloc) async {
          bloc.add(SignupWithCredentialsPressed(email: '', password: ''));
        },
        expect: [
          SignupEmpty(),
          SignupLoading(),
          SignupSuccess(),
        ]
      );
    });
    blocTest<SignupBloc, SignupEvent, SignupState>(
      'Succesful login with email verification',
      build: () {
        final authRepository = MockAuthRepository();
        final unverifiedUser = MockFirebaseUser();
        final verifiedUser = MockFirebaseUser();
        when(unverifiedUser.isEmailVerified).thenAnswer((_) => false);
        when(verifiedUser.isEmailVerified).thenAnswer((_) => true);
        when(authRepository.getCurrentUser())
          .thenAnswer((_) async => verifiedUser);
        when(authRepository.signUpWithVerification('', ''))
          .thenAnswer((_) async => unverifiedUser);
        return SignupBloc(authRepository: authRepository, verifyEmail: true);
      },
      act: (bloc) async {
        bloc.add(SignupWithCredentialsPressed(email: '', password: ''));
      },
      expect: [
        SignupEmpty(),
        SignupLoading(),
        VerificationSent(),
        UserVerified()
      ]
    );
  });
}