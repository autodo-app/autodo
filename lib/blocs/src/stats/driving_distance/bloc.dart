import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/models/models.dart';
import '../../cars/barrel.dart';
import 'event.dart';
import 'state.dart';

class DrivingDistanceStatsBloc
    extends Bloc<DrivingDistanceStatsEvent, DrivingDistanceStatsState> {
  final CarsBloc _carsBloc;
  StreamSubscription _carsSubscription;

  DrivingDistanceStatsBloc({@required carsBloc})
      : assert(carsBloc != null),
        _carsBloc = carsBloc;

  @override
  DrivingDistanceStatsState get initialState => DrivingDistanceStatsLoading();

  @override
  Stream<DrivingDistanceStatsState> mapEventToState(
      DrivingDistanceStatsEvent event) async* {
    if (event is LoadDrivingDistanceStats) {
      yield* _mapLoadDrivingDistanceStatsToState(event);
    } else if (event is UpdateDrivingDistanceData) {
      yield* _mapUpdateDrivingDistanceDataToState(event);
    }
  }

  Stream<DrivingDistanceStatsState> _mapLoadDrivingDistanceStatsToState(
      event) async* {
    if (_carsBloc.state is CarsLoaded) {
      final data = await _prepData((_carsBloc.state as CarsLoaded).cars);
      yield DrivingDistanceStatsLoaded(data);
    }
    _carsSubscription?.cancel();
    _carsBloc.listen((state) {
      if (state is CarsLoaded) {
        add(UpdateDrivingDistanceData(state.cars));
      }
    });
  }

  Future<List<Series<DistanceRatePoint, DateTime>>> _prepData(cars) async {
    var out = List<Series<DistanceRatePoint, DateTime>>();
    for (var car in cars) {
      var points = car.distanceRateHistory;
      if (points == null || points.length == 0) continue;

      out.add(Series<DistanceRatePoint, DateTime>(
        id: car.name,
        // colorFn: (_, __) {
        //   var primaryColor = Theme.of(context).primaryColor;
        //   return Color(r: primaryColor.red, g: primaryColor.green, b: primaryColor.blue);
        // },
        domainFn: (DistanceRatePoint point, _) => point.date,
        measureFn: (DistanceRatePoint point, _) => point.distanceRate,
        data: points,
      ));
    }
    return out;
  }

  Stream<DrivingDistanceStatsState> _mapUpdateDrivingDistanceDataToState(
      event) async* {
    final data = await _prepData(event.cars);
    yield DrivingDistanceStatsLoaded(data);
  }

  @override
  Future<void> close() {
    _carsSubscription?.cancel();
    return super.close();
  }
}
