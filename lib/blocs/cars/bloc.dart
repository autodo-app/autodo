import 'dart:async';

import 'package:autodo/repositories/write_batch_wrappers.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/blocs/refuelings/barrel.dart';
import 'package:autodo/util.dart' as util;

class CarsBloc extends Bloc<CarsEvent, CarsState> {
  static const double EMA_GAIN = 0.9;
  static const double EMA_CUTOFF = 8;
  
  final DataRepository _dataRepository;
  StreamSubscription _carsSubscription, _refuelingsSubscription;
  final RefuelingsBloc _refuelingsBloc;
  List<Refueling> _refuelingsCache;

  CarsBloc({@required DataRepository dataRepository, @required RefuelingsBloc refuelingsBloc})
      : assert(dataRepository != null), assert(refuelingsBloc != null),
        _dataRepository = dataRepository, _refuelingsBloc = refuelingsBloc;

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
    } else if (event is ExternalRefuelingsUpdated) {
      yield* _mapRefuelingsUpdatedToState(event);
    }
  }

  Stream<CarsState> _mapLoadCarsToState() async* {
    _carsSubscription?.cancel();
    _carsSubscription = _dataRepository.cars().listen(
          (cars) => add(CarsUpdated(cars)),
        );
    _refuelingsSubscription = _refuelingsBloc.listen(
      (state) {
        if (state is RefuelingsLoaded) {
          add(ExternalRefuelingsUpdated(state.refuelings));
        }
      }
    );
  }

  Stream<CarsState> _mapAddCarToState(AddCar event) async* {
    _dataRepository.addNewCar(event.car);
  }

  Stream<CarsState> _mapUpdateCarToState(UpdateCar event) async* {
    _dataRepository.updateCar(event.updatedCar);
  }

  Stream<CarsState> _mapDeleteCarToState(DeleteCar event) async* {
    _dataRepository.deleteCar(event.car);
  }

  Stream<CarsState> _mapCarsUpdateToState(CarsUpdated event) async* {
    yield CarsLoaded(event.cars);
  }

  Car _updateWithRefueling(Car c, Refueling r) {
    var mileage, lastMileageUpdate, averageEfficiency;
    // update mileage
    if (c.mileage < r.mileage) {
      mileage = r.mileage;
      lastMileageUpdate = util.roundToDay(r.date);
    }
    // Update efficiency
    if (c.numRefuelings == 1) {
      // first refueling for this car
      averageEfficiency = r.efficiency;
    } else {
      averageEfficiency =
          _efficiencyFilter(c.numRefuelings, c.averageEfficiency, r.efficiency);
    }
    // Distance Rate
    var elapsedDuration = r.date.difference(c.lastMileageUpdate);
    var dist = r.mileage - c.mileage;
    var curDistRate = dist.toDouble() / elapsedDuration.inDays.toDouble();
    var distanceRate =
        _distanceFilter(c.numRefuelings, c.distanceRate, curDistRate);
    var distanceRateHistory = c.distanceRateHistory;
    distanceRateHistory.add(DistanceRatePoint(r.date, distanceRate));

    return c.copyWith(
      mileage: mileage,
      lastMileageUpdate: lastMileageUpdate,
      averageEfficiency: averageEfficiency,
      distanceRate: distanceRate,
      distanceRateHistory: distanceRateHistory,
      numRefuelings: c.numRefuelings + 1,
    );
  }

  Stream<CarsState> _mapRefuelingsUpdatedToState(ExternalRefuelingsUpdated event) async* {
    WriteBatchWrapper batch = _dataRepository.startCarWriteBatch();
    // TODO cache the cars here so that updating number of refuelings will work
    for (var r in event.refuelings) {
      if (_refuelingsCache.contains(r)) {
        continue; // only do calculations for updated refuelings
      }
      
      Car cur = (state as CarsLoaded).cars.firstWhere((car) => car.name == r.carName);
      Car update = _updateWithRefueling(cur, r); 

      batch.updateData(update.id, update.toEntity().toDocument());
    }
    _refuelingsCache = event.refuelings;
    
    batch.commit();
  }

  @override
  Future<void> close() {
    _carsSubscription?.cancel();
    _refuelingsSubscription?.cancel();
    return super.close();
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
}
