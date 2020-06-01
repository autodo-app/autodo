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

class FilteredRefuelingDataUpdated extends FilteredRefuelingsEvent {
  const FilteredRefuelingDataUpdated({this.refuelings, this.cars});

  final List<Refueling> refuelings;

  final List<Car> cars;

  @override 
  List<Object> get props => [...refuelings, ...cars];

  @override 
  String toString() => '$runtimeType { refuelings $refuelings, cars: $cars }';
}
