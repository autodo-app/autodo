import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';

class MockFirestore extends Mock implements Firestore {}
class MockCollection extends Mock implements CollectionReference {}
class MockDocument extends Mock implements DocumentReference {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}
class MockDocSnapshot extends Mock implements DocumentSnapshot {}
class MockWriteBatch extends Mock implements WriteBatch {}

void main() {
  group('DataRepository', () {
    final firestore = MockFirestore();
    final document = MockDocument();
    final collection = MockCollection();
    final repository = FirebaseDataRepository(uuid: '', firestoreInstance: firestore);
    when(firestore.collection('users'))
      .thenAnswer((_) => collection);
    when(collection.document(''))
      .thenAnswer((_) => document);
    when(collection.document('0'))
        .thenAnswer((_) => document);

    test('Null Assertion', () {
      final firestore = MockFirestore();
      expect(() => FirebaseDataRepository(firestoreInstance: firestore, uuid: null), throwsAssertionError);
    });
    test('Default Firestore', () {
      WidgetsFlutterBinding.ensureInitialized();
      expect(FirebaseDataRepository(uuid: '').props, [Firestore.instance, '']);
    });
    group('todos', () {
      when(document.collection('todos'))
        .thenAnswer((_) => collection);

      test('New Todo', () {
        when(collection.add(Todo().toEntity().toDocument()))
          .thenAnswer((_) async => MockDocument());
        expect(repository.addNewTodo(Todo()), completes);
      });
      test('Delete Todo', () {
        when(document.delete())
          .thenAnswer((_) async {});
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
        when(snap.documents)
          .thenAnswer((_) => [doc]);
        when(collection.snapshots())
          .thenAnswer((_) => Stream.fromIterable([snap]));
        expect(repository.todos(), emits([Todo()]));
      });
      test('batch', () {
        WidgetsFlutterBinding.ensureInitialized();
        when(firestore.batch()).thenAnswer((_) => MockWriteBatch());
        expect(repository.startTodoWriteBatch(),
          WriteBatchWrapper(
            firestoreInstance: firestore,
            collection: collection));
      });
    });
    group('refuelings', () {
      when(document.collection('refuelings'))
        .thenAnswer((_) => collection);

      test('New Refueling', () {
        when(collection.add(Refueling().toEntity().toDocument()))
          .thenAnswer((_) async => MockDocument());
        expect(repository.addNewRefueling(Refueling()), completes);
      });
      test('Delete Refueling', () {
        when(document.delete())
          .thenAnswer((_) async {});
        expect(repository.deleteRefueling(Refueling(id: '0')), completes);
      });
      test('Update Refueling', () {
        when(document.updateData(Refueling(id: '0').toEntity().toDocument()))
          .thenAnswer((_) async {});
        expect(repository.updateRefueling(Refueling(id: '0')), completes);
      });
      test('refuelings', () {
        final snap = MockQuerySnapshot();
        final doc = MockDocSnapshot();
        when(doc.data).thenAnswer((_) => {});
        when(doc.documentID).thenAnswer((_) => null);
        when(snap.documents)
          .thenAnswer((_) => [doc]);
        when(collection.snapshots())
          .thenAnswer((_) => Stream.fromIterable([snap]));
        expect(repository.refuelings(), emits([Refueling()]));
      });
      test('batch', () {
        WidgetsFlutterBinding.ensureInitialized();
        when(firestore.batch()).thenAnswer((_) => MockWriteBatch());
        expect(repository.startRefuelingWriteBatch(),
          WriteBatchWrapper(
            firestoreInstance: firestore,
            collection: collection));
      });
    });
    group('cars', () {
      when(document.collection('cars'))
        .thenAnswer((_) => collection);

      test('New Car', () {
        when(collection.add(Car().toEntity().toDocument()))
          .thenAnswer((_) async => MockDocument());
        expect(repository.addNewCar(Car()), completes);
      });
      test('Delete Car', () {
        when(document.delete())
          .thenAnswer((_) async {});
        expect(repository.deleteCar(Car(id: '0')), completes);
      });
      test('Update Car', () {
        when(document.updateData(Car(id: '0').toEntity().toDocument()))
          .thenAnswer((_) async {});
        expect(repository.updateCar(Car(id: '0')), completes);
      });
      test('cars', () {
        final snap = MockQuerySnapshot();
        final doc = MockDocSnapshot();
        when(doc.data).thenAnswer((_) => {});
        when(doc.documentID).thenAnswer((_) => null);
        when(snap.documents)
          .thenAnswer((_) => [doc]);
        when(collection.snapshots())
          .thenAnswer((_) => Stream.fromIterable([snap]));
        expect(repository.cars(), emits([Car()]));
      });
      test('batch', () {
        WidgetsFlutterBinding.ensureInitialized();
        when(firestore.batch()).thenAnswer((_) => MockWriteBatch());
        expect(repository.startCarWriteBatch(),
          WriteBatchWrapper(
            firestoreInstance: firestore,
            collection: collection));
      });
    });
    group('repeats', () {
      when(document.collection('repeats'))
        .thenAnswer((_) => collection);

      test('New Repeat', () {
        when(collection.add(Repeat().toEntity().toDocument()))
          .thenAnswer((_) async => MockDocument());
        expect(repository.addNewRepeat(Repeat()), completes);
      });
      test('Delete Repeat', () {
        when(document.delete())
          .thenAnswer((_) async {});
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
        when(snap.documents)
          .thenAnswer((_) => [doc]);
        when(collection.snapshots())
          .thenAnswer((_) => Stream.fromIterable([snap]));
        expect(repository.repeats(), emits([Repeat()]));
      });
      test('batch', () {
        WidgetsFlutterBinding.ensureInitialized();
        when(firestore.batch()).thenAnswer((_) => MockWriteBatch());
        expect(repository.startRepeatWriteBatch(),
          WriteBatchWrapper(
            firestoreInstance: firestore,
            collection: collection));
      });
    });
    test('notificationID', () {
      final snap = MockDocSnapshot();
      when(snap.data).thenAnswer((_) => {});
      when(document.snapshots())
        .thenAnswer((_) => Stream.fromIterable([snap]));
      expect(repository.notificationID(), emits(null));
    });
  });
}