import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  group('FilteredTodosBloc', () {
    final todo = Todo(
        name: 'Oil',
        id: '0',
        carName: '',
        repeatName: '',
        dueState: TodoDueState.DUE_SOON,
        dueMileage: 1000,
        notificationID: 0,
        completed: false,
        estimatedDueDate: false,
        completedDate: DateTime.now(),
        dueDate: DateTime.now());
    blocTest<FilteredTodosBloc, FilteredTodosEvent, FilteredTodosState>(
        'adds TodosUpdated when TodosBloc.state emits TodosLoaded', build: () {
      final todosBloc = MockTodosBloc();
      when(todosBloc.state).thenReturn(TodosLoaded([todo]));
      whenListen(
        todosBloc,
        Stream<TodosState>.fromIterable([
          TodosLoaded([todo])
        ]),
      );
      return FilteredTodosBloc(todosBloc: todosBloc);
    }, expect: [
      FilteredTodosLoaded(
        [todo],
        VisibilityFilter.all,
      ),
    ]);

    blocTest<FilteredTodosBloc, FilteredTodosEvent, FilteredTodosState>(
      'should update the VisibilityFilter when filter is active',
      build: () {
        final todosBloc = MockTodosBloc();
        when(todosBloc.state).thenReturn(TodosLoaded([todo]));
        return FilteredTodosBloc(todosBloc: todosBloc);
      },
      act: (FilteredTodosBloc bloc) async =>
          bloc.add(UpdateTodosFilter(VisibilityFilter.active)),
      expect: <FilteredTodosState>[
        FilteredTodosLoaded(
          [todo],
          VisibilityFilter.all,
        ),
        FilteredTodosLoaded(
          [todo],
          VisibilityFilter.active,
        ),
      ],
    );

    blocTest<FilteredTodosBloc, FilteredTodosEvent, FilteredTodosState>(
      'should update the VisibilityFilter when filter is completed',
      build: () {
        final todosBloc = MockTodosBloc();
        when(todosBloc.state).thenReturn(TodosLoaded([todo]));
        return FilteredTodosBloc(todosBloc: todosBloc);
      },
      act: (FilteredTodosBloc bloc) async =>
          bloc.add(UpdateTodosFilter(VisibilityFilter.completed)),
      expect: <FilteredTodosState>[
        FilteredTodosLoaded(
          [todo],
          VisibilityFilter.all,
        ),
        FilteredTodosLoaded([], VisibilityFilter.completed),
      ],
    );

    group('Sort Items', () {
      final todo1 = Todo(id: '0', dueMileage: 0);
      final todo2 = Todo(id: '0', dueMileage: 1000);
      test('No dates', () {
        expect(FilteredTodosBloc.sortItems([todo1, todo2]), [todo1, todo2]);
      });
      test('Valid Date A', () {
        expect(
            FilteredTodosBloc.sortItems([
              todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),
              todo2
            ]),
            [
              todo2,
              todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),
            ]);
      });
      test('Valid Date B', () {
        expect(
            FilteredTodosBloc.sortItems([
              todo1,
              todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0))
            ]),
            [
              todo1,
              todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0))
            ]);
      });
      test('Both valid dates', () {
        expect(
            FilteredTodosBloc.sortItems([
              todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),
              todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(100))
            ]),
            [
              todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),
              todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(100))
            ]);
      });
    });
  });
}
