import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

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

class FilteredTodoDataUpdated extends FilteredTodosEvent {
  const FilteredTodoDataUpdated({this.todos, this.cars});

  final List<Todo> todos;

  final List<Car> cars;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'FilteredTodoDataUpdated {}';
}