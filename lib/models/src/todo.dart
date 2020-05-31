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
      this.carId,
      this.dueState,
      this.dueMileage,
      this.mileageRepeatInterval,
      this.dateRepeatInterval,
      this.notificationID,
      this.completed,
      this.estimatedDueDate,
      this.completedOdomSnapshot,
      this.dueDate});

  factory Todo.fromMap(String id, Map<String, dynamic> value) {
    return Todo(
      id: id,
      name: value['name'] as String,
      carId: value['car'] as String,
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
      completedOdomSnapshot: OdomSnapshot.fromMap(value['odomSnapshot']['id'], value['odomSnapshot']),
      dueDate: (value['dueDate'] == null)
          ? null
          // : DateTime.fromMillisecondsSinceEpoch(value['dueDate']),
          : DateTime.parse(value['dueDate']),
    );
  }

  /// The key used to reference this item in the database.
  final String id;

  /// The user-facing name for the ToDo action.
  final String name;

  /// The ID of the car that this ToDo action will be applied to.
  final String carId;

  /// An enumerated value specifying if the ToDo is close to being due or is
  /// overdue.
  final TodoDueState dueState;

  /// The car mileage distance when this ToDo action should be done.
  final double dueMileage;

  /// The date and mileage for the car when this todo was completed.
  final OdomSnapshot completedOdomSnapshot;

  /// The id value for the local notification corresponding to this action.
  final int notificationID;

  /// True if the ToDo action has been performed, False otherwise
  final bool completed;

  /// True if the dueDate field of this ToDo is calculated from the car's
  /// average driving distance rate, False if the user specified the date
  /// explicitly when creating the ToDo.
  final bool estimatedDueDate;


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
      String carId,
      TodoDueState dueState,
      double dueMileage,
      double mileageRepeatInterval,
      RepeatInterval dateRepeatInterval,
      int notificationID,
      bool completed,
      bool estimatedDueDate,
      OdomSnapshot completedOdomSnapshot,
      DateTime dueDate}) {
    return Todo(
        id: id ?? this.id,
        name: name ?? this.name,
        carId: carId ?? this.carId,
        dueState: dueState ?? this.dueState,
        dueMileage: dueMileage ?? this.dueMileage,
        mileageRepeatInterval:
            mileageRepeatInterval ?? this.mileageRepeatInterval,
        dateRepeatInterval: dateRepeatInterval ?? this.dateRepeatInterval,
        notificationID: notificationID ?? this.notificationID,
        completed: completed ?? this.completed,
        estimatedDueDate: estimatedDueDate ?? this.estimatedDueDate,
        completedOdomSnapshot: completedOdomSnapshot ?? this.completedOdomSnapshot,
        dueDate: dueDate ?? this.dueDate);
  }

  @override
  List<Object> get props => [
        id,
        name,
        carId,
        dueState,
        dueMileage,
        mileageRepeatInterval,
        dateRepeatInterval,
        notificationID,
        completed,
        estimatedDueDate,
        completedOdomSnapshot,
        dueDate?.toUtc()
      ];

  @override
  String toString() {
    return '$runtimeType { id: $id, name: $name, carId: $carId, '
        'dueState: $dueState, dueMileage: $dueMileage, '
        'mileageRepeatInterval: $mileageRepeatInterval, '
        'dateRepeatInterval: $dateRepeatInterval, '
        'notificationID: $notificationID, completed: '
        '$completed, estimatedDueDate: $estimatedDueDate, completedOdomSnapshot:'
        ' $completedOdomSnapshot'
        'dueDate: ${dueDate?.toUtc()} }';
  }

  @override
  Map<String, String> toDocument() {
    return {
      'name': name,
      'car': carId,
      'dueState': dueState?.index.toString(),
      'dueMileage': dueMileage.toString(),
      'mileageRepeatInterval': mileageRepeatInterval.toString(),
      'dateRepeatIntervalDays': dateRepeatInterval?.days.toString(),
      'dateRepeatIntervalMonths': dateRepeatInterval?.months.toString(),
      'dateRepeatIntervalYears': dateRepeatInterval?.years.toString(),
      'notificationID': notificationID.toString(),
      'completed': completed.toString(),
      'estimatedDueDate': estimatedDueDate.toString(),
      'odomSnapshot': completedOdomSnapshot.id,
      'dueDate': dueDate?.toUtc()?.toIso8601String() ?? '',
    };
  }
}
