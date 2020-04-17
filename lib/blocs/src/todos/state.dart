import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosLoading extends TodosState {
  const TodosLoading({this.defaults = const []});

  final List<Todo> defaults;

  @override
  List<Object> get props => defaults;

  @override
  String toString() => 'TodosLoading { defaults: $defaults }';
}

class TodosLoaded extends TodosState {
  const TodosLoaded({this.todos = const [], this.defaults = const []});

  final List<Todo> todos;
  final List<Todo> defaults;

  TodosLoaded copyWith({List<Todo> todos, List<Todo> defaults}) => TodosLoaded(
      todos: todos ?? this.todos, defaults: defaults ?? this.defaults);

  @override
  List<Object> get props => [...todos, ...defaults];

  @override
  String toString() => 'TodosLoaded { todos: $todos , defaults: $defaults }';
}

class TodosNotLoaded extends TodosState {}
