import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/models.dart';
import '../../../util.dart';
import '../cars/barrel.dart';
import '../refuelings/barrel.dart';
import 'event.dart';
import 'state.dart';

class FilteredRefuelingsBloc
    extends Bloc<FilteredRefuelingsEvent, FilteredRefuelingsState> {
  FilteredRefuelingsBloc(
      {@required this.refuelingsBloc, @required this.carsBloc}) {
    refuelingsSubscription = refuelingsBloc.listen((state) {
      if (state is RefuelingsLoaded) {
        add(UpdateRefuelings(
            (refuelingsBloc.state as RefuelingsLoaded).refuelings));
      }
    });
    carsSubscription = carsBloc.listen((state) {
      if (state is CarsLoaded) {
        add(FilteredRefuelingsUpdateCars(state.cars));
      }
    });
  }

  /// range of usable hues is 0-120, or +- 60
  static const int HUE_RANGE = 60;

  static const double EFF_VAR = 5.0;

  static const double HUE_MAX = 360.0;

  final RefuelingsBloc refuelingsBloc;

  final CarsBloc carsBloc;

  StreamSubscription refuelingsSubscription, carsSubscription;

  @override
  FilteredRefuelingsState get initialState {
    if (refuelingsBloc.state is RefuelingsLoaded &&
        carsBloc.state is CarsLoaded) {
      return _shadeEfficiencyStats(
          (refuelingsBloc.state as RefuelingsLoaded).refuelings,
          (carsBloc.state as CarsLoaded).cars,
          VisibilityFilter.all);
    } else if (refuelingsBloc.state is RefuelingsLoading) {
      return FilteredRefuelingsLoading();
    } else {
      return FilteredRefuelingsNotLoaded();
    }
  }

  @override
  Stream<FilteredRefuelingsState> mapEventToState(
      FilteredRefuelingsEvent event) async* {
    if (event is UpdateRefuelingsFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateRefuelings) {
      yield* _mapRefuelingsUpdatedToState(event);
    } else if (event is FilteredRefuelingsUpdateCars) {
      yield* _mapCarsUpdatedToState(event);
    }
  }

  Stream<FilteredRefuelingsState> _mapUpdateFilterToState(
    UpdateRefuelingsFilter event,
  ) async* {
    if (refuelingsBloc.state is RefuelingsLoaded &&
        state is FilteredRefuelingsLoaded) {
      final curState = state as FilteredRefuelingsLoaded;
      yield FilteredRefuelingsLoaded(
        curState.filteredRefuelings,
        event.filter,
        curState.cars,
      );
    }
  }

  Stream<FilteredRefuelingsState> _mapRefuelingsUpdatedToState(
    UpdateRefuelings event,
  ) async* {
    print('filtered refuelings $state');
    if (state is FilteredRefuelingsLoaded) {
      final curState = state as FilteredRefuelingsLoaded;
      yield _shadeEfficiencyStats(
          (refuelingsBloc.state as RefuelingsLoaded).refuelings, curState.cars);
    } else if (carsBloc.state is RefuelingsLoaded) {
      // this allows the initial state to still be created even if the carsBloc
      // and/or the refuelingsBloc are not loaded when this bloc is created
      yield _shadeEfficiencyStats(
          (refuelingsBloc.state as RefuelingsLoaded).refuelings,
          (carsBloc.state as CarsLoaded).cars,
          VisibilityFilter.all);
    }
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
        .where((r) => cars.any((c) => c.name == r.carName))
        .map((r) => r.copyWith(
            efficiencyColor:
                Color(_hsv(r, cars.firstWhere((c) => r.carName == c.name)))))
        .toList();
    final updatedRefuelings = refuelings
        .map((r) => shadedRefuelings.any((s) => s.id == r.id)
            ? shadedRefuelings.firstWhere((s) => s.id == r.id)
            : r)
        .toList();
    return FilteredRefuelingsLoaded(updatedRefuelings, curFilter, cars);
  }

  Stream<FilteredRefuelingsState> _mapCarsUpdatedToState(
      FilteredRefuelingsUpdateCars event) async* {
    if (state is FilteredRefuelingsLoaded) {
      final curState = state as FilteredRefuelingsLoaded;
      final curFilter = curState.activeFilter;
      var updatedRefuelings = curState.filteredRefuelings;
      for (var c in event.cars) {
        final toUpdate = curState.filteredRefuelings
            .where((r) => r.carName == c.name)
            .toList();
        for (var r in toUpdate) {
          final updated = r.copyWith(efficiencyColor: Color(_hsv(r, c)));
          updatedRefuelings = updatedRefuelings
              .map((r) => r.id == updated.id ? updated : r)
              .toList();
        }
      }
      yield FilteredRefuelingsLoaded(updatedRefuelings, curFilter, event.cars);
    } else if (refuelingsBloc.state is RefuelingsLoaded) {
      yield _shadeEfficiencyStats(
          (refuelingsBloc.state as RefuelingsLoaded).refuelings,
          (carsBloc.state as CarsLoaded).cars,
          VisibilityFilter.all);
    }
  }

  @override
  Future<void> close() {
    refuelingsSubscription?.cancel();
    carsSubscription?.cancel();
    return super.close();
  }
}
