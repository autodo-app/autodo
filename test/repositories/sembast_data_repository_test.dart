import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:autodo/repositories/src/sembast_write_batch.dart';
import 'package:autodo/repositories/src/sembast_data_repository.dart';
import 'package:autodo/models/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SembastDataRepository', () {
    var repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''));

    group('todos', () {
      test('New Todo', () {
        expect(repository.addNewTodo(Todo()), completes);
      });
      test('Delete Todo', () {
        expect(repository.deleteTodo(Todo(id: '0')), completes);
      });
      test('Update Todo', () {
        expect(repository.updateTodo(Todo(id: '0')), completes);
      });
      test('todos', () async {
        await databaseFactoryIo.deleteDatabase('todos.db');
        repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''), dbPath: 'todos.db');
        repository.addNewTodo(Todo(name: 'test'));
        expect(repository.todos(), emits([Todo(id: '1', name: 'test')]));
        await databaseFactoryIo.deleteDatabase('todos.db');
      });
      test('batch', () async {
        WidgetsFlutterBinding.ensureInitialized();
        repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''),);
        expect(
            await repository.startTodoWriteBatch(),
            SembastWriteBatch(database: await repository.db, store: StoreRef('todos')));
      });
    });
    group('refuelings', () {
      final ref = Refueling(  
        id: '1',
        mileage: 1000,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        cost: 20.0,
        amount: 20.0,
        carName: 'test'
      );
      test('New Refueling', () {
        expect(repository.addNewRefueling(ref), completes);
      });
      test('Delete Refueling', () {
        expect(repository.deleteRefueling(ref), completes);
      });
      test('Update Todo', () {
        expect(repository.updateRefueling(ref), completes);
      });
      test('refuelings', () async {
        await databaseFactoryIo.deleteDatabase('refuelings.db');
        repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''), dbPath: 'refuelings.db');
        repository.addNewRefueling(ref);
        expect(repository.refuelings(), emits([ref]));
        await databaseFactoryIo.deleteDatabase('refuelings.db');
      });
      test('batch', () async {
        WidgetsFlutterBinding.ensureInitialized();
        repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''),);
        expect(
            await repository.startRefuelingWriteBatch(),
            SembastWriteBatch(database: await repository.db, store: StoreRef('refuelings')));
      });
    });
    group('cars', () {
      test('New', () {
        expect(repository.addNewCar(Car()), completes);
      });
      test('Delete', () {
        expect(repository.deleteCar(Car(id: '0')), completes);
      });
      test('Update', () {
        expect(repository.updateCar(Car(id: '0')), completes);
      });
      test('cars', () async {
        await databaseFactoryIo.deleteDatabase('cars.db');
        repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''), dbPath: 'cars.db');
        repository.addNewCar(Car());
        expect(repository.cars(), emits([Car(id: '1')]));
        await databaseFactoryIo.deleteDatabase('cars.db');
      });
      test('batch', () async {
        WidgetsFlutterBinding.ensureInitialized();
        repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''));
        expect(
            await repository.startCarWriteBatch(),
            SembastWriteBatch(database: await repository.db, store: StoreRef('cars')));
      });
    });
    group('repeats', () {
      test('New', () {
        expect(repository.addNewRepeat(Repeat()), completes);
      });
      test('Delete', () {
        expect(repository.deleteRepeat(Repeat(id: '0')), completes);
      });
      test('Update', () {
        expect(repository.updateRepeat(Repeat(id: '0')), completes);
      });
      test('repeats', () async {
        await databaseFactoryIo.deleteDatabase('repeats.db');
        repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''), dbPath: 'repeats.db');
        repository.addNewRepeat(Repeat());
        expect(repository.repeats(), emits([Repeat(id: '1')]));
        await databaseFactoryIo.deleteDatabase('repeats.db');
      });
      test('batch', () async {
        WidgetsFlutterBinding.ensureInitialized();
        repository = SembastDataRepository(createDb: true, pathProvider: () async => Directory(''));
        expect(
            await repository.startRepeatWriteBatch(),
            SembastWriteBatch(database: await repository.db, store: StoreRef('repeats')));
      });
    });
  });
}
