import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();
}

class UpdateTodosFilter extends FilteredTodosEvent {
  const UpdateTodosFilter(this.filter);

  final VisibilityFilter filter;

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}

class UpdateTodos extends FilteredTodosEvent {
  const UpdateTodos(this.todos);

  final List<Todo> todos;

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'UpdateTodos { todos: $todos }';
}
