import 'package:autodo/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

@immutable
class Todo extends Equatable {
  const Todo(
      {this.id,
      this.name,
      this.carName,
      this.repeatName,
      this.dueState,
      this.dueMileage,
      this.notificationID,
      this.completed,
      this.estimatedDueDate,
      this.completedDate,
      this.dueDate});

  factory Todo.fromSnapshot(DocumentSnapshot snap) {
    return Todo(
      id: snap.documentID,
      name: snap.data['name'] as String,
      carName: snap.data['carName'] as String,
      repeatName: snap.data['repeatName'] as String,
      dueState: (snap.data['dueState'] == null)
          ? null
          : TodoDueState.values[snap.data['dueState']],
      dueMileage: (snap.data['dueMileage'] as num)?.toDouble(),
      notificationID: snap.data['notificationID'] as int,
      completed: snap.data['completed'] as bool,
      estimatedDueDate: snap.data['estimatedDueDate'] as bool,
      completedDate: (snap.data['completedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.data['completedDate']),
      dueDate: (snap.data['dueDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.data['dueDate']),
    );
  }

  factory Todo.fromRecord(RecordSnapshot snap) {
    return Todo(
      id: (snap.key is String) ? snap.key : '${snap.key}',
      name: snap.value['name'] as String,
      carName: snap.value['carName'] as String,
      repeatName: snap.value['repeatName'] as String,
      dueState: (snap.value['dueState'] == null)
          ? null
          : TodoDueState.values[snap.value['dueState']],
      dueMileage: snap.value['dueMileage'] as double,
      notificationID: snap.value['notificationID'] as int,
      completed: snap.value['completed'] as bool,
      estimatedDueDate: snap.value['estimatedDueDate'] as bool,
      completedDate: (snap.value['completedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.value['completedDate']),
      dueDate: (snap.value['dueDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.value['dueDate']),
    );
  }

  final String id, name, carName, repeatName;

  final TodoDueState dueState;

  final double dueMileage;

  final int notificationID;

  final bool completed, estimatedDueDate;

  final DateTime completedDate, dueDate;

  Todo copyWith(
      {String id,
      String name,
      String carName,
      String repeatName,
      TodoDueState dueState,
      double dueMileage,
      int notificationID,
      bool completed,
      bool estimatedDueDate,
      DateTime completedDate,
      DateTime dueDate}) {
    return Todo(
        id: id ?? this.id,
        name: name ?? this.name,
        carName: carName ?? this.carName,
        repeatName: repeatName ?? this.repeatName,
        dueState: dueState ?? this.dueState,
        dueMileage: dueMileage ?? this.dueMileage,
        notificationID: notificationID ?? this.notificationID,
        completed: completed ?? this.completed,
        estimatedDueDate: estimatedDueDate ?? this.estimatedDueDate,
        completedDate: completedDate ?? this.completedDate,
        dueDate: dueDate ?? this.dueDate);
  }

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
        completedDate?.toUtc(),
        dueDate?.toUtc()
      ];

  @override
  String toString() {
    return '$runtimeType { id: $id, name: $name, carName: $carName, repeatName: '
        '$repeatName, dueState: $dueState, dueMileage: $dueMileage, '
        'notificationID: $notificationID, completed: '
        '$completed, estimatedDueDate: $estimatedDueDate, completedDate: '
        '${completedDate?.toUtc()}, dueDate: ${dueDate?.toUtc()} }';
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
