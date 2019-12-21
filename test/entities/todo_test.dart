import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/entities/barrel.dart';
import 'package:autodo/models/todo_due_state.dart';

void main() {
  group('TodoEntity', () {
    final todo = TodoEntity('', '', '', '', TodoDueState.DUE_SOON, 0, 0, false, false, DateTime.fromMillisecondsSinceEpoch(0), DateTime.fromMillisecondsSinceEpoch(0));
    test('props', () {
      expect(todo.props, ['', '', '', '', TodoDueState.DUE_SOON, 0, 0, false, false, DateTime.fromMillisecondsSinceEpoch(0), DateTime.fromMillisecondsSinceEpoch(0)]);
    });
    test('toString', () {
      expect(todo.toString(), 'TodoEntity { id: , name: , carName: , repeatName'
      ': , dueState: ${TodoDueState.DUE_SOON}, dueMileage: 0, notificationID: '
      '0, completed: false, estimatedDueDate: false, completedDate: '
      '${DateTime.fromMillisecondsSinceEpoch(0)}, dueDate: ${DateTime.fromMillisecondsSinceEpoch(0)} }');
    });
  });
}