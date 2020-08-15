import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('Login Bloc', () {
    test(
      'AuthRepository must not be null',
      () {
        expect(
          () => LoginBloc(authRepository: null),
          throwsA(isAssertionError),
        );
      },
    );
    group('LoginEmailChanged', () {
      blocTest<LoginBloc, LoginEvent, LoginState>(
          'Invalid Email, no previous error', build: () {
        final authRepository = MockAuthRepository();
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginEmailChanged(email: ''));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
      }, expect: [
        LoginEmpty(),
        LoginCredentialsInvalid(emailError: ''),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>(
          'Invalid Email, previous error', build: () {
        final authRepository = MockAuthRepository();
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginPasswordChanged(password: ''));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
        bloc.add(LoginEmailChanged(email: ''));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
      }, expect: [
        LoginEmpty(),
        LoginCredentialsInvalid(emailError: '', passwordError: ''),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>('Valid Email', build: () {
        final authRepository = MockAuthRepository();
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginEmailChanged(email: 'test@test.com'));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
      }, expect: [
        LoginEmpty(),
        LoginCredentialsValid(email: 'test@test.com'),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>('Valid Email, previous error',
          build: () {
        final authRepository = MockAuthRepository();
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginPasswordChanged(password: ''));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
        bloc.add(LoginEmailChanged(email: 'test@test.com'));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
      }, expect: [
        LoginEmpty(),
        LoginCredentialsInvalid(),
      ]);
    });
    group('LoginPasswordChanged', () {
      blocTest<LoginBloc, LoginEvent, LoginState>('Invalid password',
          build: () {
        final authRepository = MockAuthRepository();
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginPasswordChanged(password: ''));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
      }, expect: [
        LoginEmpty(),
        LoginCredentialsInvalid(emailError: ''),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>(
          'Invalid password, previous error', build: () {
        final authRepository = MockAuthRepository();
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginEmailChanged(email: ''));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
        bloc.add(LoginPasswordChanged(password: ''));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
      }, expect: [
        LoginEmpty(),
        LoginCredentialsInvalid(emailError: ''),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>('Valid password', build: () {
        final authRepository = MockAuthRepository();
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginPasswordChanged(password: '123456'));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
      }, expect: [
        LoginEmpty(),
        LoginCredentialsValid(password: '123456'),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>(
          'Valid password, previous error', build: () {
        final authRepository = MockAuthRepository();
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginEmailChanged(email: ''));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
        bloc.add(LoginPasswordChanged(password: '123456'));
        // account for the debounce time
        await Future.delayed(Duration(milliseconds: 500));
      }, expect: [
        LoginEmpty(),
        LoginCredentialsInvalid(),
      ]);
    });
    blocTest<LoginBloc, LoginEvent, LoginState>('Sign in with Google',
        build: () {
          final authRepository = MockAuthRepository();
          return LoginBloc(authRepository: authRepository);
        },
        act: (bloc) async => bloc.add(LoginWithGooglePressed()),
        expect: [
          LoginEmpty(),
        ]);
    group('LoginWithCredentialsPressed', () {
      blocTest<LoginBloc, LoginEvent, LoginState>(
          'Can\'t communicate to servers', build: () {
        final authRepository = MockAuthRepository();
        when(authRepository.logIn('', ''))
            .thenThrow(PlatformException(code: 'UNHANDLED_ERROR'));
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginWithCredentialsPressed(email: '', password: ''));
      }, expect: [
        LoginEmpty(),
        LoginLoading(),
        LoginError('Error communicating to the auToDo servers.'),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>('Weak Password', build: () {
        final authRepository = MockAuthRepository();
        when(authRepository.logIn('', ''))
            .thenThrow(PlatformException(code: 'ERROR_WEAK_PASSWORD'));
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginWithCredentialsPressed(email: '', password: ''));
      }, expect: [
        LoginEmpty(),
        LoginLoading(),
        LoginError('Your password must be longer than 6 characters.'),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>('Successful login',
          build: () {
        final authRepository = MockAuthRepository();
        when(authRepository.logIn('', '')).thenAnswer((_) async => null);
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(LoginWithCredentialsPressed(email: '', password: ''));
      }, expect: [
        LoginEmpty(),
        LoginLoading(),
        LoginSuccess(),
      ]);
    });
    group('SendPasswordReset', () {
      blocTest<LoginBloc, LoginEvent, LoginState>('Unhandled Exception',
          build: () {
        final authRepository = MockAuthRepository();
        when(authRepository.sendPasswordReset(''))
            .thenThrow(PlatformException(code: 'UNHANDLED_ERROR'));
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(SendPasswordResetPressed(email: ''));
      }, expect: [
        LoginEmpty(),
        LoginLoading(),
        LoginError('Error communicating to the auToDo servers.'),
      ]);
      blocTest<LoginBloc, LoginEvent, LoginState>('Sent fine', build: () {
        final authRepository = MockAuthRepository();
        when(authRepository.sendPasswordReset('')).thenReturn(null);
        return LoginBloc(authRepository: authRepository);
      }, act: (bloc) async {
        bloc.add(SendPasswordResetPressed(email: ''));
      }, expect: [
        LoginEmpty(),
        LoginLoading(),
        LoginEmpty(),
      ]);
    });
  });
}
