import 'package:equatable/equatable.dart';

abstract class FilteredTodosState extends Equatable {
  const FilteredTodosState();
}

class InitialFilteredTodosState extends FilteredTodosState {
  @override
  List<Object> get props => [];
}
