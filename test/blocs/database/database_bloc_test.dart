import 'dart:io';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/generated/pubspec.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/repositories/src/sembast_data_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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

class MockDocSnap extends Mock with EquatableMixin implements DocumentSnapshot {
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockFirestore = MockFirestoreInstance();
  final mockUsersCollection = MockCollection();
  final mockDocSnap = MockDocSnap();
  when(mockDocSnap.data).thenReturn({'db_version': Pubspec.db_version});
  final mockDocument = MockDocument();
  when(mockDocument.get()).thenAnswer((realInvocation) async => mockDocSnap);
  when(mockUsersCollection.document('abcd')).thenAnswer((_) => mockDocument);
  when(mockFirestore.collection('users'))
      .thenAnswer((_) => mockUsersCollection);
  final repo = await FirebaseDataRepository.open(
      firestoreInstance: mockFirestore, uuid: 'abcd');
  final pathProvider = () async => Directory('.');
  final sembastCreate =
      await SembastDataRepository.open(pathProvider: pathProvider);
  final sembastOpen =
      await SembastDataRepository.open(pathProvider: pathProvider);
  final firebaseStorageRepo = FirebaseStorageRepository(uuid: 'abcd');
  final localStorageRepo = LocalStorageRepository();

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
    }, expect: [DbUninitialized(), DbLoaded(repo, storageRepo: firebaseStorageRepo, newUser: false)]);
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

    blocTest('TrialLogin', build: () {
      final authBloc = MockAuthenticationBloc();
      // whenListen(authBloc, Stream.fromIterable([Unauthenticated()]));
      return DatabaseBloc(
          firestoreInstance: mockFirestore,
          authenticationBloc: authBloc,
          pathProvider: pathProvider);
    }, act: (bloc) async {
      bloc.add(TrialLogin(true));
    }, expect: [
      DbUninitialized(),
      DbLoaded(sembastCreate, storageRepo: localStorageRepo, newUser: true),
    ]);
    blocTest('TrialLogin from authBloc', build: () {
      final authBloc = MockAuthenticationBloc();
      whenListen(authBloc, Stream.fromIterable([LocalAuthenticated(false)]));
      return DatabaseBloc(
          firestoreInstance: mockFirestore,
          authenticationBloc: authBloc,
          pathProvider: pathProvider);
      // }, act: (bloc) async {
      // bloc.add(TrialLogin(true));
    }, expect: [
      DbUninitialized(),
      DbLoaded(sembastOpen, storageRepo: localStorageRepo, newUser: false),
    ]);
  });
}
