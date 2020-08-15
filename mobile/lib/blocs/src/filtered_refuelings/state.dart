import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class FilteredRefuelingsState extends Equatable {
  const FilteredRefuelingsState();

  @override
  List<Object> get props => [];
}

class FilteredRefuelingsNotLoaded extends FilteredRefuelingsState {}

class FilteredRefuelingsLoading extends FilteredRefuelingsState {}

class FilteredRefuelingsLoaded extends FilteredRefuelingsState {
  const FilteredRefuelingsLoaded(
      this.filteredRefuelings, this.activeFilter, this.cars);

  final List<Refueling> filteredRefuelings;

  final List<Car> cars;

  final VisibilityFilter activeFilter;

  @override
  List<Object> get props => [filteredRefuelings, activeFilter, cars];

  @override
  String toString() {
    return 'FilteredRefuelingsLoaded { filteredRefuelings: $filteredRefuelings, activeFilter: $activeFilter, cars: $cars }';
  }
}
