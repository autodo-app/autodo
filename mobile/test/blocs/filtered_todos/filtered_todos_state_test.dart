import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'setup.dart';

void main() {
  group('FilteredTodosState', () {
    test('props are correct', () {
      expect(
        FilteredTodosLoading().props,
        [],
      );
    });
    group('FilteredTodosLoaded', () {
      test('toString returns correct value', () {
        expect(
          FilteredTodosLoaded({
            TodoDueState.DUE_SOON: [todo]
          }, VisibilityFilter.active)
              .toString(),
          'FilteredTodosLoaded { filteredTodos: {TodoDueState.DUE_SOON: [$todo]}, activeFilter: VisibilityFilter.active }',
        );
      });
      test('props are correct', () {
        expect(
          FilteredTodosLoaded({
            TodoDueState.DUE_SOON: [todo]
          }, VisibilityFilter.active)
              .props,
          [
            {
              TodoDueState.DUE_SOON: [todo]
            },
            VisibilityFilter.active
          ],
        );
      });
    });
  });
}
