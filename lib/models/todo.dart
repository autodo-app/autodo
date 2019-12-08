import 'package:autodo/models/barrel.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../entities/barrel.dart';

@immutable
class Todo extends Equatable {
  final String id, name, carName;
  final TodoDueState dueState;
  final int dueMileage;
  final bool completed, estimatedDueDate;
  final DateTime completedDate, dueDate;

  Todo({
    this.id,
    this.name,
    this.carName,
    this.dueState,
    this.dueMileage,
    this.completed,
    this.estimatedDueDate,
    this.completedDate,
    this.dueDate
  });

  Todo copyWith({
    String id,
    String name,
    String carName,
    TodoDueState dueState,
    int dueMileage,
    bool completed,
    bool estimatedDueDate,
    DateTime completedDate,
    DateTime dueDate
  }) {
    return Todo(  
      id: id ?? this.id,
      name: name ?? this.name,
      carName: carName ?? this.carName,
      dueState: dueState ?? this.dueState,
      dueMileage: dueMileage ?? this.dueMileage,
      completed: completed ?? this.completed,
      estimatedDueDate: estimatedDueDate ?? this.estimatedDueDate,
      completedDate: completedDate ?? this.completedDate,
      dueDate: dueDate ?? this.dueDate
    );
  }

  @override 
  List<Object> get props => [id, name, carName, dueState, dueMileage, completed, estimatedDueDate, completedDate, dueDate];

  @override
  String toString() {
    return 'Todo { id: $id, name: $name, carName: $carName, dueState: $dueState, dueMileage: $dueMileage, completed: $completed, estimatedDueDate: $estimatedDueDate, completedDate: $completedDate, dueDate: $dueDate }';
  }

  TodoEntity toEntity() {
    return TodoEntity(id, name, carName, dueState, dueMileage, completed, estimatedDueDate, completedDate, dueDate);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      id: entity.id, 
      name: entity.name, 
      carName: entity.carName, 
      dueState: entity.dueState, 
      dueMileage: entity.dueMileage, 
      completed: entity.completed, 
      estimatedDueDate: entity.estimatedDueDate, 
      completedDate: entity.completedDate, 
      dueDate: entity.dueDate
    );
  }
}