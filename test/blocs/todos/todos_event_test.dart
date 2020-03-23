import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('TodosEvents', () {
    test('LoadTodos props', () {
      expect(LoadTodos().props, []);
    });
    group('AddTodo', () {
      test('props', () {
        expect(AddTodo(Todo()).props, [Todo()]);
      });
      test('toString', () {
        expect(AddTodo(Todo()).toString(), 'AddTodo { todo: ${Todo()} }');
      });
    });
    group('UpdateTodo', () {
      test('props', () {
        expect(UpdateTodo(Todo()).props, [Todo()]);
      });
      test('toString', () {
        expect(UpdateTodo(Todo()).toString(),
            'UpdateTodo { updatedTodo: ${Todo()} }');
      });
    });
    group('DeleteTodo', () {
      test('props', () {
        expect(DeleteTodo(Todo()).props, [Todo()]);
      });
      test('toString', () {
        expect(DeleteTodo(Todo()).toString(), 'DeleteTodo { todo: ${Todo()} }');
      });
    });
    group('CarsUpdated', () {
      test('props', () {
        expect(CarsUpdated([Car()]).props, [
          [Car()]
        ]);
      });
      test('toString', () {
        expect(CarsUpdated([Car()]).toString(),
            'CarsUpdated { cars: ${[Car()]} }');
      });
    });
    group('CompleteTodo', () {
      test('props', () {
        expect(
            CompleteTodo(Todo(), DateTime.fromMillisecondsSinceEpoch(0)).props,
            [Todo(), DateTime.fromMillisecondsSinceEpoch(0)]);
      });
      test('toString', () {
        expect(
            CompleteTodo(Todo(), DateTime.fromMillisecondsSinceEpoch(0))
                .toString(),
            'CompleteTodo { todo: ${Todo()}, completedDate: ${DateTime.fromMillisecondsSinceEpoch(0)} }');
      });
    });
  });
}
