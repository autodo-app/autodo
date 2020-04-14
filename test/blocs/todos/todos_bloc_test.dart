import 'dart:io';

import 'package:autodo/repositories/src/sembast_data_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:json_intl/json_intl.dart';
import 'package:mockito/mockito.dart';
import 'package:equatable/equatable.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/units/units.dart';

// ignore: must_be_immutable
class MockDataRepository extends Mock
    with EquatableMixin
    implements DataRepository {}

class MockCarsBloc extends Mock implements CarsBloc {}

class MockNotificationsBloc extends Mock implements NotificationsBloc {}

// ignore: must_be_immutable
class MockWriteBatch extends Mock implements WriteBatchWrapper {}

class MockDbBloc extends Mock implements DatabaseBloc {}

void clearDatabase(Pattern name) {
  for (var f in Directory('.').listSync()) {
    if (f.path.contains(name)) {
      f.deleteSync();
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  clearDatabase('todosBloc.db');
  final sembastTodosDataRepository = await SembastDataRepository.open(
      dbPath: 'todosBloc.db', pathProvider: () => Directory('.'));

  group('TodosBloc', () {
    group('Null Assertions', () {
      test('Null Database Bloc', () {
        final carsBloc = MockCarsBloc();
        final notificationsBloc = MockNotificationsBloc();
        expect(
            () => TodosBloc(
                carsBloc: carsBloc,
                notificationsBloc: notificationsBloc,
                dbBloc: null),
            throwsAssertionError);
      });
      test('Null Cars Bloc', () {
        final dbBloc = MockDbBloc();
        final notificationsBloc = MockNotificationsBloc();
        expect(
            () => TodosBloc(
                carsBloc: null,
                notificationsBloc: notificationsBloc,
                dbBloc: dbBloc),
            throwsAssertionError);
      });
      test('Null NotificationsBloc', () {
        final carsBloc = MockCarsBloc();
        final dbBloc = MockDbBloc();
        expect(
            () => TodosBloc(
                carsBloc: carsBloc, notificationsBloc: null, dbBloc: dbBloc),
            throwsAssertionError);
      });
    });
    group('LoadTodos', () {
      blocTest(
        'Loaded',
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(
              carsBloc,
              Stream.fromIterable([
                CarsLoaded([Car()])
              ]));
          final dataRepository = MockDataRepository();
          when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([
                [Todo()]
              ]));
          when(dataRepository.getCurrentTodos())
              .thenAnswer((_) async => [Todo()]);
          final notificationsBloc = MockNotificationsBloc();
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return TodosBloc(
              dbBloc: dbBloc,
              carsBloc: carsBloc,
              notificationsBloc: notificationsBloc);
        },
        act: (bloc) async => bloc.add(LoadTodos()),
        expect: [
          TodosLoading(),
          TodosLoaded(todos: [Todo()]),
        ],
      );
      blocTest(
        'NotLoaded',
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(
              carsBloc,
              Stream.fromIterable([
                CarsLoaded([Car()])
              ]));
          final dataRepository = MockDataRepository();
          when(dataRepository.todos())
              .thenAnswer((_) => Stream.fromIterable([null]));
          when(dataRepository.getCurrentTodos()).thenAnswer((_) async => []);
          final notificationsBloc = MockNotificationsBloc();
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return TodosBloc(
              dbBloc: dbBloc,
              carsBloc: carsBloc,
              notificationsBloc: notificationsBloc);
        },
        act: (bloc) async => bloc.add(LoadTodos()),
        expect: [
          TodosLoading(),
          TodosLoaded(todos: []),
        ],
      );
      blocTest(
        'Caught Exception',
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(
              carsBloc,
              Stream.fromIterable([
                CarsLoaded([Car()])
              ]));
          final dataRepository = MockDataRepository();
          when(dataRepository.todos()).thenThrow((_) => Exception());
          final notificationsBloc = MockNotificationsBloc();
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return TodosBloc(
              dbBloc: dbBloc,
              carsBloc: carsBloc,
              notificationsBloc: notificationsBloc);
        },
        act: (bloc) async => bloc.add(LoadTodos()),
        expect: [
          TodosLoading(),
          TodosNotLoaded(),
        ],
      );
    });
    final todo1 = Todo(id: '0', dueMileage: 0);
    final todo2 = Todo(id: '0', dueMileage: 1000);
    blocTest(
      'AddTodo',
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([Car()])
            ]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([
              [todo1]
            ]));
        when(dataRepository.getCurrentTodos()).thenAnswer((_) async => [todo1]);
        final notificationsBloc = MockNotificationsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return TodosBloc(
            dbBloc: dbBloc,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(AddTodo(todo2));
      },
      expect: [
        TodosLoading(),
        TodosLoaded(todos: [todo1]),
        TodosLoaded(todos: [todo1, todo2]),
      ],
    );
    blocTest(
      'AddMultipleTodos',
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([Car()])
            ]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([
              []
            ]));
        when(dataRepository.getCurrentTodos()).thenAnswer((_) async => []);
        final notificationsBloc = MockNotificationsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        final writeBatch = MockWriteBatch();
        when(writeBatch.updateData(any, any)).thenAnswer((invoke) {});
        when(writeBatch.setData(any)).thenAnswer((invoke) {});
        when(writeBatch.commit()).thenAnswer((_) async {});
        when(dataRepository.startTodoWriteBatch())
            .thenAnswer((_) => writeBatch);
        return TodosBloc(
            dbBloc: dbBloc,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(AddMultipleTodos([todo1, todo2]));
      },
      expect: [
        TodosLoading(),
        TodosLoaded(todos: []),
        TodosLoaded(todos: [todo1, todo2]),
        TodosLoaded(todos: []), // this is just from when the data repo contents are put up again
      ],
    );
    blocTest(
      'UpdateTodo',
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([Car()])
            ]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([
              [todo1]
            ]));
        when(dataRepository.getCurrentTodos()).thenAnswer((_) async => [todo1]);
        final notificationsBloc = MockNotificationsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return TodosBloc(
            dbBloc: dbBloc,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(UpdateTodo(todo1.copyWith(dueMileage: 1000)));
      },
      expect: [
        TodosLoading(),
        TodosLoaded(todos: [todo1]),
        TodosLoaded(todos: [todo1.copyWith(dueMileage: 1000)]),
      ],
    );
    blocTest(
      'DeleteTodo',
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([Car()])
            ]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([
              [todo1]
            ]));
        when(dataRepository.getCurrentTodos()).thenAnswer((_) async => [todo1]);
        final notificationsBloc = MockNotificationsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return TodosBloc(
            dbBloc: dbBloc,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(DeleteTodo(todo1));
      },
      expect: [
        TodosLoading(),
        TodosLoaded(todos: [todo1]),
        TodosLoaded(todos: []),
      ],
    );
    blocTest(
      'ToggleAll',
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([Car()])
            ]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([
              [todo1.copyWith(completed: false)]
            ]));
        when(dataRepository.getCurrentTodos())
            .thenAnswer((_) async => [todo1.copyWith(completed: false)]);
        final notificationsBloc = MockNotificationsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return TodosBloc(
            dbBloc: dbBloc,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(ToggleAll());
      },
      expect: [
        TodosLoading(),
        TodosLoaded(todos: [todo1.copyWith(completed: false)]),
        TodosLoaded(todos: [todo1.copyWith(completed: true)]),
      ],
    );
    final car1 = Car(
        id: '0',
        name: 'test',
        mileage: 1000,
        lastMileageUpdate: DateTime.fromMillisecondsSinceEpoch(0),
        distanceRate: 1.0);
    final todo3 = Todo(
        id: '0',
        carName: 'test',
        dueMileage: 1000,
        estimatedDueDate: true,
        mileageRepeatInterval: 1000,
        dateRepeatInterval: RepeatInterval());
    final defaults = TodosBloc.defaultsImperial
        .asMap()
        .map((k, t) => MapEntry(
            k,
            t.copyWith(
                id: '${k + 1}',
                carName: 'test',
                dueMileage: t.mileageRepeatInterval,
                dateRepeatInterval: RepeatInterval())))
        .values
        .toList();
    // final defaultsWithDates = List<Todo>.from(defaults)
    //   .map((t) => t.copyWith(dueDate: TodosBloc.calcDueDate(car1, t.dueMileage), estimatedDueDate: true))
    //   .toList();
    blocTest(
      'CarsUpdated',
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([car1])
            ]));
        when(carsBloc.state).thenReturn(CarsLoaded([car1]));
        final notificationsBloc = MockNotificationsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state)
            .thenAnswer((_) => DbLoaded(sembastTodosDataRepository));
        return TodosBloc(
            dbBloc: dbBloc,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(TranslateDefaults(JsonIntl.mock, DistanceUnit.imperial));
        bloc.add(CarsUpdated([car1]));
      },
      expect: [
        TodosLoading(),
        TodosLoaded(todos: []),
        TodosLoaded(todos: [], defaults: TodosBloc.defaultsImperial),
        TodosLoaded(todos: defaults, defaults: []),
        // TodosLoaded(todos: defaultsWithDates, defaults: [])
      ],
    );
    final completedTodos = [todo3];
    blocTest(
      'CompletedTodo',
      build: () {
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([car1]));

        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([
              [todo3]
            ]));
        when(dataRepository.getCurrentTodos())
            .thenAnswer((_) async => completedTodos);

        // TODO: intercept the write batch calls to check that things are updated properly
        // when(dataRepository.addNewTodo(todo3)).thenAnswer((_) async {});
        // when(dataRepository.updateTodo(todo3)).thenAnswer((_) async {});
        final writeBatch = MockWriteBatch();
        when(writeBatch.updateData(todo3.id, dynamic)).thenAnswer((invoke) {
          print(invoke.positionalArguments[1]);
          completedTodos[0] = invoke.positionalArguments[1];
        });
        when(writeBatch.setData(dynamic)).thenAnswer((invoke) {
          completedTodos.add(invoke.positionalArguments[0]);
        });
        when(writeBatch.commit()).thenAnswer((_) async {});
        when(dataRepository.startTodoWriteBatch())
            .thenAnswer((_) => writeBatch);

        final notificationsBloc = MockNotificationsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return TodosBloc(
            dbBloc: dbBloc,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(CompleteTodo(todo3, DateTime.fromMillisecondsSinceEpoch(0)));
      },
      expect: [
        TodosLoading(),
        TodosLoaded(todos: [todo3]),
        TodosLoaded(todos: [
          todo3.copyWith(
              completed: true,
              completedDate: DateTime.fromMillisecondsSinceEpoch(0),
              completedMileage: car1.mileage),
          todo3.copyWith(
              dueMileage: 2000,
              dueDate: DateTime.fromMillisecondsSinceEpoch(0)
                  .add(Duration(days: 1000)),
              estimatedDueDate: true)
        ]),
        TodosLoaded(todos: [
          todo3
        ]), // the database doesn't update properly in unit tests so it will overwrite the correct value
      ],
    );
    blocTest(
      'Subscription',
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.todos())
            .thenAnswer((_) => Stream<List<Todo>>.fromIterable([
                  [Todo()]
                ]));
        when(dataRepository.getCurrentTodos())
            .thenAnswer((_) async => [Todo()]);
        final dbBloc = MockDbBloc();
        whenListen(dbBloc, Stream.fromIterable([DbLoaded(dataRepository)]));
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));

        final carsBloc = MockCarsBloc();
        final notificationsBloc = MockNotificationsBloc();
        return TodosBloc(
            dbBloc: dbBloc,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc);
      },
      expect: [
        TodosLoading(),
        TodosLoaded(todos: [Todo()]),
      ],
    );
  });
}
