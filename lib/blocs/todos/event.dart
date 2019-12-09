import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent {}

class AddTodo extends TodosEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddTodo { todo: $todo }';
}

class UpdateTodo extends TodosEvent {
  final Todo updatedTodo;

  const UpdateTodo(this.updatedTodo);

  @override
  List<Object> get props => [updatedTodo];

  @override
  String toString() => 'UpdateTodo { updatedTodo: $updatedTodo }';
}

class DeleteTodo extends TodosEvent {
  final Todo todo;

  const DeleteTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'DeleteTodo { todo: $todo }';
}

class ClearCompleted extends TodosEvent {}

class ToggleAll extends TodosEvent {}

class TodosUpdated extends TodosEvent {
  final List<Todo> todos;

  const TodosUpdated(this.todos);

  @override
  List<Object> get props => [todos];
}

class UpdateDueDates extends TodosEvent {
  final List<Car> cars;

  const UpdateDueDates(this.cars);

  @override 
  List<Object> get props => [cars];
}

class RepeatsRefresh extends TodosEvent {
  final List<Repeat> repeats;

  const RepeatsRefresh(this.repeats);

  @override 
  List<Object> get props => [repeats];
}

class CompleteTodo extends TodosEvent {
  final Todo todo;

  const CompleteTodo(this.todo);

  @override 
  List<Object> get props => [todo];
}