import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';

class MockDataRepository extends Mock with EquatableMixin implements DataRepository {}
class MockCarsBloc extends Mock implements CarsBloc {}
class MockRepeatsBloc extends Mock implements RepeatsBloc {}
class MockNotificationsBloc extends Mock implements NotificationsBloc {}
class MockWriteBatch extends Mock implements WriteBatchWrapper {}

void main() {
  group('RefuelingsBloc', () {
    group('Null Assertions', () { 
      test('Null Data Repository', () {
        final carsBloc = MockCarsBloc();
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        expect(() => TodosBloc(
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc,
          dataRepository: null
        ), throwsAssertionError);
      });
      test('Null Cars Bloc', () {
        final dataRepository = MockDataRepository();
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        expect(() => TodosBloc(
          carsBloc: null,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc,
          dataRepository: dataRepository
        ), throwsAssertionError);
      });
      test('Null NotificationsBloc', () {
        final carsBloc = MockCarsBloc();
        final dataRepository = MockDataRepository();
        final repeatsBloc = MockRepeatsBloc();
        expect(() => TodosBloc(
          carsBloc: carsBloc,
          notificationsBloc: null,
          repeatsBloc: repeatsBloc,
          dataRepository: dataRepository
        ), throwsAssertionError);
      });
      test('Null RepeatsBloc', () {
        final carsBloc = MockCarsBloc();
        final notificationsBloc = MockNotificationsBloc();
        final dataRepository = MockDataRepository();
        expect(() => TodosBloc(
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: null,
          dataRepository: dataRepository
        ), throwsAssertionError);
      });
    });
    group('LoadTodos', () {
      blocTest('Loaded', 
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(carsBloc, Stream.fromIterable([[Car()]]));
          final dataRepository = MockDataRepository();
          when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([[Todo()]]));
          final notificationsBloc = MockNotificationsBloc();
          final repeatsBloc = MockRepeatsBloc();
          whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
          return TodosBloc(
            dataRepository: dataRepository,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc,
            repeatsBloc: repeatsBloc
          );
        },
        act: (bloc) async => bloc.add(LoadTodos()),
        expect: [ 
          TodosLoading(),
          TodosLoaded([Todo()]),
        ],
      );
      blocTest('NotLoaded', 
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(carsBloc, Stream.fromIterable([[Car()]]));
          final dataRepository = MockDataRepository();
          when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([null]));
          final notificationsBloc = MockNotificationsBloc();
          final repeatsBloc = MockRepeatsBloc();
          whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
          return TodosBloc(
            dataRepository: dataRepository,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc,
            repeatsBloc: repeatsBloc
          );
        },
        act: (bloc) async => bloc.add(LoadTodos()),
        expect: [ 
          TodosLoading(),
          TodosNotLoaded(),
        ],
      );
      blocTest('Caught Exception', 
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(carsBloc, Stream.fromIterable([[Car()]]));
          final dataRepository = MockDataRepository();
          when(dataRepository.todos()).thenThrow((_) => Exception());
          final notificationsBloc = MockNotificationsBloc();
          final repeatsBloc = MockRepeatsBloc();
          whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
          return TodosBloc(
            dataRepository: dataRepository,
            carsBloc: carsBloc,
            notificationsBloc: notificationsBloc,
            repeatsBloc: repeatsBloc
          );
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
    blocTest('AddTodo', 
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([[Car()]]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([[todo1]]));
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
        return TodosBloc(
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(AddTodo(todo2));
      },
      expect: [ 
        TodosLoading(),
        TodosLoaded([todo1]),
        TodosLoaded([todo1, todo2]),
      ],
    );
    blocTest('UpdateTodo', 
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([[Car()]]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([[todo1]]));
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
        return TodosBloc(
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(UpdateTodo(todo1.copyWith(dueMileage: 1000)));
      },
      expect: [ 
        TodosLoading(),
        TodosLoaded([todo1]),
        TodosLoaded([todo1.copyWith(dueMileage: 1000)]),
      ],
    );
    blocTest('DeleteTodo', 
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([[Car()]]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([[todo1]]));
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
        return TodosBloc(
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(DeleteTodo(todo1));
      },
      expect: [ 
        TodosLoading(),
        TodosLoaded([todo1]),
        TodosLoaded([]),
      ],
    );
    blocTest('ToggleAll', 
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([[Car()]]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([[todo1.copyWith(completed: false)]]));
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
        return TodosBloc(
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(ToggleAll());
      },
      expect: [ 
        TodosLoading(),
        TodosLoaded([todo1.copyWith(completed: false)]),
        TodosLoaded([todo1.copyWith(completed: true)]),
      ],
    );
    final car = Car(
      id: '0',
      name: 'test',
      mileage: 1000,
      distanceRate: 1.0,
      lastMileageUpdate: DateTime.fromMillisecondsSinceEpoch(0).toUtc()
    );
    final todo3 = Todo(id: '0', carName: 'test', dueMileage: 2000, estimatedDueDate: true);
    blocTest('UpdateDueDates', 
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([CarsLoaded([car])]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) 
        => Stream.fromIterable([[todo3]]));
        final writeBatch = MockWriteBatch();
        when(writeBatch.updateData(todo3.id, dynamic)).thenAnswer((_) => ((_) => _));
        when(writeBatch.commit()).thenAnswer((_) => (() => _));
        when(dataRepository.startTodoWriteBatch()).thenAnswer((_) => writeBatch);
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
        return TodosBloc(
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(UpdateDueDates([car.copyWith(distanceRate: 2.0)]));
      },
      expect: [ 
        TodosLoading(),
        TodosLoaded([todo3]),
        TodosLoaded([todo3.copyWith(dueDate: DateTime.parse('1971-05-16 00:00:00.000Z'), estimatedDueDate: true)]),
      ],
    );
    blocTest('CompletedTodo', 
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([CarsLoaded([car])]));
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([car]));

        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) 
        => Stream.fromIterable([[todo3]]));
        when(dataRepository.addNewTodo(todo3)).thenAnswer((_) async {});
        when(dataRepository.updateTodo(todo3)).thenAnswer((_) async {});
        final writeBatch = MockWriteBatch();
        when(writeBatch.updateData(todo3.id, dynamic)).thenAnswer((_) => ((_) => _));
        when(writeBatch.commit()).thenAnswer((_) => (() => _));
        when(dataRepository.startTodoWriteBatch()).thenAnswer((_) => writeBatch);
        
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
        when(repeatsBloc.state).thenAnswer((_) => RepeatsLoaded([Repeat()]));
        return TodosBloc(
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(CompleteTodo(todo3, DateTime.fromMillisecondsSinceEpoch(0)));
      },
      expect: [ 
        TodosLoading(),
        TodosLoaded([todo3]),
        TodosLoaded([todo3.copyWith(completed: true, completedDate: DateTime.fromMillisecondsSinceEpoch(0))]),
      ],
    );
    blocTest('RepeatsRefresh', 
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([[Car()]]));
        final dataRepository = MockDataRepository();
        when(dataRepository.todos()).thenAnswer((_) => Stream.fromIterable([[todo1]]));
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        whenListen(repeatsBloc, Stream.fromIterable([RepeatsLoaded([Repeat()])]));
        return TodosBloc(
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
      },
      act: (bloc) async {
        bloc.add(LoadTodos());
        bloc.add(RepeatsRefresh([Repeat()]));
      },
      expect: [ 
        TodosLoading(),
        TodosLoaded([todo1]),
      ],
    );
    group('Sort Items', () {
      test('No dates', () {
        final dataRepository = MockDataRepository();
        final carsBloc = MockCarsBloc();
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        final todosBloc = TodosBloc(  
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
        expect(
          todosBloc.sortItems([todo1, todo2]),
          [todo1, todo2]
        );
      });
      test('Valid Date A', () {
        final dataRepository = MockDataRepository();
        final carsBloc = MockCarsBloc();
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        final todosBloc = TodosBloc(  
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
        expect(
          todosBloc.sortItems([todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)), todo2]),
          [todo2, todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),]
        );
      });
      test('Valid Date B', () {
        final dataRepository = MockDataRepository();
        final carsBloc = MockCarsBloc();
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        final todosBloc = TodosBloc(  
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
        expect(
          todosBloc.sortItems([todo1, todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0))]),
          [todo1, todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0))]
        );
      });
      test('Both valid dates', () {
        final dataRepository = MockDataRepository();
        final carsBloc = MockCarsBloc();
        final notificationsBloc = MockNotificationsBloc();
        final repeatsBloc = MockRepeatsBloc();
        final todosBloc = TodosBloc(  
          dataRepository: dataRepository,
          carsBloc: carsBloc,
          notificationsBloc: notificationsBloc,
          repeatsBloc: repeatsBloc
        );
        expect(
          todosBloc.sortItems([
            todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)), 
            todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(100))
          ]),
          [todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)), todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(100))]
        );
      });
    });
  });
}