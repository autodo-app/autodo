import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  group('FilteredTodosState', () {
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
        dueDate: DateTime.fromMillisecondsSinceEpoch(0));
    test('props are correct', () {
      expect(
        FilteredTodosLoading().props,
        [],
      );
    });
    group('FilteredTodosLoaded', () {
      test('toString returns correct value', () {
        expect(
          FilteredTodosLoaded([todo], VisibilityFilter.active).toString(),
          'FilteredTodosLoaded { filteredTodos: [$todo], activeFilter: VisibilityFilter.active }',
        );
      });
      test('props are correct', () {
        expect(
          FilteredTodosLoaded([todo], VisibilityFilter.active).props,
          [
            [todo],
            VisibilityFilter.active
          ],
        );
      });
    });
  });
}
