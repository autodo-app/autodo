import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'setup.dart';

void main() {
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
        FilteredTodoDataUpdated(todos: [todo]).toString(),
        'FilteredTodoDataUpdated { todos: [$todo] }',
      );
    });
    test('props are correct', () {
      expect(
        FilteredTodoDataUpdated(todos: [todo]).props,
        [
          [todo]
        ],
      );
    });
  });
}
