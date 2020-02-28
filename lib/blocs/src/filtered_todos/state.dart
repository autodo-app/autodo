import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class FilteredTodosState extends Equatable {
  const FilteredTodosState();

  @override
  List<Object> get props => [];
}

class FilteredTodosLoading extends FilteredTodosState {}

class FilteredTodosLoaded extends FilteredTodosState {
  const FilteredTodosLoaded(
    this.filteredTodos,
    this.activeFilter,
  );

  final List<Todo> filteredTodos;

  final VisibilityFilter activeFilter;

  @override
  List<Object> get props => [filteredTodos, activeFilter];

  @override
  String toString() {
    return 'FilteredTodosLoaded { filteredTodos: $filteredTodos, activeFilter: $activeFilter }';
  }
}
