import 'dart:async';

import 'package:autodo/repositories/repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/models/models.dart';
import '../refuelings/barrel.dart';
import '../database/barrel.dart';
import 'package:autodo/util.dart' as util;

class CarsBloc extends Bloc<CarsEvent, CarsState> {
  static const double EMA_GAIN = 0.9;
  static const double EMA_CUTOFF = 8;

  final DatabaseBloc _dbBloc;
  StreamSubscription _refuelingsSubscription, _dbSubscription;
  final RefuelingsBloc _refuelingsBloc;
  List<Refueling> _refuelingsCache;

  CarsBloc(
      {@required DatabaseBloc dbBloc, @required RefuelingsBloc refuelingsBloc})
      : assert(dbBloc != null),
        assert(refuelingsBloc != null),
        _dbBloc = dbBloc,
        _refuelingsBloc = refuelingsBloc {
    _dbSubscription = _dbBloc.listen((state) {
      if (state is DbLoaded) {
        add(LoadCars());
      }
    });
    _refuelingsSubscription = _refuelingsBloc.listen((state) {
      if (state is RefuelingsLoaded) {
        add(ExternalRefuelingsUpdated(state.refuelings));
      }
    });
  }

  @override
  CarsState get initialState => CarsLoading();

  DataRepository get repo => (_dbBloc.state is DbLoaded)
      ? (_dbBloc.state as DbLoaded).repository
      : null;

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
    } else if (event is ExternalRefuelingsUpdated) {
      yield* _mapRefuelingsUpdatedToState(event);
    }
  }

  Stream<CarsState> _mapLoadCarsToState() async* {
    if (state is CarsLoaded && (state as CarsLoaded).cars.length > 0)
      return;
    try {
      final cars = await repo.cars().first
          .timeout(Duration(seconds: 1), onTimeout: () => null);
      if (cars != null) {
        yield CarsLoaded(cars);
      } else {
        yield CarsLoaded([]);
      }
    } catch (e) {
      print('Error loading cars: $e');
      yield CarsNotLoaded();
    }
  }

  Stream<CarsState> _mapAddCarToState(AddCar event) async* {
    if (state is CarsLoaded && repo != null) {
      final List<Car> updatedCars = List.from((state as CarsLoaded).cars)
        ..add(event.car);
      yield CarsLoaded(updatedCars);
      repo.addNewCar(event.car);
    }
  }

  Stream<CarsState> _mapUpdateCarToState(UpdateCar event) async* {
    if (state is CarsLoaded && repo != null) {
      final List<Car> updatedCars = (state as CarsLoaded).cars.map((car) {
        return car.id == event.updatedCar.id ? event.updatedCar : car;
      }).toList();
      yield CarsLoaded(updatedCars);
      repo.updateCar(event.updatedCar);
    }
  }

  Stream<CarsState> _mapDeleteCarToState(DeleteCar event) async* {
    if (state is CarsLoaded && repo != null) {
      final updatedCars = (state as CarsLoaded)
          .cars
          .where((car) => car.id != event.car.id)
          .toList();
      yield CarsLoaded(updatedCars);
      repo.deleteCar(event.car);
    }
  }

  Car _updateWithRefueling(Car c, Refueling r) {
    var mileage, lastMileageUpdate, averageEfficiency;
    // update mileage
    if (c.mileage < r.mileage) {
      mileage = r.mileage;
      lastMileageUpdate = util.roundToDay(r.date);
    }
    var numRefuelings = c.numRefuelings + 1;
    // Update efficiency
    if (numRefuelings == 1) {
      // first refueling for this car
      averageEfficiency = r.efficiency;
    } else {
      averageEfficiency =
          _efficiencyFilter(numRefuelings, c.averageEfficiency, r.efficiency);
    }
    // Distance Rate
    var elapsedDuration = r.date.difference(c.lastMileageUpdate);
    var dist = r.mileage - c.mileage;
    var curDistRate = dist.toDouble() / elapsedDuration.inDays.toDouble();
    var distanceRate =
        _distanceFilter(numRefuelings, c.distanceRate, curDistRate);
    var distanceRateHistory = c.distanceRateHistory;
    distanceRateHistory
        .add(DistanceRatePoint(util.roundToDay(r.date), distanceRate));

    return c.copyWith(
      mileage: mileage,
      lastMileageUpdate: lastMileageUpdate,
      averageEfficiency: averageEfficiency,
      distanceRate: distanceRate,
      distanceRateHistory: distanceRateHistory,
      numRefuelings: numRefuelings,
    );
  }

  Stream<CarsState> _mapRefuelingsUpdatedToState(
      ExternalRefuelingsUpdated event) async* {
    if (repo == null || state is CarsNotLoaded) return;

    WriteBatchWrapper batch = repo.startCarWriteBatch();
    // TODO cache the cars here so that updating number of refuelings will work
    List<Car> updatedCars = (state as CarsLoaded).cars;
    for (var r in event.refuelings) {
      if (_refuelingsCache?.contains(r) ?? false) {
        continue; // only do calculations for updated refuelings
      }

      Car cur =
          (state as CarsLoaded).cars.firstWhere((car) => car.name == r.carName);
      Car update = _updateWithRefueling(cur, r);

      updatedCars = (state as CarsLoaded).cars.map((car) {
        return car.id == update.id ? update : car;
      }).toList();
      batch.updateData(update.id, update.toEntity().toDocument());
    }
    _refuelingsCache = event.refuelings;
    yield CarsLoaded(updatedCars);
    batch.commit();
  }

  @override
  Future<void> close() {
    _refuelingsSubscription?.cancel();
    _dbSubscription?.cancel();
    return super.close();
  }

  double _efficiencyFilter(int numRefuelings, double prev, double cur) {
    if (numRefuelings > EMA_CUTOFF) {
      return util.roundToPrecision(EMA_GAIN * prev + (1 - EMA_GAIN) * cur, 3);
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
