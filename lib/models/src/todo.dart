import 'package:autodo/models/models.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:autodo/entities/entities.dart';

@immutable
class Todo extends Equatable {
  final String id, name, carName, repeatName;
  final TodoDueState dueState;
  final int dueMileage, notificationID;
  final bool completed, estimatedDueDate;
  final DateTime completedDate, dueDate;

  Todo({
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
    this.dueDate
  });

  Todo copyWith({
    String id,
    String name,
    String carName,
    String repeatName,
    TodoDueState dueState,
    int dueMileage,
    int notificationID,
    bool completed,
    bool estimatedDueDate,
    DateTime completedDate,
    DateTime dueDate
  }) {
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
      dueDate: dueDate ?? this.dueDate
    );
  }

  @override 
  List<Object> get props => [id, name, carName, repeatName, dueState, dueMileage, 
      notificationID, completed, estimatedDueDate, completedDate?.toUtc(), dueDate?.toUtc()];

  @override
  String toString() {
    return 'Todo { id: $id, name: $name, carName: $carName, repeatName: '
    '$repeatName, dueState: $dueState, dueMileage: $dueMileage, completed: '
    '$completed, estimatedDueDate: $estimatedDueDate, completedDate: '
    '${completedDate?.toUtc()}, dueDate: ${dueDate?.toUtc()} }';
  }

  TodoEntity toEntity() {
    return TodoEntity(id, name, carName, repeatName, dueState, dueMileage, 
        notificationID, completed, estimatedDueDate, completedDate, dueDate);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      id: entity.id, 
      name: entity.name, 
      carName: entity.carName, 
      repeatName: entity.repeatName,
      dueState: entity.dueState, 
      dueMileage: entity.dueMileage, 
      notificationID: entity.notificationID,
      completed: entity.completed, 
      estimatedDueDate: entity.estimatedDueDate, 
      completedDate: entity.completedDate, 
      dueDate: entity.dueDate
    );
  }
}