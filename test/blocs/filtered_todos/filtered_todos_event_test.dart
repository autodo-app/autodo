import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  group('FilteredTodosEvent', () {
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
      completedDate: DateTime.fromMillisecondsSinceEpoch(0),
      dueDate: DateTime.fromMillisecondsSinceEpoch(0)
    );
    group('UpdateFilter', () {
      test('toString returns correct value', () {
        expect(
          UpdateTodosFilter(VisibilityFilter.active).toString(),
          'UpdateFilter { filter: VisibilityFilter.active }',
        );
      });
      test('props are correct', () {
        expect(  
          UpdateTodosFilter(VisibilityFilter.active).props,
          [VisibilityFilter.active],
        );
      });
    });

    group('UpdateTodos', () {
      test('toString returns correct value', () {
        expect(
          UpdateTodos([todo]).toString(),
          'UpdateTodos { todos: [$todo] }',
        );
      });
      test('props are correct', () {
        expect(
          UpdateTodos([todo]).props,
          [[todo]],
        );
      });
    });
  });
}