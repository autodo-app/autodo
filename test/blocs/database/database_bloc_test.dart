import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

// EquatableMixin is needed to verify results of bloctests
class MockFirestoreInstance extends Mock
    with EquatableMixin
    implements Firestore {}

class MockCollection extends Mock
    with EquatableMixin
    implements CollectionReference {}

class MockDocument extends Mock
    with EquatableMixin
    implements DocumentReference {}

void main() {
  final mockFirestore = MockFirestoreInstance();
  final mockUsersCollection = MockCollection();
  when(mockUsersCollection.document('abcd')).thenAnswer((_) => MockDocument());
  when(mockFirestore.collection('users'))
      .thenAnswer((_) => mockUsersCollection);

  group('DatabaseBloc', () {
    test('Null Auth Bloc', () {
      expect(
          () => DatabaseBloc(authenticationBloc: null), throwsAssertionError);
    });
    blocTest('LoadDatabase',
        build: () {
          final authBloc = MockAuthenticationBloc();
          whenListen(authBloc,
              Stream.fromIterable([Authenticated("test@test.com", 'abcd')]));
          return DatabaseBloc(
              firestoreInstance: mockFirestore, authenticationBloc: authBloc);
        },
        act: (bloc) => bloc.add(LoadDatabase()),
        expect: [
          DbUninitialized(),
        ]);
    blocTest('UserLoggedIn', build: () {
      final authBloc = MockAuthenticationBloc();
      whenListen(authBloc,
          Stream.fromIterable([Authenticated("test@test.com", 'abcd')]));
      return DatabaseBloc(
          firestoreInstance: mockFirestore, authenticationBloc: authBloc);
    }, act: (bloc) async {
      bloc.add(LoadDatabase());
      bloc.add(UserLoggedIn('abcd'));
    }, expect: [
      DbUninitialized(),
      DbLoaded(FirebaseDataRepository(
          firestoreInstance: mockFirestore, uuid: 'abcd'))
    ]);
    blocTest('UserLoggedOut', build: () {
      final authBloc = MockAuthenticationBloc();
      whenListen(authBloc,
          Stream.fromIterable([Authenticated("test@test.com", 'abcd')]));
      return DatabaseBloc(
          firestoreInstance: mockFirestore, authenticationBloc: authBloc);
    }, act: (bloc) async {
      bloc.add(LoadDatabase());
      bloc.add(UserLoggedOut());
    }, expect: [
      DbUninitialized(),
      DbNotLoaded(),
    ]);
  });
}
