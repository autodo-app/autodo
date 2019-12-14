import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

abstract class FilteredRefuelingsEvent extends Equatable {
  const FilteredRefuelingsEvent();
}

class UpdateRefuelingsFilter extends FilteredRefuelingsEvent {
  final VisibilityFilter filter;

  const UpdateRefuelingsFilter(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}

class UpdateRefuelings extends FilteredRefuelingsEvent {
  final List<Refueling> todos;

  const UpdateRefuelings(this.todos);

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'UpdateRefuelings { todos: $todos }';
}