import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:autodo/repositories/src/sembast_write_batch.dart';
import 'package:autodo/repositories/src/sembast_data_repository.dart';
import 'package:autodo/models/models.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  var repository = await SembastDataRepository.open(
        createDb: true, pathProvider: () async => Directory('.'));
  group('SembastDataRepository', (){
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
        repository = await SembastDataRepository.open(
            createDb: true,
            pathProvider: () async => Directory('.'),
            dbPath: 'todos.db');
        // This is deliberately not await-ed to ensure that the stream matcher
        // receives the new todo event
        repository.addNewTodo(Todo(name: 'test')); // ignore: unawaited_futures
        expect(repository.todos(), emits([Todo(id: '1', name: 'test')]));
        // await databaseFactoryIo.deleteDatabase('todos.db');
      });
      test('batch', () async {
        WidgetsFlutterBinding.ensureInitialized();
        repository = await SembastDataRepository.open(
          createDb: true,
          pathProvider: () async => Directory('.'),
        );
        expect(
            await repository.startTodoWriteBatch(),
            SembastWriteBatch(
                dbFactory: repository.dbFactory,
                dbPath: './sample.db',
                store: StoreRef('todos')));
      });
    });
    group('refuelings', () {
      final ref = Refueling(
          id: '1',
          mileage: 1000,
          date: DateTime.fromMillisecondsSinceEpoch(0),
          cost: 20.0,
          amount: 20.0,
          carName: 'test');
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
        repository = await SembastDataRepository.open(
            createDb: true,
            pathProvider: () async => Directory('.'),
            dbPath: 'refuelings.db');
        repository.addNewRefueling(ref); // ignore: unawaited_futures
        expect(repository.refuelings(), emits([ref]));
        // await databaseFactoryIo.deleteDatabase('refuelings.db');
      });
      test('batch', () async {
        WidgetsFlutterBinding.ensureInitialized();
        repository = await SembastDataRepository.open(
          createDb: true,
          pathProvider: () async => Directory('.'),
        );
        expect(
            await repository.startRefuelingWriteBatch(),
            SembastWriteBatch(
                dbFactory: repository.dbFactory,
                dbPath: './sample.db',
                store: StoreRef('refuelings')));
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
        repository = await SembastDataRepository.open(
            createDb: true,
            pathProvider: () async => Directory('.'),
            dbPath: 'cars.db');
        repository.addNewCar(Car()); // ignore: unawaited_futures
        expect(repository.cars(), emits([Car(id: '1')]));
        // await databaseFactoryIo.deleteDatabase('cars.db');
      });
      test('batch', () async {
        WidgetsFlutterBinding.ensureInitialized();
        repository = await SembastDataRepository.open(
            createDb: true, pathProvider: () async => Directory('.'));
        expect(
            await repository.startCarWriteBatch(),
            SembastWriteBatch(
                dbFactory: repository.dbFactory,
                dbPath: './sample.db',
                store: StoreRef('cars')));
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
        repository = await SembastDataRepository.open(
            createDb: true,
            pathProvider: () async => Directory('.'),
            dbPath: 'repeats.db');
        repository.addNewRepeat(Repeat()); // ignore: unawaited_futures
        expect(repository.repeats(), emits([Repeat(id: '1')]));
        // await databaseFactoryIo.deleteDatabase('repeats.db');
      });
      test('batch', () async {
        WidgetsFlutterBinding.ensureInitialized();
        repository = await SembastDataRepository.open(
            createDb: true, pathProvider: () async => Directory('.'));
        expect(
            await repository.startRepeatWriteBatch(),
            SembastWriteBatch(
                dbFactory: repository.dbFactory,
                dbPath: './sample.db',
                store: StoreRef('repeats')));
      });
    });
  });
}
