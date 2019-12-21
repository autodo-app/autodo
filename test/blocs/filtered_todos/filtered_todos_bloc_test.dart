import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';

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
      dueDate: DateTime.now()
    );
    blocTest<FilteredTodosBloc, FilteredTodosEvent, FilteredTodosState>(
      'adds TodosUpdated when TodosBloc.state emits TodosLoaded',
      build: () {
        final todosBloc = MockTodosBloc();
        when(todosBloc.state).thenReturn(TodosLoaded([todo]));
        whenListen(
          todosBloc,
          Stream<TodosState>.fromIterable([TodosLoaded([todo])]),
        );
        return FilteredTodosBloc(todosBloc: todosBloc);
      }, 
      expect: [
        FilteredTodosLoaded(
          [todo],
          VisibilityFilter.all,
        ),
      ]
    );

    blocTest<FilteredTodosBloc, FilteredTodosEvent, FilteredTodosState>(
      'should update the VisibilityFilter when filter is active',
      build: () {
        final todosBloc = MockTodosBloc();
        when(todosBloc.state)
            .thenReturn(TodosLoaded([todo]));
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
        when(todosBloc.state)
            .thenReturn(TodosLoaded([todo]));
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
  }); 
}