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
    implements Firestore {
  @override
  List<Object> get props => [];
}

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
    blocTest('UserLoggedIn', build: () {
      final authBloc = MockAuthenticationBloc();
      whenListen(authBloc,
          Stream.fromIterable([RemoteAuthenticated('test', 'abcd', false)]));
      return DatabaseBloc(
          firestoreInstance: mockFirestore, authenticationBloc: authBloc);
    }, act: (bloc) async {
      bloc.add(UserLoggedIn('abcd', false));
    }, expect: [
      DbUninitialized(),
      DbLoaded(
          FirebaseDataRepository(
              firestoreInstance: mockFirestore, uuid: 'abcd'),
          false)
    ]);
    blocTest('UserLoggedOut', build: () {
      final authBloc = MockAuthenticationBloc();
      whenListen(authBloc, Stream.fromIterable([Unauthenticated()]));
      return DatabaseBloc(
          firestoreInstance: mockFirestore, authenticationBloc: authBloc);
    }, act: (bloc) async {
      bloc.add(UserLoggedOut());
    }, expect: [
      DbUninitialized(),
      DbNotLoaded(),
    ]);
  });
}
