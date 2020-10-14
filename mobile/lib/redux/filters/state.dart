import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

class FilterState extends Equatable {
  const FilterState(
      {@required this.refuelingsFilter, @required this.todosFilter});

  /// The setting for filtering out some of the refuelings in the UI.
  final VisibilityFilter refuelingsFilter;

  /// The setting for filtering out some of the todos in the UI.
  final VisibilityFilter todosFilter;

  FilterState copyWith(
          {VisibilityFilter refuelingsFilter, VisibilityFilter todosFilter}) =>
      FilterState(
          refuelingsFilter: refuelingsFilter ?? this.refuelingsFilter,
          todosFilter: todosFilter ?? this.todosFilter);

  @override
  List get props => [refuelingsFilter, todosFilter];
}
