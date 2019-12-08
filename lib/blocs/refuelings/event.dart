import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

abstract class RefuelingsEvent extends Equatable {
  const RefuelingsEvent();

  @override
  List<Object> get props => [];
}

class LoadRefuelings extends RefuelingsEvent {}

class AddRefueling extends RefuelingsEvent {
  final Refueling todo;

  const AddRefueling(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddRefueling { todo: $todo }';
}

class UpdateRefueling extends RefuelingsEvent {
  final Refueling updatedRefueling;

  const UpdateRefueling(this.updatedRefueling);

  @override
  List<Object> get props => [updatedRefueling];

  @override
  String toString() => 'UpdateRefueling { updatedRefueling: $updatedRefueling }';
}

class DeleteRefueling extends RefuelingsEvent {
  final Refueling todo;

  const DeleteRefueling(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'DeleteRefueling { todo: $todo }';
}

class RefuelingsUpdated extends RefuelingsEvent {
  final List<Refueling> todos;

  const RefuelingsUpdated(this.todos);

  @override
  List<Object> get props => [todos];
}