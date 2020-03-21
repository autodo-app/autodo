import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/repositories/src/firebase_write_batch.dart';
import 'package:autodo/models/models.dart';

class MockFirestore extends Mock implements Firestore {}

class MockCollection extends Mock implements CollectionReference {}

class MockDocument extends Mock implements DocumentReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockDocSnapshot extends Mock implements DocumentSnapshot {}

class MockWriteBatch extends Mock implements WriteBatch {}

void main() {
  group('FirebaseDataRepository', () {
    final firestore = MockFirestore();
    final document = MockDocument();
    final collection = MockCollection();
    final repository =
        FirebaseDataRepository(uuid: '', firestoreInstance: firestore);
    when(firestore.collection('users')).thenAnswer((_) => collection);
    when(collection.document('')).thenAnswer((_) => document);
    when(collection.document('0')).thenAnswer((_) => document);

    test('Null Assertion', () {
      final firestore = MockFirestore();
      expect(
          () =>
              FirebaseDataRepository(firestoreInstance: firestore, uuid: null),
          throwsAssertionError);
    });
    test('Default Firestore', () {
      WidgetsFlutterBinding.ensureInitialized();
      expect(FirebaseDataRepository(uuid: '').props, [Firestore.instance, '']);
    });
    group('todos', () {
      when(document.collection('todos')).thenAnswer((_) => collection);

      test('New Todo', () {
        when(collection.add(Todo().toEntity().toDocument()))
            .thenAnswer((_) async => MockDocument());
        expect(repository.addNewTodo(Todo()), completes);
      });
      test('Delete Todo', () {
        when(document.delete()).thenAnswer((_) async {});
        expect(repository.deleteTodo(Todo(id: '0')), completes);
      });
      test('Update Todo', () {
        when(document.updateData(Todo(id: '0').toEntity().toDocument()))
            .thenAnswer((_) async {});
        expect(repository.updateTodo(Todo(id: '0')), completes);
      });
      test('todos', () {
        final snap = MockQuerySnapshot();
        final doc = MockDocSnapshot();
        when(doc.data).thenAnswer((_) => {});
        when(doc.documentID).thenAnswer((_) => null);
        when(snap.documents).thenAnswer((_) => [doc]);
        when(collection.snapshots())
            .thenAnswer((_) => Stream.fromIterable([snap]));
        expect(repository.todos(), emits([Todo()]));
      });
      test('batch', () {
        WidgetsFlutterBinding.ensureInitialized();
        when(firestore.batch()).thenAnswer((_) => MockWriteBatch());
        expect(
            repository.startTodoWriteBatch(),
            FirebaseWriteBatch(
                firestoreInstance: firestore, collection: collection));
      });
    });
    group('refuelings', () {
      when(document.collection('refuelings')).thenAnswer((_) => collection);

      test('New Refueling', () {
        final refueling = Refueling(
          id: '0',
          carName: 'test',
          amount: 10.0,
          cost: 10.0,
          mileage: 1000,
          date: DateTime.fromMillisecondsSinceEpoch(0),
        );
        when(collection.add(refueling.toDocument()))
            .thenAnswer((_) async => MockDocument());
        expect(repository.addNewRefueling(refueling), completes);
      });
      test('Delete Refueling', () {
        final refueling = Refueling(
          id: '0',
          carName: 'test',
          amount: 10.0,
          cost: 10.0,
          mileage: 1000,
          date: DateTime.fromMillisecondsSinceEpoch(0),
        );
        when(document.delete()).thenAnswer((_) async {});
        expect(repository.deleteRefueling(refueling), completes);
      });
      test('Update Refueling', () {
        final refueling = Refueling(
          id: '0',
          carName: 'test',
          amount: 10.0,
          cost: 10.0,
          mileage: 1000,
          date: DateTime.fromMillisecondsSinceEpoch(0),
        );
        when(document.updateData(refueling.toDocument()))
            .thenAnswer((_) async {});
        expect(repository.updateRefueling(refueling), completes);
      });
      test('refuelings', () {
        final refueling = Refueling(
          carName: 'test',
          amount: 10.0,
          cost: 10.0,
          mileage: 1000,
          date: DateTime.fromMillisecondsSinceEpoch(0),
        );
        final snap = MockQuerySnapshot();
        final doc = MockDocSnapshot();
        when(doc.data).thenAnswer((_) => refueling.toDocument());
        when(doc.documentID).thenAnswer((_) => null);
        when(snap.documents).thenAnswer((_) => [doc]);
        when(collection.snapshots())
            .thenAnswer((_) => Stream.fromIterable([snap]));
        expect(repository.refuelings(), emits([refueling]));
      });
      test('batch', () {
        WidgetsFlutterBinding.ensureInitialized();
        when(firestore.batch()).thenAnswer((_) => MockWriteBatch());
        expect(
            repository.startRefuelingWriteBatch(),
            FirebaseWriteBatch(
                firestoreInstance: firestore, collection: collection));
      });
    });
    group('cars', () {
      when(document.collection('cars')).thenAnswer((_) => collection);

      test('New Car', () {
        when(collection.add(Car().toDocument()))
            .thenAnswer((_) async => MockDocument());
        expect(repository.addNewCar(Car()), completes);
      });
      test('Delete Car', () {
        when(document.delete()).thenAnswer((_) async {});
        expect(repository.deleteCar(Car(id: '0')), completes);
      });
      test('Update Car', () {
        when(document.updateData(Car(id: '0').toDocument()))
            .thenAnswer((_) async {});
        expect(repository.updateCar(Car(id: '0')), completes);
      });
      test('cars', () {
        final snap = MockQuerySnapshot();
        final doc = MockDocSnapshot();
        when(doc.data).thenAnswer((_) => {});
        when(doc.documentID).thenAnswer((_) => null);
        when(snap.documents).thenAnswer((_) => [doc]);
        when(collection.snapshots())
            .thenAnswer((_) => Stream.fromIterable([snap]));
        expect(repository.cars(), emits([Car()]));
      });
      test('batch', () {
        WidgetsFlutterBinding.ensureInitialized();
        when(firestore.batch()).thenAnswer((_) => MockWriteBatch());
        expect(
            repository.startCarWriteBatch(),
            FirebaseWriteBatch(
                firestoreInstance: firestore, collection: collection));
      });
    });
    group('repeats', () {
      when(document.collection('repeats')).thenAnswer((_) => collection);

      test('New Repeat', () {
        when(collection.getDocuments()).thenReturn(null);
        when(collection.add(Repeat().toEntity().toDocument()))
            .thenAnswer((_) async => MockDocument());
        expect(repository.addNewRepeat(Repeat()), completes);
      });
      test('Delete Repeat', () {
        when(document.delete()).thenAnswer((_) async {});
        expect(repository.deleteRepeat(Repeat(id: '0')), completes);
      });
      test('Update Repeat', () {
        when(document.updateData(Repeat(id: '0').toEntity().toDocument()))
            .thenAnswer((_) async {});
        expect(repository.updateRepeat(Repeat(id: '0')), completes);
      });
      test('repeats', () {
        final snap = MockQuerySnapshot();
        final doc = MockDocSnapshot();
        when(doc.data).thenAnswer((_) => {});
        when(doc.documentID).thenAnswer((_) => null);
        when(snap.documents).thenAnswer((_) => [doc]);
        when(collection.snapshots())
            .thenAnswer((_) => Stream.fromIterable([snap]));
        expect(repository.repeats(), emits([Repeat()]));
      });
      test('batch', () {
        WidgetsFlutterBinding.ensureInitialized();
        when(firestore.batch()).thenAnswer((_) => MockWriteBatch());
        expect(
            repository.startRepeatWriteBatch(),
            FirebaseWriteBatch(
                firestoreInstance: firestore, collection: collection));
      });
    });
    test('notificationID', () {
      final snap = MockDocSnapshot();
      when(snap.data).thenAnswer((_) => {});
      when(document.snapshots()).thenAnswer((_) => Stream.fromIterable([snap]));
      expect(repository.notificationID(), emits(null));
    });
  });
}
