import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent {}

class AddTodo extends TodosEvent {
  const AddTodo(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddTodo { todo: $todo }';
}

class UpdateTodo extends TodosEvent {
  const UpdateTodo(this.updatedTodo);

  final Todo updatedTodo;

  @override
  List<Object> get props => [updatedTodo];

  @override
  String toString() => 'UpdateTodo { updatedTodo: $updatedTodo }';
}

class DeleteTodo extends TodosEvent {
  const DeleteTodo(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'DeleteTodo { todo: $todo }';
}

class ClearCompleted extends TodosEvent {}

class ToggleAll extends TodosEvent {}

class CarsUpdated extends TodosEvent {
  const CarsUpdated(this.cars);

  final List<Car> cars;

  @override
  List<Object> get props => [cars];

  @override
  String toString() => 'CarsUpdated { cars: $cars }';
}

class CompleteTodo extends TodosEvent {
  const CompleteTodo(this.todo, [this.completedDate]);

  final Todo todo;

  final DateTime completedDate;

  @override
  List<Object> get props => [todo, completedDate];

  @override
  String toString() =>
      'CompleteTodo { todo: $todo, completedDate: $completedDate }';
}
