import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

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
  final List<Refueling> refuelings;

  const UpdateRefuelings(this.refuelings);

  @override
  List<Object> get props => [refuelings];

  @override
  String toString() => 'UpdateRefuelings { refuelings: $refuelings }';
}