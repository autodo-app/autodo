import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class FilteredRefuelingsState extends Equatable {
  const FilteredRefuelingsState();

  @override
  List<Object> get props => [];
}

class FilteredRefuelingsLoading extends FilteredRefuelingsState {}

class FilteredRefuelingsLoaded extends FilteredRefuelingsState {
  final List<Refueling> filteredRefuelings;
  final VisibilityFilter activeFilter;

  const FilteredRefuelingsLoaded(
    this.filteredRefuelings,
    this.activeFilter,
  );

  @override
  List<Object> get props => [filteredRefuelings, activeFilter];

  @override
  String toString() {
    return 'FilteredRefuelingsLoaded { filteredRefuelings: $filteredRefuelings, activeFilter: $activeFilter }';
  }
}