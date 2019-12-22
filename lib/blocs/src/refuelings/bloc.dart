import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import '../cars/barrel.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/util.dart';

class RefuelingsBloc extends Bloc<RefuelingsEvent, RefuelingsState> {
  static const int MAX_MPG = 0xffff;
  static const int HUE_RANGE = 60; // range of usable hues is 0-120, or +- 60
  static const double EFF_VAR = 5.0;
  static const double HUE_MAX = 360.0;
  // don't know why anyone would enter this many, but preventing overflow here
  static const int MAX_NUM_REFUELINGS = 0xffff;

  final DataRepository _dataRepository;
  StreamSubscription _dataSubscription, _carsSubscription;
  final CarsBloc _carsBloc;
  List<Car> _carsCache;

  RefuelingsBloc({@required DataRepository dataRepository, @required CarsBloc carsBloc})
      : assert(dataRepository != null), assert(carsBloc != null),
        _dataRepository = dataRepository, _carsBloc = carsBloc;

  @override
  RefuelingsState get initialState => RefuelingsLoading();

  @override
  Stream<RefuelingsState> mapEventToState(RefuelingsEvent event) async* {
    if (event is LoadRefuelings) {
      yield* _mapLoadRefuelingsToState();
    } else if (event is AddRefueling) {
      yield* _mapAddRefuelingToState(event);
    } else if (event is UpdateRefueling) {
      yield* _mapUpdateRefuelingToState(event);
    } else if (event is DeleteRefueling) {
      yield* _mapDeleteRefuelingToState(event);
    } if (event is ExternalCarsUpdated) {
      yield* _mapCarsUpdatedToState(event);
    }
  }

  Future<Refueling> _findLatestRefueling(Refueling refueling) async {
    var refuelings = await _dataRepository.refuelings().take(1).toList();

    int smallestDiff = MAX_MPG;
    Refueling out;
    for (var r in refuelings[0]) {
      if (r.carName == refueling.carName) {
        var mileageDiff = refueling.mileage - r.mileage;
        if (mileageDiff <= 0) continue; // only looking for past refuelings
        if (mileageDiff < smallestDiff) {
          smallestDiff = mileageDiff;
          out = r;
        }
      }
    }
    return out;
  }

  int _hsv(Refueling refueling, Car car) {
    if (refueling.efficiency == double.infinity) return HSV(1.0, 1.0, 1.0).toValue();
    var avgEff = car.averageEfficiency;
    // range is 0 to 120
    var diff = (refueling.efficiency == null || refueling.efficiency == double.infinity)
        ? 0
        : refueling.efficiency - avgEff;
    dynamic hue = (diff * HUE_RANGE) / EFF_VAR;
    hue = clamp(hue, 0, HUE_RANGE * 2);
    return HSV(hue.toDouble(), 1.0, 1.0).toValue();
  }

  Stream<RefuelingsState> _mapLoadRefuelingsToState() async* {
    try {
      final refuelings = await _dataRepository.refuelings().first;
      if (refuelings != null) {
        yield RefuelingsLoaded(refuelings);
      } else {
        yield RefuelingsNotLoaded();
      }
    } catch (_) {
      yield RefuelingsNotLoaded();
    }
    // _dataSubscription?.cancel();
    // _dataSubscription = _dataRepository.refuelings().listen(
    //   (refuelings) => add(LoadRefuelings(refuelings)),
    // );
    _carsSubscription = _carsBloc.listen(
      (state) {
        if (state is CarsLoaded) {
          add(ExternalCarsUpdated(state.cars));
        }
      }
    );
  }

  Stream<RefuelingsState> _mapCarsUpdatedToState(ExternalCarsUpdated event) async* {
    // Create new write batch in db
    var batch = _dataRepository.startRefuelingWriteBatch();
    if (state is RefuelingsLoaded) {
      RefuelingsLoaded curState = state as RefuelingsLoaded;
      List<Refueling> updatedRefuelings = curState.refuelings;
      for (var c in event.cars) {
        if (_carsCache?.contains(c) ?? false) {
          continue; // only do calculations for updated cars
        }

        List<Refueling> toUpdate = curState.refuelings.where((r) => r.carName == c.name).toList();
        for (var r in toUpdate) {
          Refueling updated = r.copyWith(efficiencyColor: Color(_hsv(r, c)));
          batch.updateData(r.id, updated);
          updatedRefuelings = updatedRefuelings.map((r) => r.id == updated.id ? updated : r).toList();
        }
      }
      yield RefuelingsLoaded(updatedRefuelings);
      _carsCache = event.cars;
    }
    batch.commit();
  }

  Stream<RefuelingsState> _mapAddRefuelingToState(AddRefueling event) async* {
    var item = event.refueling;
    var prev = await _findLatestRefueling(item);
    var dist = (prev == null) ? 0 : item.mileage - prev.mileage;
    Refueling out = event.refueling.copyWith(efficiency: dist / item.amount);

    // event.carsBloc.add(AddRefuelingInfo(item.car, item.mileage, item.date, item.efficiency, prev.date, dist));
    final List<Refueling> updatedRefuelings = List.from((state as RefuelingsLoaded).refuelings)..add(out);
    yield RefuelingsLoaded(updatedRefuelings);
    _dataRepository.addNewRefueling(out);
  }

  Stream<RefuelingsState> _mapUpdateRefuelingToState(UpdateRefueling event) async* {
    var prev = await _findLatestRefueling(event.refueling);
    var dist = (prev == null) ? 0 : event.refueling.mileage - prev.mileage;
    var efficiency = dist / event.refueling.amount;
    Refueling out = event.refueling.copyWith(efficiency: efficiency);

    final List<Refueling> updatedRefuelings = (state as RefuelingsLoaded)
      .refuelings.map((r) => r.id == out.id ? out : r)
      .toList();
    yield RefuelingsLoaded(updatedRefuelings);
    _dataRepository.updateRefueling(out);
  }

  Stream<RefuelingsState> _mapDeleteRefuelingToState(DeleteRefueling event) async* {
    if (state is RefuelingsLoaded) {
      final updatedRefuelings = (state as RefuelingsLoaded)
          .refuelings
          .where((r) => r.id != event.refueling.id)
          .toList();
      yield RefuelingsLoaded(updatedRefuelings);
      _dataRepository.deleteRefueling(event.refueling);
    }
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    _carsSubscription?.cancel();
    return super.close();
  }
}
