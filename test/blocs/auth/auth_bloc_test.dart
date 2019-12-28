import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/blocs/blocs.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('Auth Bloc', () {
    test(
      'AuthRepository must not be null',
      () {
        expect(
          () => AuthenticationBloc(userRepository: null),
          throwsA(isAssertionError),
        );
      },
    );
    group('AppStarted', () {
      blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
        'Exception thrown in AppStarted',
        build: () {
          final authRepository = MockAuthRepository();
          return AuthenticationBloc(userRepository: authRepository);
        },
        act: (bloc) async => bloc.add(AppStarted()),
        expect: <AuthenticationState>[Uninitialized(), Unauthenticated()],
      );
      blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
        'Signed In in AppStarted',
        build: () {
          final authRepository = MockAuthRepository();
          when(authRepository.isSignedIn()).thenAnswer((_) async => true);
          return AuthenticationBloc(userRepository: authRepository);
        },
        act: (bloc) async => bloc.add(AppStarted()),
        expect: <AuthenticationState>[
          Uninitialized(),
          Authenticated(null, null)
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
        'Not Signed In in AppStarted',
        build: () {
          final authRepository = MockAuthRepository();
          when(authRepository.isSignedIn()).thenAnswer((_) async => false);
          return AuthenticationBloc(userRepository: authRepository);
        },
        act: (bloc) async => bloc.add(AppStarted()),
        expect: <AuthenticationState>[Uninitialized(), Unauthenticated()],
      );
    });
    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
      'LoggedIn',
      build: () {
        final authRepository = MockAuthRepository();
        return AuthenticationBloc(userRepository: authRepository);
      },
      act: (bloc) async => bloc.add(LoggedIn()),
      expect: <AuthenticationState>[Uninitialized(), Authenticated(null, null)],
    );
    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
      'LoggedOut',
      build: () {
        final authRepository = MockAuthRepository();
        return AuthenticationBloc(userRepository: authRepository);
      },
      act: (bloc) async => bloc.add(LoggedOut()),
      expect: <AuthenticationState>[Uninitialized(), Unauthenticated()],
    );
    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
      'Deleted User',
      build: () {
        final authRepository = MockAuthRepository();
        return AuthenticationBloc(userRepository: authRepository);
      },
      act: (bloc) async => bloc.add(DeletedUser()),
      expect: <AuthenticationState>[Uninitialized(), Unauthenticated()],
    );
  });
}
