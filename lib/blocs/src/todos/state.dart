import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  const TodosLoaded([this.todos = const []]);

  final List<Todo> todos;

  @override
  List<Object> get props => todos;

  @override
  String toString() => 'TodosLoaded { todos: $todos }';
}

class TodosNotLoaded extends TodosState {}
