import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/models.dart';
import '../../../util.dart';
import '../data/barrel.dart';
import 'event.dart';
import 'state.dart';

class FilteredRefuelingsBloc
    extends Bloc<FilteredRefuelingsEvent, FilteredRefuelingsState> {
  FilteredRefuelingsBloc({@required this.dataBloc}) {
    dataBlocSubscription = dataBloc.listen((state) {
      if (state is DataLoaded) {
        add(FilteredRefuelingDataUpdated(
            refuelings: state.refuelings, cars: state.cars));
      }
    });
  }

  /// range of usable hues is 0-120, or +- 60
  static const int HUE_RANGE = 60;

  static const double EFF_VAR = 5.0;

  static const double HUE_MAX = 360.0;

  final DataBloc dataBloc;

  StreamSubscription dataBlocSubscription;

  @override
  FilteredRefuelingsState get initialState {
    if (dataBloc.state is DataLoaded) {
      return _shadeEfficiencyStats((dataBloc.state as DataLoaded).refuelings,
          (dataBloc.state as DataLoaded).cars, VisibilityFilter.all);
    } else if (dataBloc.state is DataNotLoaded) {
      return FilteredRefuelingsNotLoaded();
    } else {
      return FilteredRefuelingsLoading();
    }
  }

  @override
  Stream<FilteredRefuelingsState> mapEventToState(
      FilteredRefuelingsEvent event) async* {
    if (event is UpdateRefuelingsFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is FilteredRefuelingDataUpdated) {
      yield* _mapFilteredRefuelingDataUpdatedToState(event);
    }
  }

  Stream<FilteredRefuelingsState> _mapUpdateFilterToState(
    UpdateRefuelingsFilter event,
  ) async* {
    if (state is FilteredRefuelingsLoaded) {
      yield FilteredRefuelingsLoaded(
        (state as FilteredRefuelingsLoaded).filteredRefuelings,
        event.filter,
        (state as FilteredRefuelingsLoaded).cars,
      );
    }
  }

  Stream<FilteredRefuelingsState> _mapFilteredRefuelingDataUpdatedToState(
      FilteredRefuelingDataUpdated event) async* {
    final sortedRefuelings = _sortRefuelings(event.refuelings);
    final highlightedRefuelings = sortedRefuelings.map((r) {
      final car = event.cars.firstWhere((c) => c.id == r.odomSnapshot.car);
      return r.copyWith(efficiencyColor: Color(_hsv(r, car)));
    });
    final curFilter = (state as FilteredRefuelingsLoaded).activeFilter;
    yield _shadeEfficiencyStats(highlightedRefuelings, event.cars, curFilter);
  }

  int _hsv(Refueling refueling, Car car) {
    if (refueling.efficiency == double.infinity) {
      return HSV(1.0, 1.0, 1.0).toValue();
    }
    final avgEff = car.averageEfficiency;
    // range is 0 to 120
    final diff = (refueling.efficiency == null ||
            refueling.efficiency == double.infinity)
        ? 0
        : refueling.efficiency - avgEff;
    dynamic hue = (diff * HUE_RANGE) / EFF_VAR;
    hue = clamp(hue, 0, HUE_RANGE * 2);
    return HSV(hue.toDouble(), 1.0, 1.0).toValue();
  }

  FilteredRefuelingsState _shadeEfficiencyStats(
      List<Refueling> refuelings, List<Car> cars,
      [filter]) {
    final curFilter =
        filter ?? (state as FilteredRefuelingsLoaded).activeFilter;
    final shadedRefuelings = refuelings
        .where((r) => cars.any((c) => c.id == r.odomSnapshot.car))
        .map((r) => r.copyWith(
            efficiencyColor: Color(
                _hsv(r, cars.firstWhere((c) => r.odomSnapshot.car == c.id)))))
        .toList();
    final updatedRefuelings = refuelings
        .map((r) => shadedRefuelings.any((s) => s.id == r.id)
            ? shadedRefuelings.firstWhere((s) => s.id == r.id)
            : r)
        .toList();
    final sortedRefuelings = _sortRefuelings(updatedRefuelings);
    return FilteredRefuelingsLoaded(sortedRefuelings, curFilter, cars);
  }

  List<Refueling> _sortRefuelings(List<Refueling> refuelings) {
    refuelings
        .sort((a, b) => a.odomSnapshot.date.compareTo(b.odomSnapshot.date));
    return refuelings.reversed.toList();
  }

  @override
  Future<void> close() {
    dataBlocSubscription?.cancel();
    return super.close();
  }
}
