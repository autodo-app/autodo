import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'setup.dart';

void main() {
  group('FilteredTodosBloc', () {
    blocTest<FilteredTodosBloc, FilteredTodosEvent, FilteredTodosState>(
        'adds TodosUpdated when TodosBloc.state emits TodosLoaded',
      build: buildFunc, 
      expect: [
      FilteredTodosLoaded(
        {
          TodoDueState.DUE_SOON: [todo]
        },
        VisibilityFilter.all,
      ),
    ]);

    blocTest<FilteredTodosBloc, FilteredTodosEvent, FilteredTodosState>(
      'should update the VisibilityFilter when filter is active',
      build: buildFunc,
      act: (FilteredTodosBloc bloc) async =>
          bloc.add(UpdateTodosFilter(VisibilityFilter.active)),
      expect: <FilteredTodosState>[
        FilteredTodosLoading(),
        // FilteredTodosLoaded(
        //   {
        //     TodoDueState.DUE_SOON: [todo]
        //   },
        //   VisibilityFilter.all,
        // ),
        FilteredTodosLoaded(
          {
            TodoDueState.DUE_SOON: [todo]
          },
          VisibilityFilter.active,
        ),
      ],
    );

    blocTest<FilteredTodosBloc, FilteredTodosEvent, FilteredTodosState>(
      'should update the VisibilityFilter when filter is completed',
      build: buildFunc,
      act: (FilteredTodosBloc bloc) async =>
          bloc.add(UpdateTodosFilter(VisibilityFilter.completed)),
      expect: <FilteredTodosState>[
        FilteredTodosLoading(),
        // FilteredTodosLoaded(
        //   {
        //     TodoDueState.DUE_SOON: [todo]
        //   },
        //   VisibilityFilter.all,
        // ),
        FilteredTodosLoaded({}, VisibilityFilter.completed),
      ],
    );

    group('Sort Items', () {
      final todo1 = Todo(id: '0', dueMileage: 0);
      final todo2 = Todo(id: '0', dueMileage: 1000);
      test('No dates', () {
        expect(FilteredTodosBloc.sortItems([todo1, todo2]), {
          null: [todo1, todo2]
        });
      });
      test('Valid Date A', () {
        expect(
            FilteredTodosBloc.sortItems([
              todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),
              todo2
            ]),
            {
              null: [
                todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),
                todo2,
              ]
            });
      });
      test('Valid Date B', () {
        expect(
            FilteredTodosBloc.sortItems([
              todo1,
              todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0))
            ]),
            {
              null: [
                todo1,
                todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0))
              ]
            });
      });
      test('Both valid dates', () {
        expect(
            FilteredTodosBloc.sortItems([
              todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),
              todo2.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(100))
            ]),
            {
              null: [
                todo1.copyWith(dueDate: DateTime.fromMillisecondsSinceEpoch(0)),
                todo2.copyWith(
                    dueDate: DateTime.fromMillisecondsSinceEpoch(100))
              ]
            });
      });
    });
  });
}
