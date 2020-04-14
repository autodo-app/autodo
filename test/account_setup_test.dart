import 'dart:io';

import 'package:autodo/repositories/src/sembast_data_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:preferences/preferences.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/units/units.dart';

class MockNotificationsBloc extends Mock implements NotificationsBloc {}

class MockDatabaseBloc extends MockBloc<DatabaseEvent, DatabaseState>
    implements DatabaseBloc {}

class MockTodosBloc extends Mock implements TodosBloc {}

// ignore: must_be_immutable
class MockRepo extends Mock implements DataRepository {}

// ignore: must_be_immutable
class MockWriteBatch extends Mock implements WriteBatchWrapper {}

void clearDatabase(Pattern name) {
  for (var f in Directory('.').listSync()) {
    if (f.path.contains(name)) {
      f.deleteSync();
    }
  }
}

void clearDatabases() {
  for (var f in Directory('.').listSync()) {
    if (f.path.contains('.db')) {
      f.deleteSync();
    }
  }
}

StreamMatcher ignoreAll(List ign) => emitsThrough(mayEmit(emitsAnyOf(ign)));

/// Runs a series of end-to-end tests designed to ensure that a new user's
/// account setup will play nicely with the app's business logic.
void main() {
  BasePrefService pref;

  setUp(() async {
    pref = JustCachePrefService();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('number of cars', () {
    final car1 = Car(name: 'car1', mileage: 10000);
    final car2 = Car(name: 'car2', mileage: 10000);
    final car3 = Car(name: 'car3', mileage: 10000);
    final car1Defaults = TodosBloc.defaultsImperial
        .asMap()
        .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1}',
                carName: 'car1',
                dueMileage: (t.mileageRepeatInterval < car1.mileage) ?
                    car1.mileage + t.mileageRepeatInterval :
                    t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList();
    final car2Defaults = List<Todo>.from(car1Defaults)
      ..addAll(
        TodosBloc.defaultsImperial
          .asMap()
          .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1 + car1Defaults.length}',
                carName: 'car2',
                dueMileage: (t.mileageRepeatInterval < car2.mileage) ?
                    car2.mileage + t.mileageRepeatInterval :
                    t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList()
      );
    final car3Defaults = List<Todo>.from(car2Defaults)
      ..addAll(
        TodosBloc.defaultsImperial
          .asMap()
          .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1 + 2 * car1Defaults.length}',
                carName: 'car3',
                dueMileage: (t.mileageRepeatInterval < car2.mileage) ?
                    car2.mileage + t.mileageRepeatInterval :
                    t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList()
      );
    // setUp(clearDatabases);

    test('1 car, no prev todos', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('cars1.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'cars1.db', pathProvider: () => Directory('.'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      await expectLater(
          carsBloc, emitsInOrder([CarsLoading(), CarsLoaded([])]));
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car1));
      await expectLater(
          carsBloc,
          emitsInOrder([
            ignoreAll([CarsLoaded([])]),
            CarsLoaded([car1])
          ]));

      // Check that the Default ToDos are loaded properly
      await expectLater(todosBloc, emitsInOrder([TodosLoaded(todos: []), TodosLoaded(todos: car1Defaults)]));

      clearDatabase('cars1.db');
    });
    test('2 cars, no prev todos', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final expectedState = CarsLoaded([car1, car2]);
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('cars2.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'cars2.db', pathProvider: () => Directory('./'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddMultipleCars([car1, car2]));
      await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), expectedState]);
      print('cars loaded');
      await emitsExactly(todosBloc, [TodosLoaded(todos: []), TodosLoaded(todos: car2Defaults)]);
      // not doing anything for the lastcompleted or repeat interval screens

      clearDatabase('cars2.db');
    });
    test('3 cars, no prev todos', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final expectedState = CarsLoaded([car1, car2, car3]);
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('cars3.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'cars3.db', pathProvider: () => Directory('.'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddMultipleCars([car1, car2, car3]));
      await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), expectedState]);
      print('cars loaded');
      await emitsExactly(todosBloc, [TodosLoaded(todos: []), TodosLoaded(todos: car3Defaults)]);

      clearDatabase('cars3.db');
    });
  });
  group('car mileage', () {
    final car1 = Car(name: 'car1', mileage: 1000);
    final car2 = Car(name: 'car2', mileage: 10000);
    final car3 = Car(name: 'car3', mileage: 100000);
    final car4 = Car(name: 'car4', mileage: 1000000);

    final car1Defaults = TodosBloc.defaultsImperial
        .asMap()
        .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1}',
                carName: 'car1',
                dueMileage: (t.mileageRepeatInterval < car1.mileage) ?
                    car1.mileage + t.mileageRepeatInterval :
                    t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList();
    final car2Defaults = TodosBloc.defaultsImperial
        .asMap()
        .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1}',
                carName: 'car2',
                dueMileage: (t.mileageRepeatInterval < car2.mileage) ?
                    car2.mileage + t.mileageRepeatInterval :
                    t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList();
    final car3Defaults = TodosBloc.defaultsImperial
        .asMap()
        .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1}',
                carName: 'car3',
                dueMileage: (t.mileageRepeatInterval < car3.mileage) ?
                    car3.mileage + t.mileageRepeatInterval :
                    t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList();
    final car4Defaults = TodosBloc.defaultsImperial
        .asMap()
        .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1}',
                carName: 'car4',
                dueMileage: (t.mileageRepeatInterval < car4.mileage) ?
                    car4.mileage + t.mileageRepeatInterval :
                    t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList();

    test('1000 miles', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('cars1_1000.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'cars1_1000.db', pathProvider: () => Directory('.'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      await expectLater(
          carsBloc, emitsInOrder([CarsLoading(), CarsLoaded([])]));
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car1));
      await expectLater(
          carsBloc,
          emitsInOrder([
            ignoreAll([CarsLoaded([])]),
            CarsLoaded([car1])
          ]));

      // Check that the Default ToDos are loaded properly
      await expectLater(todosBloc, emitsInOrder([TodosLoaded(todos: []), TodosLoaded(todos: car1Defaults)]));

      clearDatabase('cars1_1000.db');
    });

    test('10000 miles', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('cars2_10000.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'cars2_10000.db', pathProvider: () => Directory('.'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      await expectLater(
          carsBloc, emitsInOrder([CarsLoading(), CarsLoaded([])]));
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car2));
      await expectLater(
          carsBloc,
          emitsInOrder([
            ignoreAll([CarsLoaded([])]),
            CarsLoaded([car2])
          ]));

      // Check that the Default ToDos are loaded properly
      await expectLater(todosBloc, emitsInOrder([TodosLoaded(todos: []), TodosLoaded(todos: car2Defaults)]));

      clearDatabase('cars2_10000.db');
    });

    test('100000 miles', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('cars3_100000.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'cars3_100000.db', pathProvider: () => Directory('.'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      await expectLater(
          carsBloc, emitsInOrder([CarsLoading(), CarsLoaded([])]));
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car3));
      await expectLater(
          carsBloc,
          emitsInOrder([
            ignoreAll([CarsLoaded([])]),
            CarsLoaded([car3])
          ]));

      // Check that the Default ToDos are loaded properly
      await expectLater(todosBloc, emitsInOrder([TodosLoaded(todos: []), TodosLoaded(todos: car3Defaults)]));

      clearDatabase('cars3_100000.db');
    });

    // more than any of the repeats intervals
    test('1000000 miles', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('cars4_1000000.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'cars4_1000000.db', pathProvider: () => Directory('.'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      await expectLater(
          carsBloc, emitsInOrder([CarsLoading(), CarsLoaded([])]));
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car4));
      await expectLater(
          carsBloc,
          emitsInOrder([
            ignoreAll([CarsLoaded([])]),
            CarsLoaded([car4])
          ]));

      // Check that the Default ToDos are loaded properly
      await expectLater(todosBloc, emitsInOrder([TodosLoaded(todos: []), TodosLoaded(todos: car4Defaults)]));

      clearDatabase('cars4_1000000.db');
    });
  });

  group('last completed todos', () {
    final car = Car(name: 'car', mileage: 10000);
    final oilCompleted = Todo(id: '1', name: 'oil', dueMileage: 8000, completed: true, completedDate: DateTime.fromMillisecondsSinceEpoch(0), mileageRepeatInterval: 3000, carName: 'car', completedMileage: car.mileage, dateRepeatInterval: RepeatInterval());
    final oilUpcoming = Todo(id: '16', name: 'oil', dueMileage: 13000, mileageRepeatInterval: 3000, completed: false, estimatedDueDate: true, carName: 'car', dateRepeatInterval: RepeatInterval());
    final tiresCompleted = Todo(id: '7', name: 'tires', dueMileage: 8000, completed: true, completedDate: DateTime.fromMillisecondsSinceEpoch(0), mileageRepeatInterval: 7500, carName: 'car', completedMileage: car.mileage, dateRepeatInterval: RepeatInterval());
    final tiresUpcoming = Todo(id: '17', name: 'tires', dueMileage: 17500, mileageRepeatInterval: 7500, completed: false, estimatedDueDate: true, carName: 'car', dateRepeatInterval: RepeatInterval());

    final defaults = TodosBloc.defaultsImperial
        .asMap()
        .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1}',
                carName: 'car',
                dueMileage: (t.mileageRepeatInterval < car.mileage) ?
                    car.mileage + t.mileageRepeatInterval :
                    t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList();
    final defaultsWithOilCompleted = List<Todo>.from(defaults)
      .map((t) => (t.name == 'oil') ? oilCompleted : t)
      .toList()
      ..add(oilUpcoming);
    final defaultsWithBothCompleted = List<Todo>.from(defaults)
      .map((t) => (t.name == 'oil') ? oilCompleted : t)
      .map((t) => (t.name == 'tires') ? tiresCompleted : t)
      .toList()
      ..add(oilUpcoming)
      ..add(tiresUpcoming);

    test('oil', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final expectedState = CarsLoaded([car]);
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('oil.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'oil.db', pathProvider: () => Directory('./'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car));
      await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), expectedState]);
      todosBloc.add(CompleteTodo(oilCompleted, DateTime.fromMillisecondsSinceEpoch(0)));
      await emitsExactly(todosBloc, [TodosLoaded(todos: []), TodosLoaded(todos: defaults), TodosLoaded(todos: defaultsWithOilCompleted)]);
      print(todosBloc.state);
      // not doing anything for the lastcompleted or repeat interval screens

      clearDatabase('oil.db');
    });

    test('oil & tires', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final expectedState = CarsLoaded([car]);
      final dbBloc = MockDatabaseBloc();
      final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      final notificationsBloc = MockNotificationsBloc();
      final todosBloc = TodosBloc(
          dbBloc: dbBloc,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc);
      clearDatabase('oil_tires.db');

      // tell the blocs that there was a new user signed up
      final localRepo = await SembastDataRepository.open(
          dbPath: 'oil_tires.db', pathProvider: () => Directory('./'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car));
      await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), expectedState]);
      todosBloc.add(CompleteTodo(oilCompleted, DateTime.fromMillisecondsSinceEpoch(0)));
      // await Future.delayed(Duration(milliseconds: 50));
      todosBloc.add(CompleteTodo(tiresCompleted, DateTime.fromMillisecondsSinceEpoch(0)));
      await emitsExactly(todosBloc, [TodosLoaded(todos: []), TodosLoaded(todos: defaults), TodosLoaded(todos: defaultsWithOilCompleted), TodosLoaded(todos: defaultsWithBothCompleted)]);
      print(todosBloc.state);
      // not doing anything for the lastcompleted or repeat interval screens

      clearDatabase('oil_tires.db');
    });
  });
}
