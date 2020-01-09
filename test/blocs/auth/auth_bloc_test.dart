import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/blocs/blocs.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements FirebaseUser {}

class MockMetadata extends Mock implements FirebaseUserMetadata {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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
          SharedPreferences.setMockInitialValues({'trialUserLoggedIn': false});
          return AuthenticationBloc(userRepository: authRepository);
        },
        act: (bloc) async => bloc.add(AppStarted()),
        expect: <AuthenticationState>[
          Uninitialized(),
          RemoteAuthenticated(null, null, false)
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
      expect: <AuthenticationState>[
        Uninitialized(),
        RemoteAuthenticated(null, null, false)
      ],
    );
    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
      'LoggedOut',
      build: () {
        final authRepository = MockAuthRepository();
        return AuthenticationBloc(userRepository: authRepository);
      },
      act: (bloc) async => bloc.add(LogOut()),
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
    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
      'User Signed Up',
      build: () {
        final authRepository = MockAuthRepository();
        when(authRepository.getUserEmail())
            .thenAnswer((_) async => 'test@test.com');
        when(authRepository.getUserId()).thenAnswer((_) async => 'test');
        return AuthenticationBloc(userRepository: authRepository);
      },
      act: (bloc) async => bloc.add(SignedUp()),
      expect: <AuthenticationState>[
        Uninitialized(),
        RemoteAuthenticated('test@test.com', 'test', true)
      ],
    );
    blocTest('AuthRepo SignedUp event', build: () {
      final metadata = MockMetadata();
      final user = MockUser();
      when(user.metadata).thenReturn(metadata);
      when(metadata.creationTime)
          .thenReturn(DateTime.fromMillisecondsSinceEpoch(0));
      when(metadata.lastSignInTime)
          .thenReturn(DateTime.fromMillisecondsSinceEpoch(0));
      final authRepository = MockAuthRepository();
      when(authRepository.getUserEmail())
          .thenAnswer((_) async => 'test@test.com');
      when(authRepository.getUserId()).thenAnswer((_) async => 'test');
      when(authRepository.stream)
          .thenAnswer((_) => Stream.fromIterable([user]));
      return AuthenticationBloc(userRepository: authRepository);
    }, expect: [Uninitialized(), RemoteAuthenticated('test@test.com', 'test', true)]);
    blocTest('AuthRepo LoggedIn event', build: () {
      final metadata = MockMetadata();
      final user = MockUser();
      when(user.metadata).thenReturn(metadata);
      when(metadata.creationTime)
          .thenReturn(DateTime.fromMillisecondsSinceEpoch(0));
      when(metadata.lastSignInTime)
          .thenReturn(DateTime.fromMillisecondsSinceEpoch(1));
      final authRepository = MockAuthRepository();
      when(authRepository.getUserEmail())
          .thenAnswer((_) async => 'test@test.com');
      when(authRepository.getUserId()).thenAnswer((_) async => 'test');
      when(authRepository.stream)
          .thenAnswer((_) => Stream.fromIterable([user]));
      return AuthenticationBloc(userRepository: authRepository);
    }, expect: [
      Uninitialized(),
      RemoteAuthenticated('test@test.com', 'test', false)
    ]);
  });
}
