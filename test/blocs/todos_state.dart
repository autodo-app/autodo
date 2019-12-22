/// From https://github.com/brianegan/flutter_architecture_samples/blob/master/bloc_library/test/blocs/todos_state_test.dart
import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
    group('TodosState', () {
    group('TodosLoading', () {
      test('toString returns correct value', () {
        expect(
          TodosLoading().toString(),
          'TodosLoading',
        );
      });
    });

    group('TodosLoaded', () {
      test('toString returns correct value', () {
        expect(
          TodosLoaded([Todo(name: 'wash car', id: '0')]).toString(),
          'TodosLoaded { todos: [${Todo(name: "wash car", id: "0")}] }',
        );
      });
    });

    group('TodosNotLoaded', () {
      test('toString returns correct value', () {
        expect(
          TodosNotLoaded().toString(),
          'TodosNotLoaded',
        );
      });
    });
  });
}