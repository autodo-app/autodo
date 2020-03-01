import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

import 'package:autodo/models/models.dart';

class TodoEntity extends Equatable {
  const TodoEntity(
      this.id,
      this.name,
      this.carName,
      this.repeatName,
      this.dueState,
      this.dueMileage,
      this.notificationID,
      this.completed,
      this.estimatedDueDate,
      this.completedDate,
      this.dueDate);

  final String id, name, carName, repeatName;

  final TodoDueState dueState;

  final double dueMileage;

  final int notificationID;

  final bool completed, estimatedDueDate;

  final DateTime completedDate, dueDate;

  @override
  List<Object> get props => [
        id,
        name,
        carName,
        repeatName,
        dueState,
        dueMileage,
        notificationID,
        completed,
        estimatedDueDate,
        completedDate,
        dueDate
      ];

  @override
  String toString() {
    return 'TodoEntity { id: $id, name: $name, carName: $carName, repeatName: '
        '$repeatName, dueState: $dueState, dueMileage: $dueMileage, notificationID: '
        '$notificationID, completed: $completed, estimatedDueDate: $estimatedDueDate, '
        'completedDate: $completedDate, dueDate: $dueDate }';
  }

  static TodoEntity fromSnapshot(DocumentSnapshot snap) {
    return TodoEntity(
      snap.documentID,
      snap.data['name'] as String,
      snap.data['carName'] as String,
      snap.data['repeatName'] as String,
      (snap.data['dueState'] == null)
          ? null
          : TodoDueState.values[snap.data['dueState']],
      (snap.data['dueMileage'] as num).toDouble(),
      snap.data['notificationID'] as int,
      snap.data['completed'] as bool,
      snap.data['estimatedDueDate'] as bool,
      (snap.data['completedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.data['completedDate']),
      (snap.data['dueDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.data['dueDate']),
    );
  }

  static TodoEntity fromRecord(RecordSnapshot snap) {
    return TodoEntity(
      (snap.key is String) ? snap.key : '${snap.key}',
      snap.value['name'] as String,
      snap.value['carName'] as String,
      snap.value['repeatName'] as String,
      (snap.value['dueState'] == null)
          ? null
          : TodoDueState.values[snap.value['dueState']],
      snap.value['dueMileage'] as double,
      snap.value['notificationID'] as int,
      snap.value['completed'] as bool,
      snap.value['estimatedDueDate'] as bool,
      (snap.value['completedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.value['completedDate']),
      (snap.value['dueDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.value['dueDate']),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'carName': carName,
      'repeatName': repeatName,
      'dueState': dueState?.index,
      'dueMileage': dueMileage,
      'notificationID': notificationID,
      'completed': completed,
      'estimatedDueDate': estimatedDueDate,
      'completedDate': completedDate?.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch
    };
  }
}
