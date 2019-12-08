import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';

class CarsBloc extends Bloc<CarsEvent, CarsState> {
  static const double EMA_GAIN = 0.9;
  static const double EMA_CUTOFF = 8;
  
  final DataRepository _carsRepository;
  StreamSubscription _carsSubscription;

  CarsBloc({@required DataRepository carsRepository})
      : assert(carsRepository != null),
        _carsRepository = carsRepository;

  @override
  CarsState get initialState => CarsLoading();

  @override
  Stream<CarsState> mapEventToState(CarsEvent event) async* {
    if (event is LoadCars) {
      yield* _mapLoadCarsToState();
    } else if (event is AddCar) {
      yield* _mapAddCarToState(event);
    } else if (event is UpdateCar) {
      yield* _mapUpdateCarToState(event);
    } else if (event is DeleteCar) {
      yield* _mapDeleteCarToState(event);
    } else if (event is CarsUpdated) {
      yield* _mapCarsUpdateToState(event);
    }
  }

  Stream<CarsState> _mapLoadCarsToState() async* {
    _carsSubscription?.cancel();
    _carsSubscription = _carsRepository.cars().listen(
          (cars) => add(CarsUpdated(cars)),
        );
  }

  Stream<CarsState> _mapAddCarToState(AddCar event) async* {
    _carsRepository.addNewCar(event.car);
  }

  Stream<CarsState> _mapUpdateCarToState(UpdateCar event) async* {
    _carsRepository.updateCar(event.updatedCar);
  }

  Stream<CarsState> _mapDeleteCarToState(DeleteCar event) async* {
    _carsRepository.deleteCar(event.car);
  }

  Stream<CarsState> _mapCarsUpdateToState(CarsUpdated event) async* {
    yield CarsLoaded(event.cars);
  }

  @override
  Future<void> close() {
    _carsSubscription?.cancel();
    return super.close();
  }

  void updateMileage(int newMileage, DateTime updateDate, {override = false}) {
    if (this.mileage > newMileage && !override) {
      // allow adding past refuelings, but we don't want to roll back the
      // mileage in that case. The override switch is available to force a
      // rollback in the case of a deleted refueling.
      return;
    }

    this.mileage = newMileage;
    this.lastMileageUpdate = roundToDay(updateDate);
  }

  double _efficiencyFilter(int numRefuelings, double prev, double cur) {
    if (numRefuelings > EMA_CUTOFF) {
      return EMA_GAIN * prev + (1 - EMA_GAIN) * cur;
    } else {
      double fac1 = (numRefuelings - 1) / numRefuelings;
      double fac2 = 1 / numRefuelings;
      return prev * fac1 + cur * fac2;
    }
  }

  void updateEfficiency(double eff) {
    if (this.numRefuelings == 1) {
      // first refueling for this car
      this.averageEfficiency = eff;
    } else {
      this.averageEfficiency =
          _efficiencyFilter(this.numRefuelings, this.averageEfficiency, eff);
    }
  }

  double _distanceFilter(int numItems, double prev, double cur) {
    if (numItems == 1 || prev == double.infinity) {
      // no point in averaging only one value
      return cur;
    } else if (numItems > EMA_CUTOFF) {
      // Use the EMA when we have enough data to get
      // good results from it
      return EMA_GAIN * prev + (1 - EMA_GAIN) * cur;
    } else {
      // simple moving average when we don't have much
      // data to work with
      numItems--; // we don't track distanceRate between first two refuelings
      double fac1 = (numItems - 1) / numItems;
      double fac2 = 1 / numItems;
      return prev * fac1 + cur * fac2;
    }
  }

  void updateDistanceRate(DateTime prev, DateTime cur, int distance) {
    if (prev == null || cur == null) return;

    var elapsedDuration = cur.difference(prev);
    var curDistRate = distance.toDouble() / elapsedDuration.inDays.toDouble();
    this.distanceRate =
        _distanceFilter(this.numRefuelings, this.distanceRate, curDistRate);
    this.distanceRateHistory.add(DistanceRatePoint(cur, this.distanceRate));
    TodoBLoC().updateDueDates(this);
  }
}
