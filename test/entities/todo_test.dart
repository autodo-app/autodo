import 'package:autodo/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockRecordSnapshot extends Mock implements RecordSnapshot {}

void main() {
  group('TodoEntity', () {
    final todo = Todo(
        id: '',
        name: '',
        carName: '',
        repeatName: '',
        dueState: TodoDueState.DUE_SOON,
        dueMileage: 0,
        notificationID: 0,
        completed: false,
        estimatedDueDate: false,
        completedDate: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        dueDate: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
    test('props', () {
      expect(todo.props, [
        '',
        '',
        '',
        '',
        TodoDueState.DUE_SOON,
        0.0,
        0,
        false,
        false,
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
      ]);
    });
    test('toString', () {
      expect(
          todo.toString(),
          'Todo { id: , name: , carName: , repeatName'
          ': , dueState: ${TodoDueState.DUE_SOON}, dueMileage: 0.0, '
          'notificationID: 0, completed: false, '
          'estimatedDueDate: false, completedDate: '
          '${DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)}, dueDate: '
          '${DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)} }');
    });
    test('fromSnapshot', () {
      final doc = {
        'name': 'name',
        'carName': 'car',
        'repeatName': 'repeat',
        'dueState': 0,
        'dueMileage': 0,
        'notificationID': 0,
        'completed': false,
        'estimatedDueDate': false,
        'completedDate': 0,
        'dueDate': 0,
      };
      final docID = '0';
      final DocumentSnapshot snap = MockDocumentSnapshot();
      when(snap.documentID).thenReturn(docID);
      when(snap.data).thenReturn(doc);
      final todo = Todo(
          id: '0',
          name: 'name',
          carName: 'car',
          repeatName: 'repeat',
          dueState: TodoDueState.values[0],
          dueMileage: 0,
          notificationID: 0,
          completed: false,
          estimatedDueDate: false,
          completedDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueDate: DateTime.fromMillisecondsSinceEpoch(0));
      expect(Todo.fromSnapshot(snap), todo);
    });
    test('fromRecord', () {
      final doc = {
        'name': 'name',
        'carName': 'car',
        'repeatName': 'repeat',
        'dueState': 0,
        'dueMileage': 0.0,
        'notificationID': 0,
        'completed': false,
        'estimatedDueDate': false,
        'completedDate': 0,
        'dueDate': 0,
      };
      final docID = '0';
      final RecordSnapshot snap = MockRecordSnapshot();
      when(snap.key).thenReturn(docID);
      when(snap.value).thenReturn(doc);
      final todo = Todo(
          id: '0',
          name: 'name',
          carName: 'car',
          repeatName: 'repeat',
          dueState: TodoDueState.values[0],
          dueMileage: 0,
          notificationID: 0,
          completed: false,
          estimatedDueDate: false,
          completedDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueDate: DateTime.fromMillisecondsSinceEpoch(0));
      expect(Todo.fromRecord(snap), todo);
    });
  });
}
