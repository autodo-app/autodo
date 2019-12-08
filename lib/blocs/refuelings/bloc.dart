import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/util.dart';

class RefuelingsBloc extends Bloc<RefuelingsEvent, RefuelingsState> {
  static const int MAX_MPG = 0xffff;
  static const int HUE_RANGE = 60; // range of usable hues is 0-120, or +- 60
  static const double EFF_VAR = 5.0;
  static const double HUE_MAX = 360.0;
  // don't know why anyone would enter this many, but preventing overflow here
  static const int MAX_NUM_REFUELINGS = 0xffff;

  final DataRepository _dataRepository;
  StreamSubscription _dataSubscription;

  RefuelingsBloc({@required DataRepository dataRepository})
      : assert(dataRepository != null),
        _dataRepository = dataRepository;

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
    } else if (event is RefuelingsUpdated) {
      yield* _mapRefuelingsUpdateToState(event);
    }
  }

  Future<Refueling> _findLatestRefueling(Refueling refueling) async {
    var car = (refueling.carName != null) ? refueling.carName : '';
    var doc = FirestoreBLoC().getUserDocument();
    var refuelings = await doc.collection('refuelings').getDocuments();

    int smallestDiff = MAX_MPG;
    Refueling out;
    for (var r in refuelings.documents) {
      if (r.data['tags'] != null && r.data['tags'][0] == car) {
        var mileage = r.data['odom'];
        var diff = refueling.mileage - mileage;
        if (diff <= 0) continue; // only looking for past refuelings
        if (diff < smallestDiff) {
          smallestDiff = diff;
          out = Refueling.fromJSON(r.data, r.documentID);
        }
      }
    }
    return out;
  }

  Future<HSV> hsv(Refueling refueling) async {
    if (refueling.efficiency == double.infinity) return HSV(1.0, 1.0, 1.0);
    var car = await CarsBLoC().getCarByName(item.carName);
    var avgEff = car.averageEfficiency;
    // range is 0 to 120
    var diff = (refueling.efficiency == null || refueling.efficiency == double.infinity)
        ? 0
        : refueling.efficiency - avgEff;
    dynamic hue = (diff * HUE_RANGE) / EFF_VAR;
    hue = clamp(hue, 0, HUE_RANGE * 2);
    return HSV(hue.toDouble(), 1.0, 1.0);
  }

  Stream<RefuelingsState> _mapLoadRefuelingsToState() async* {
    _dataSubscription?.cancel();
    _dataSubscription = _dataRepository.refuelings().listen(
          (refuelings) => add(RefuelingsUpdated(refuelings)),
        );
  }

  Stream<RefuelingsState> _mapAddRefuelingToState(AddRefueling event) async* {
    var item = event.refueling;
    var prev = await _findLatestRefueling(item);
    var dist = (prev == null) ? 0 : item.mileage - prev.mileage;
    Refueling out = event.refueling.copyWith(efficiency: dist / item.amount);

    Car car = await CarsBLoC().getCarByName(item.carName);
    if (car.numRefuelings < MAX_NUM_REFUELINGS) car.numRefuelings++;
    car.updateMileage(item.odom, item.date);
    car.updateEfficiency(item.efficiency);
    car.updateDistanceRate((prev == null) ? null : prev.date, item.date, dist);
    CarsBLoC().edit(car);
    _dataRepository.addNewRefueling(out);
  }

  Stream<RefuelingsState> _mapUpdateRefuelingToState(UpdateRefueling event) async* {
    // TODO: pull this into its own async function since it doesn't affect our
    // ability to update a refueling
    var prev = await findLatestRefueling(item);
    var dist = (prev == null) ? 0 : item.odom - prev.odom;
    item.efficiency = dist / item.amount;

    Car car = await CarsBLoC().getCarByName(item.carName);
    car.updateMileage(item.odom, item.date);
    car.updateEfficiency(item.efficiency);
    car.updateDistanceRate((prev == null) ? null : prev.date, item.date, dist);
    CarsBLoC().edit(car);
    _dataRepository.updateRefueling(event.updatedRefueling);
  }

  Stream<RefuelingsState> _mapDeleteRefuelingToState(DeleteRefueling event) async* {
    var prev = await findLatestRefueling(item);
    Car car = await CarsBLoC().getCarByName(item.carName);
    car.updateMileage(prev.odom, prev.date, override: true);
    // TODO: figure out how to undo the efficiency and distance rate calcs
    CarsBLoC().edit(car);
    _dataRepository.deleteRefueling(event.todo);
  }

  Stream<RefuelingsState> _mapRefuelingsUpdateToState(RefuelingsUpdated event) async* {
    yield RefuelingsLoaded(event.todos);
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    return super.close();
  }
}
