import 'package:autodo/models/barrel.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import '../entities/barrel.dart';

@immutable
class Todo {
  final bool complete;
  final String id;
  final String note;
  final String name;
  final TodoDueState dueState;
  final int mileage;
  final bool completed;
  final DateTime completedDate;
  final DateTime dueDate;

  Todo(this.name, {this.complete = false, String note = '', String id, this.dueState, this.mileage, this.completed, this.completedDate, this.dueDate})
      : this.note = note ?? '',
        this.id = id;

  Todo copyWith({bool complete, String id, String note, String name}) {
    return Todo(
      name ?? this.name,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  int get hashCode =>
      complete.hashCode ^ name.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          name == other.name &&
          note == other.note &&
          id == other.id;

  @override
  String toString() {
    return 'Todo { complete: $complete, task: $name, note: $note, id: $id }';
  }

  TodoEntity toEntity() {
    return TodoEntity(name, id, note, complete);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      entity.name,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id,
    );
  }
}