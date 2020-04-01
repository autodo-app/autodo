import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../database/barrel.dart';
import '../refuelings/barrel.dart';
import 'event.dart';
import 'state.dart';

class CarsBloc extends Bloc<CarsEvent, CarsState> {
  CarsBloc(
      {@required DatabaseBloc dbBloc, @required RefuelingsBloc refuelingsBloc})
      : assert(dbBloc != null),
        assert(refuelingsBloc != null),
        _dbBloc = dbBloc,
        _refuelingsBloc = refuelingsBloc {
    _dbSubscription = _dbBloc.listen((state) {
      if (state is DbLoaded) {
        add(LoadCars());
        _repoSubscription = repo?.cars()?.listen((event) {
          add(LoadCars());
        });
      }
    });
    _refuelingsSubscription = _refuelingsBloc.listen((state) {
      if (state is RefuelingsLoaded) {
        add(ExternalRefuelingsUpdated(state.refuelings));
      }
    });
  }

  static const double EMA_GAIN = 0.9;

  static const double EMA_CUTOFF = 8;

  final DatabaseBloc _dbBloc;

  StreamSubscription _refuelingsSubscription,
      _dbSubscription,
      _repoSubscription;

  final RefuelingsBloc _refuelingsBloc;

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
    try {
      final cars = await repo
          .getCurrentCars()
          .timeout(Duration(seconds: 10), onTimeout: () => []);
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
      final updatedCars = List<Car>.from((state as CarsLoaded).cars)
        ..add(event.car);
      yield CarsLoaded(updatedCars);
      await repo.addNewCar(event.car);
    }
  }

  Stream<CarsState> _mapUpdateCarToState(UpdateCar event) async* {
    if (state is CarsLoaded && repo != null) {
      final updatedCars = (state as CarsLoaded).cars.map<Car>((car) {
        return car.id == event.updatedCar.id ? event.updatedCar : car;
      }).toList();
      yield CarsLoaded(updatedCars);
      await repo.updateCar(event.updatedCar);
    }
  }

  Stream<CarsState> _mapDeleteCarToState(DeleteCar event) async* {
    if (state is CarsLoaded && repo != null) {
      final updatedCars = (state as CarsLoaded)
          .cars
          .where((car) => car.id != event.car.id)
          .toList();
      yield CarsLoaded(updatedCars);
      await repo.deleteCar(event.car);
    }
  }

  DistanceRatePoint _findDifference(DistancePoint prev, DistancePoint cur) {
    final elapsedDuration = cur.date.difference(prev.date);
    final dist = cur.distance - prev.distance;
    final curDistRate = dist.toDouble() / elapsedDuration.inDays.toDouble();
    return DistanceRatePoint(cur.date, curDistRate);
  }

  Stream<CarsState> _mapRefuelingsUpdatedToState(
      ExternalRefuelingsUpdated event) async* {
    if (repo == null || state is CarsNotLoaded) return;

    final batch = await repo.startCarWriteBatch();
    var updatedCars = (state as CarsLoaded).cars;
    for (var c in (state as CarsLoaded).cars) {
      // Get a list of all refuelings for the car in order
      final thisCarsRefuelings = event.refuelings
          .where((r) => r.carName == c.name)
          .toList()
            ..sort((a, b) =>
                (a.mileage > b.mileage) ? 1 : (a.mileage < b.mileage) ? -1 : 0);

      // Historical tracking of the car's number of refuelings
      final numRefuelings = thisCarsRefuelings.length;
      if (numRefuelings == 0) {
        continue;
      }

      // Update average efficiency across all refuelings
      double averageEfficiency;
      if (numRefuelings == 1) {
        // first refueling for this car
        averageEfficiency = thisCarsRefuelings[0].efficiency;
      } else {
        // Todo: Exception: StateError (Bad state: No element)
        final sum = thisCarsRefuelings
            .map((e) => e.efficiency ?? 0.0)
            .reduce((value, element) => value + element);
        averageEfficiency = sum / numRefuelings;
      }

      // Create a list of the distances and dates from the refuelings, and use
      // the difference between them to find the distance rate values
      //
      // This assumes that the refuelings are in chronological and distance order,
      // there should be no invalid refuelings where the car's mileage seemed to
      // go backwards
      final points = <DistancePoint>[];
      final rates = <DistanceRatePoint>[];
      thisCarsRefuelings.forEach((r) {
        points.add(DistancePoint(r.date, r.mileage));
        if (points.length >= 2) {
          // reverse the list to get the most recently added values
          final reversedList = points.reversed.toList();
          rates.add(_findDifference(reversedList[1], reversedList[0]));
        }
      });

      // Set the car's mileage to the furthest distance value in the refueling
      // list
      final currentMileage = thisCarsRefuelings.last.mileage;

      final updated = c.copyWith(
          distanceRateHistory: rates,
          mileage: currentMileage,
          numRefuelings: numRefuelings,
          averageEfficiency: averageEfficiency);
      batch.updateData(updated.id, updated.toDocument());
      updatedCars = updatedCars
          .map((car) => car.id == updated.id ? updated : car)
          .toList();
    }
    await batch.commit();
    yield CarsLoaded(updatedCars);
  }

  @override
  Future<void> close() {
    _refuelingsSubscription?.cancel();
    _dbSubscription?.cancel();
    _repoSubscription?.cancel();
    return super.close();
  }

  // No longer using these filters, instead computing a simple moving average.
  // TODO: might be worth returning to using these eventually, but for now the
  // simple average should be fine.

  // double _efficiencyFilter(int numRefuelings, double prev, double cur) {
  //   if (numRefuelings > EMA_CUTOFF) {
  //     return util.roundToPrecision(EMA_GAIN * prev + (1 - EMA_GAIN) * cur, 3);
  //   } else {
  //     double fac1 = (numRefuelings - 1) / numRefuelings;
  //     double fac2 = 1 / numRefuelings;
  //     return prev * fac1 + cur * fac2;
  //   }
  // }

  // double _distanceFilter(int numItems, double prev, double cur) {
  //   if (numItems == 1 || prev == double.infinity) {
  //     // no point in averaging only one value
  //     return cur;
  //   } else if (numItems > EMA_CUTOFF) {
  //     // Use the EMA when we have enough data to get
  //     // good results from it
  //     return EMA_GAIN * prev + (1 - EMA_GAIN) * cur;
  //   } else {
  //     // simple moving average when we don't have much
  //     // data to work with
  //     numItems--; // we don't track distanceRate between first two refuelings
  //     double fac1 = (numItems - 1) / numItems;
  //     double fac2 = 1 / numItems;
  //     return prev * fac1 + cur * fac2;
  //   }
  // }
}
