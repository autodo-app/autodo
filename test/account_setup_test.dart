import 'dart:io';

import 'package:autodo/repositories/src/sembast_data_repository.dart';
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

    final repo = MockRepo();
    final batch = MockWriteBatch();
    final dbBloc = MockDatabaseBloc();
    final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
    final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
    final repeatsBloc = RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
    final notificationsBloc = MockNotificationsBloc();
    final todosBloc = TodosBloc(dbBloc: dbBloc, carsBloc: carsBloc, notificationsBloc: notificationsBloc, repeatsBloc: repeatsBloc);

    setUp(() {
      for (var f in Directory('.').listSync()) {
        if (f.path.contains('.db')) {
          f.deleteSync();
        }
      }
    });

    test('1 car, no prev todos', () async {
      // tell the blocs that there was a new user signed up
      final localRepo = SembastDataRepository(createDb: true, pathProvider: () async => Directory('.'));
      when(dbBloc.state).thenReturn(DbLoaded(localRepo, true));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      when(repo.getCurrentRefuelings()).thenAnswer((_) async => []);
      when(repo.getCurrentCars()).thenAnswer((_) async => []);
      when(repo.getCurrentRepeats()).thenAnswer((_) async => []);
      when(repo.startRepeatWriteBatch()).thenAnswer((_) async => MockWriteBatch());
      when(repo.getCurrentTodos()).thenAnswer((_) async => []);
      refuelingsBloc.add(LoadRefuelings());
      carsBloc.add(LoadCars());
      repeatsBloc.add(LoadRepeats());
      todosBloc.add(LoadTodos());

      // The mileage screen adds cars to the CarsBloc
      carsBloc.add(AddCar(car1));
      await emitsExactly(carsBloc, [CarsLoading(), CarsLoaded([]), CarsLoaded([car1])]);
      // not doing anything for the lastcompleted or repeat interval screens

      // This new car prompts a change in repeats, which prompts a change in todos.
      // Using `emitsAnyOf` because the async nature of the streams means that
      // we may or may not see the empty list state show up in the assert.
      // Doesn't really matter either way if that happens, it shouldn't break
      // the test.
      final defaultRepeats = RepeatsBloc.defaults.asMap()
          .map((k,v) => MapEntry(k, v.copyWith(id: '${k + 1}', cars: ['car1'])))
          .values.toList();
      expect(repeatsBloc, emitsAnyOf([RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]));
      // await emitsExactly(repeatsBloc, [RepeatsLoaded([]), RepeatsLoaded(defaultRepeats)]);
      final defaultTodos = defaultRepeats.map((e) => Todo(id: e.id, name: e.name, carName: e.cars[0])).toList();
      expect(todosBloc, emitsAnyOf([TodosLoaded([]), TodosLoaded(defaultTodos)]));
    });
  });
  group('car mileage', () {

  });
  group('last completed todos', () {

  });
}