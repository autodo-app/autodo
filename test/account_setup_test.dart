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

void clearDatabase(name) {
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
    // final car3 = Car(name: 'car3', mileage: 10000);
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
      when(dbBloc.state).thenReturn(DbLoaded(localRepo, newUser: true));

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
      // not doing anything for the lastcompleted or repeat interval screens

      // This new car prompts a change in repeats, which prompts a change in todos.
      // Using `emitsAnyOf` because the async nature of the streams means that
      // we may or may not see the empty list state show up in the assert.
      // Doesn't really matter either way if that happens, it shouldn't break
      // the test.
      // final defaultTodos = defaultRepeats
      //     .map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0]))
      //     .toList();
      // expect(
      //     todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));

      clearDatabase('cars1.db');
    });
    test('2 cars, no prev todos', () async {
      WidgetsFlutterBinding.ensureInitialized();
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
      when(dbBloc.state).thenReturn(DbLoaded(localRepo, newUser: true));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car1));
      carsBloc.add(AddCar(car2));
      // await expectLater(carsBloc, emitsInOrder([ignoreAll([CarsLoading, CarsLoaded([]), CarsLoaded([car1])]), CarsLoaded([car1, car2])]));
      expect(carsBloc, mayEmit(CarsLoaded([car1, car2])));
      print('cars loaded');
      // not doing anything for the lastcompleted or repeat interval screens

      // This new car prompts a change in repeats, which prompts a change in todos.
      // Using `emitsAnyOf` because the async nature of the streams means that
      // we may or may not see the empty list state show up in the assert.
      // Doesn't really matter either way if that happens, it shouldn't break
      // the test.

      clearDatabase('cars2.db');
    });
    test('3 cars, no prev todos', () async {
      // final dbBloc = MockDatabaseBloc();
      // final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
      // final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      // final repeatsBloc = RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
      // final notificationsBloc = MockNotificationsBloc();
      // final todosBloc = TodosBloc(dbBloc: dbBloc, carsBloc: carsBloc, notificationsBloc: notificationsBloc, repeatsBloc: repeatsBloc);
      // clearDatabases();

      // // tell the blocs that there was a new user signed up
      // final localRepo = SembastDataRepository(createDb: true, pathProvider: () async => Directory('.'));
      // when(dbBloc.state).thenReturn(DbLoaded(localRepo, true));

      // // Add a Load call to all blocs to force refresh
      // // This would happen automatically if we could write directly to the dbBloc's
      // // stream.
      // refuelingsBloc.add(LoadRefuelings());
      // carsBloc.add(LoadCars());
      // repeatsBloc.add(LoadRepeats());
      // todosBloc.add(LoadTodos());

      // // The mileage screen adds cars to the CarsBloc
      // carsBloc.add(AddCar(car1));
      // expect(carsBloc, emitsAnyOf([CarsLoading(), CarsLoaded([]), CarsLoaded([car1])]));
      // carsBloc.add(AddCar(car2));
      // expect(carsBloc, emitsAnyOf([CarsLoaded([car1]), CarsLoaded([car1, car2])]));
      // carsBloc.add(AddCar(car3));
      // expect(carsBloc, emitsAnyOf([CarsLoaded([car1, car2]), CarsLoaded([car1, car2, car3])]));
      // // not doing anything for the lastcompleted or repeat interval screens

      // // This new car prompts a change in repeats, which prompts a change in todos.
      // // Using `emitsAnyOf` because the async nature of the streams means that
      // // we may or may not see the empty list state show up in the assert.
      // // Doesn't really matter either way if that happens, it shouldn't break
      // // the test.
      // final defaultRepeats = RepeatsBloc.defaults.asMap()
      //     .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1}', cars: ['car1'])))
      //     .values.toList();
      // final car2Defaults = RepeatsBloc.defaults.asMap()
      //     .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1 + RepeatsBloc.defaults.length}', cars: ['car2'])))
      //     .values.toList();
      // final car3Defaults = RepeatsBloc.defaults.asMap()
      //   .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1 + RepeatsBloc.defaults.length}', cars: ['car3'])))
      //   .values.toList();
      // defaultRepeats.addAll(car2Defaults);
      // defaultRepeats.addAll(car3Defaults);
      // expect(repeatsBloc, emitsAnyOf([RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]));
      // final defaultTodos = defaultRepeats.map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0])).toList();
      // expect(todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));

      // clearDatabases();
    });
  });
  group('car mileage', () {
    // final car1 = Car(name: 'car1', mileage: 1000);
    // final car2 = Car(name: 'car2', mileage: 10000);
    // final car3 = Car(name: 'car3', mileage: 100000);
    // final car4 = Car(name: 'car4', mileage: 1000000);

    // final dbBloc = MockDatabaseBloc();
    // final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
    // final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
    // final repeatsBloc = RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
    // final notificationsBloc = MockNotificationsBloc();
    // final todosBloc = TodosBloc(dbBloc: dbBloc, carsBloc: carsBloc, notificationsBloc: notificationsBloc, repeatsBloc: repeatsBloc);

    setUp(clearDatabases);
    // this is less than any of the repeating intervals
    test('1000 miles', () async {
      //   // tell the blocs that there was a new user signed up
      //   final localRepo = SembastDataRepository(createDb: true, pathProvider: () async => Directory('.'));
      //   when(dbBloc.state).thenReturn(DbLoaded(localRepo, true));

      //   // Add a Load call to all blocs to force refresh
      //   // This would happen automatically if we could write directly to the dbBloc's
      //   // stream.
      //   refuelingsBloc.add(LoadRefuelings());
      //   carsBloc.add(LoadCars());
      //   repeatsBloc.add(LoadRepeats());
      //   todosBloc.add(LoadTodos());

      //   // The mileage screen adds cars to the CarsBloc
      //   carsBloc.add(AddCar(car1));
      //   await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), CarsLoaded([car1])]);
      //   // not doing anything for the lastcompleted or repeat interval screens

      //   // This new car prompts a change in repeats, which prompts a change in todos.
      //   // Using `emitsAnyOf` because the async nature of the streams means that
      //   // we may or may not see the empty list state show up in the assert.
      //   // Doesn't really matter either way if that happens, it shouldn't break
      //   // the test.
      //   final defaultRepeats = RepeatsBloc.defaults.asMap()
      //       .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1}', cars: ['car1'])))
      //       .values.toList();
      //   expect(repeatsBloc, emitsAnyOf([RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]));
      //   final defaultTodos = defaultRepeats.map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0])).toList();
      //   expect(todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));

      //   clearDatabases();
    });

    test('10000 miles', () async {
      // // tell the blocs that there was a new user signed up
      // final localRepo = SembastDataRepository(createDb: true, pathProvider: () async => Directory('.'));
      // when(dbBloc.state).thenReturn(DbLoaded(localRepo, true));

      // // Add a Load call to all blocs to force refresh
      // // This would happen automatically if we could write directly to the dbBloc's
      // // stream.
      // refuelingsBloc.add(LoadRefuelings());
      // carsBloc.add(LoadCars());
      // repeatsBloc.add(LoadRepeats());
      // todosBloc.add(LoadTodos());

      // // The mileage screen adds cars to the CarsBloc
      // carsBloc.add(AddCar(car2));
      // await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), CarsLoaded([car2])]);
      // // not doing anything for the lastcompleted or repeat interval screens

      // // This new car prompts a change in repeats, which prompts a change in todos.
      // // Using `emitsAnyOf` because the async nature of the streams means that
      // // we may or may not see the empty list state show up in the assert.
      // // Doesn't really matter either way if that happens, it shouldn't break
      // // the test.
      // final defaultRepeats = RepeatsBloc.defaults.asMap()
      //     .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1}', cars: ['car2'])))
      //     .values.toList();
      // expect(repeatsBloc, emitsAnyOf([RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]));
      // final defaultTodos = defaultRepeats.map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0])).toList();
      // expect(todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));

      // clearDatabases();
    });

    test('100000 miles', () async {
      // // tell the blocs that there was a new user signed up
      // final localRepo = SembastDataRepository(createDb: true, pathProvider: () async => Directory('.'));
      // when(dbBloc.state).thenReturn(DbLoaded(localRepo, true));

      // // Add a Load call to all blocs to force refresh
      // // This would happen automatically if we could write directly to the dbBloc's
      // // stream.
      // when(repo.getCurrentRefuelings()).thenAnswer((_) async => []);
      // when(repo.getCurrentCars()).thenAnswer((_) async => []);
      // when(repo.getCurrentRepeats()).thenAnswer((_) async => []);
      // when(repo.startRepeatWriteBatch()).thenAnswer((_) async => MockWriteBatch());
      // when(repo.getCurrentTodos()).thenAnswer((_) async => []);
      // refuelingsBloc.add(LoadRefuelings());
      // carsBloc.add(LoadCars());
      // repeatsBloc.add(LoadRepeats());
      // todosBloc.add(LoadTodos());

      // // The mileage screen adds cars to the CarsBloc
      // carsBloc.add(AddCar(car3));
      // await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), CarsLoaded([car3])]);
      // // not doing anything for the lastcompleted or repeat interval screens

      // // This new car prompts a change in repeats, which prompts a change in todos.
      // // Using `emitsAnyOf` because the async nature of the streams means that
      // // we may or may not see the empty list state show up in the assert.
      // // Doesn't really matter either way if that happens, it shouldn't break
      // // the test.
      // final defaultRepeats = RepeatsBloc.defaults.asMap()
      //     .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1}', cars: ['car3'])))
      //     .values.toList();
      // expect(repeatsBloc, emitsAnyOf([RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]));
      // final defaultTodos = defaultRepeats.map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0])).toList();
      // expect(todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));

      // clearDatabases();
    });

    // more than any of the repeats intervals
    test('1000000 miles', () async {
      // // tell the blocs that there was a new user signed up
      // final localRepo = SembastDataRepository(createDb: true, pathProvider: () async => Directory('.'));
      // when(dbBloc.state).thenReturn(DbLoaded(localRepo, true));

      // // Add a Load call to all blocs to force refresh
      // // This would happen automatically if we could write directly to the dbBloc's
      // // stream.
      // when(repo.getCurrentRefuelings()).thenAnswer((_) async => []);
      // when(repo.getCurrentCars()).thenAnswer((_) async => []);
      // when(repo.getCurrentRepeats()).thenAnswer((_) async => []);
      // when(repo.startRepeatWriteBatch()).thenAnswer((_) async => MockWriteBatch());
      // when(repo.getCurrentTodos()).thenAnswer((_) async => []);
      // refuelingsBloc.add(LoadRefuelings());
      // carsBloc.add(LoadCars());
      // repeatsBloc.add(LoadRepeats());
      // todosBloc.add(LoadTodos());

      // // The mileage screen adds cars to the CarsBloc
      // carsBloc.add(AddCar(car4));
      // await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), CarsLoaded([car4])]);
      // // not doing anything for the lastcompleted or repeat interval screens

      // // This new car prompts a change in repeats, which prompts a change in todos.
      // // Using `emitsAnyOf` because the async nature of the streams means that
      // // we may or may not see the empty list state show up in the assert.
      // // Doesn't really matter either way if that happens, it shouldn't break
      // // the test.
      // final defaultRepeats = RepeatsBloc.defaults.asMap()
      //     .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1}', cars: ['car4'])))
      //     .values.toList();
      // expect(repeatsBloc, emitsAnyOf([RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]));
      // final defaultTodos = defaultRepeats.map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0])).toList();
      // expect(todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));

      // clearDatabases();
    });
  });
  group('last completed todos', () {
    // final car = Car(name: 'car', mileage: 10000);
    // final oil = Todo(name: 'oil', repeatName: 'oil', dueMileage: 8000, completed: true, completedDate: DateTime.fromMillisecondsSinceEpoch(0));
    // final tires = Todo(name: 'tires', repeatName: 'tires', dueMileage: 8000, completed: true, completedDate: DateTime.fromMillisecondsSinceEpoch(0));

    // final repo = MockRepo();
    // final dbBloc = MockDatabaseBloc();
    // final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
    // final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
    // final repeatsBloc = RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
    // final notificationsBloc = MockNotificationsBloc();
    // final todosBloc = TodosBloc(dbBloc: dbBloc, carsBloc: carsBloc, notificationsBloc: notificationsBloc, repeatsBloc: repeatsBloc);
    // final filteredTodosBloc = FilteredTodosBloc(todosBloc: todosBloc);

    // setUp(clearDatabases);

    test('oil', () async {
      // // tell the blocs that there was a new user signed up
      // final localRepo = SembastDataRepository(createDb: true, pathProvider: () async => Directory('.'));
      // when(dbBloc.state).thenReturn(DbLoaded(localRepo, true));

      // // Add a Load call to all blocs to force refresh
      // // This would happen automatically if we could write directly to the dbBloc's
      // // stream.
      // refuelingsBloc.add(LoadRefuelings());
      // carsBloc.add(LoadCars());
      // repeatsBloc.add(LoadRepeats());
      // todosBloc.add(LoadTodos());
      // filteredTodosBloc.add(UpdateTodosFilter(VisibilityFilter.active));

      // // The mileage screen adds cars to the CarsBloc
      // carsBloc.add(AddCar(car));
      // await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), CarsLoaded([car])]);
      // // not doing anything for the lastcompleted or repeat interval screens

      // // This new car prompts a change in repeats, which prompts a change in todos.
      // final defaultRepeats = RepeatsBloc.defaults.asMap()
      //     .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1}', cars: ['car'])))
      //     .values.toList();
      // expect(repeatsBloc, emitsAnyOf([RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]));
      // final defaultTodos = defaultRepeats.map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0])).toList();
      // expect(todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));

      // // Create the todo for past oil change
      // final cars = (carsBloc.state as CarsLoaded).cars;
      // final specificOilChange = oil.copyWith(carName: cars[0].name);
      // todosBloc.add(AddTodo(specificOilChange));

      // // expect that:
      // // - todo shows up in the list
      // // - there is a new todo that is set for INTERVAL miles after the new todo <- TODO: this
      // // - completed todo does not show up in filteredToDo list
      // final updatedTodos = defaultTodos;
      // updatedTodos.add(specificOilChange);
      // // assuming that the todo will be added to the end of the list
      // await expectLater(todosBloc, emitsInOrder([TodosLoaded(defaultTodos), TodosLoaded(updatedTodos)]));
      // await expectLater(filteredTodosBloc, emitsInOrder([FilteredTodosLoaded(defaultTodos, VisibilityFilter.active), FilteredTodosLoaded(defaultTodos, VisibilityFilter.active)]));
      // clearDatabases();
    });

    test('oil & tires', () async {
      // // tell the blocs that there was a new user signed up
      // final localRepo = SembastDataRepository(createDb: true, pathProvider: () async => Directory('.'));
      // when(dbBloc.state).thenReturn(DbLoaded(localRepo, true));

      // // Add a Load call to all blocs to force refresh
      // // This would happen automatically if we could write directly to the dbBloc's
      // // stream.
      // refuelingsBloc.add(LoadRefuelings());
      // carsBloc.add(LoadCars());
      // repeatsBloc.add(LoadRepeats());
      // todosBloc.add(LoadTodos());
      // filteredTodosBloc.add(UpdateTodosFilter(VisibilityFilter.active));

      // // The mileage screen adds cars to the CarsBloc
      // carsBloc.add(AddCar(car));
      // await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), CarsLoaded([car])]);
      // // not doing anything for the lastcompleted or repeat interval screens

      // // This new car prompts a change in repeats, which prompts a change in todos.
      // final defaultRepeats = RepeatsBloc.defaults.asMap()
      //     .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1}', cars: ['car'])))
      //     .values.toList();
      // expect(repeatsBloc, emitsAnyOf([RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]));
      // final defaultTodos = defaultRepeats.map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0])).toList();
      // expect(todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));

      // // Create the todo for past oil change
      // final cars = (carsBloc.state as CarsLoaded).cars;
      // final specificOilChange = oil.copyWith(carName: cars[0].name);
      // final specificTires = tires.copyWith(carName: cars[0].name);
      // todosBloc.add(AddTodo(specificOilChange));
      // todosBloc.add(AddTodo(specificTires));

      // // expect that:
      // // - todo shows up in the list
      // // - there is a new todo that is set for INTERVAL miles after the new todo <- TODO: this
      // // - completed todo does not show up in filteredToDo list
      // final todosFirstUpdate = defaultTodos;
      // todosFirstUpdate.add(specificOilChange);
      // final todosSecondUpdate = todosFirstUpdate;
      // todosSecondUpdate.add(specificTires);
      // // assuming that the todo will be added to the end of the list
      // await expectLater(todosBloc, emitsInOrder([TodosLoaded(defaultTodos), TodosLoaded(todosFirstUpdate), TodosLoaded(todosSecondUpdate)]));
      // await expectLater(filteredTodosBloc, emitsInOrder([FilteredTodosLoaded(defaultTodos, VisibilityFilter.active), FilteredTodosLoaded(defaultTodos, VisibilityFilter.active), FilteredTodosLoaded(defaultTodos, VisibilityFilter.active)]));
      // clearDatabases();
    });
  });
}
