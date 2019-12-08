import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/models/barrel.dart';

class CarsBloc extends Bloc<CarsEvent, CarsState> {
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
}
