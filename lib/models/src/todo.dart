import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../repositories/src/write_batch_wrapper.dart';
import '../models.dart';
import 'repeat_interval.dart';

@immutable
class Todo extends Equatable implements WriteBatchDocument {
  const Todo(
      {this.id,
      this.name,
      this.carName,
      this.dueState,
      this.dueMileage,
      this.mileageRepeatInterval,
      this.dateRepeatInterval,
      this.notificationID,
      this.completed,
      this.estimatedDueDate,
      this.completedDate,
      this.completedMileage,
      this.dueDate});

  factory Todo.fromMap(String id, Map<String, dynamic> value) {
    return Todo(
      id: id,
      name: value['name'] as String,
      carName: value['carName'] as String,
      dueState: (value['dueState'] == null)
          ? null
          : TodoDueState.values[value['dueState']],
      dueMileage: value['dueMileage'] as double,
      mileageRepeatInterval:
          (value['mileageRepeatInterval'] as num)?.toDouble(),
      dateRepeatInterval: RepeatInterval(
        days: value['dateRepeatIntervalDays'],
        months: value['dateRepeatIntervalMonths'],
        years: value['dateRepeatIntervalYears'],
      ),
      notificationID: value['notificationID'] as int,
      completed: value['completed'] as bool,
      estimatedDueDate: value['estimatedDueDate'] as bool,
      completedDate: (value['completedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(value['completedDate']),
      completedMileage: (value['completedMileage'] as num)?.toDouble(),
      dueDate: (value['dueDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(value['dueDate']),
    );
  }

  /// The key used to reference this item in the database.
  final String id;

  /// The user-facing name for the ToDo action.
  final String name;

  /// The name of the car that this ToDo action will be applied to.
  final String carName;

  /// An enumerated value specifying if the ToDo is close to being due or is
  /// overdue.
  final TodoDueState dueState;

  /// The car mileage distance when this ToDo action should be done.
  final double dueMileage;

  /// The car mileage distance when this ToDo action was completed.
  final double completedMileage;

  /// The id value for the local notification corresponding to this action.
  final int notificationID;

  /// True if the ToDo action has been performed, False otherwise
  final bool completed;

  /// True if the dueDate field of this ToDo is calculated from the car's
  /// average driving distance rate, False if the user specified the date
  /// explicitly when creating the ToDo.
  final bool estimatedDueDate;

  /// The date when the ToDo was actually completed. This can, and often does,
  /// vary from the due date for the ToDo.
  final DateTime completedDate;

  /// The date when the ToDo should be completed.
  final DateTime dueDate;

  /// The distance at which this action should recur. If null then this ToDo
  /// is either recurring by date or is a one-off task.
  final double mileageRepeatInterval;

  /// The time interval when this action should recur. If null then this ToDo
  /// is either recurring by distance or is a one-off task.
  final RepeatInterval dateRepeatInterval;

  Todo copyWith(
      {String id,
      String name,
      String carName,
      TodoDueState dueState,
      double dueMileage,
      double mileageRepeatInterval,
      RepeatInterval dateRepeatInterval,
      int notificationID,
      bool completed,
      bool estimatedDueDate,
      DateTime completedDate,
      double completedMileage,
      DateTime dueDate}) {
    return Todo(
        id: id ?? this.id,
        name: name ?? this.name,
        carName: carName ?? this.carName,
        dueState: dueState ?? this.dueState,
        dueMileage: dueMileage ?? this.dueMileage,
        mileageRepeatInterval:
            mileageRepeatInterval ?? this.mileageRepeatInterval,
        dateRepeatInterval: dateRepeatInterval ?? this.dateRepeatInterval,
        notificationID: notificationID ?? this.notificationID,
        completed: completed ?? this.completed,
        estimatedDueDate: estimatedDueDate ?? this.estimatedDueDate,
        completedDate: completedDate ?? this.completedDate,
        completedMileage: completedMileage ?? this.completedMileage,
        dueDate: dueDate ?? this.dueDate);
  }

  @override
  List<Object> get props => [
        id,
        name,
        carName,
        dueState,
        dueMileage,
        mileageRepeatInterval,
        dateRepeatInterval,
        notificationID,
        completed,
        estimatedDueDate,
        completedDate?.toUtc(),
        completedMileage,
        dueDate?.toUtc()
      ];

  @override
  String toString() {
    return '$runtimeType { id: $id, name: $name, carName: $carName, '
        'dueState: $dueState, dueMileage: $dueMileage, '
        'mileageRepeatInterval: $mileageRepeatInterval, '
        'dateRepeatInterval: $dateRepeatInterval, '
        'notificationID: $notificationID, completed: '
        '$completed, estimatedDueDate: $estimatedDueDate, completedDate: '
        '${completedDate?.toUtc()}, completedMileage: $completedMileage, '
        'dueDate: ${dueDate?.toUtc()} }';
  }

  @override
  Map<String, Object> toDocument() {
    return {
      'name': name,
      'carName': carName,
      'dueState': dueState?.index,
      'dueMileage': dueMileage,
      'mileageRepeatInterval': mileageRepeatInterval,
      'dateRepeatIntervalDays': dateRepeatInterval?.days,
      'dateRepeatIntervalMonths': dateRepeatInterval?.months,
      'dateRepeatIntervalYears': dateRepeatInterval?.years,
      'notificationID': notificationID,
      'completed': completed,
      'estimatedDueDate': estimatedDueDate,
      'completedDate': completedDate?.millisecondsSinceEpoch,
      'completedMileage': completedMileage,
      'dueDate': dueDate?.millisecondsSinceEpoch
    };
  }
}
