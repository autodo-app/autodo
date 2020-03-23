import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class FilteredRefuelingsEvent extends Equatable {
  const FilteredRefuelingsEvent();
}

class UpdateRefuelingsFilter extends FilteredRefuelingsEvent {
  const UpdateRefuelingsFilter(this.filter);

  final VisibilityFilter filter;

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}

class UpdateRefuelings extends FilteredRefuelingsEvent {
  const UpdateRefuelings(this.refuelings);

  final List<Refueling> refuelings;

  @override
  List<Object> get props => [refuelings];

  @override
  String toString() => 'UpdateRefuelings { refuelings: $refuelings }';
}

class FilteredRefuelingsUpdateCars extends FilteredRefuelingsEvent {
  const FilteredRefuelingsUpdateCars(this.cars);

  final List<Car> cars;

  @override
  List<Object> get props => [cars];

  @override
  String toString() => 'FilteredRefuelingsUpdateCars { cars: $cars }';
}
