import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

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

  final Map<TodoDueState, List<Todo>> filteredTodos;

  final VisibilityFilter activeFilter;

  @override
  List<Object> get props => [...filteredTodos.values.expand((i) => i), activeFilter];

  @override
  String toString() {
    return 'FilteredTodosLoaded { filteredTodos: $filteredTodos, activeFilter: $activeFilter }';
  }
}
