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
    final dbBloc = MockDatabaseBloc();
    final refuelingsBloc = RefuelingsBloc(dbBloc: dbBloc);
    final carsBloc = CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
    final repeatsBloc = RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
    final notificationsBloc = MockNotificationsBloc();
    final todosBloc = TodosBloc(dbBloc: dbBloc, carsBloc: carsBloc, notificationsBloc: notificationsBloc, repeatsBloc: repeatsBloc);

    test('1 car, no prev todos', () async {
      // tell the blocs that there was a new user signed up
      when(dbBloc.state).thenReturn(DbLoaded(repo, true));

      // Add a Load call to all blocs to force refresh
      // This would happen automatically if we could write directly to the dbBloc's
      // stream.
      when(repo.getCurrentRefuelings()).thenAnswer((_) async => []);
      when(repo.getCurrentCars()).thenAnswer((_) async => []);
      when(repo.getCurrentRepeats()).thenAnswer((_) async => []);
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
      // TODO: figure out how these blocs are listening, because there are
      // currently no updates to this stream
      await emitsExactly(repeatsBloc, [RepeatsLoaded([]), RepeatsLoaded([Repeat()])]);
      await emitsExactly(todosBloc, [TodosLoaded([]), TodosLoaded([Todo()])]);
    });
  });
  group('car mileage', () {

  });
  group('last completed todos', () {

  });
}