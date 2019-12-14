import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/models/barrel.dart';
import 'package:autodo/blocs/refuelings/barrel.dart';
import 'event.dart';
import 'state.dart';

class DrivingDistanceStatsBloc extends Bloc<DrivingDistanceStatsEvent, DrivingDistanceStatsState> {
  final RefuelingsBloc _refuelingsBloc;
  StreamSubscription _refuelingsSubscription;

  DrivingDistanceStatsBloc({@required refuelingsBloc}) :
      assert(refuelingsBloc != null), _refuelingsBloc = refuelingsBloc;

  @override
  DrivingDistanceStatsState get initialState => DrivingDistanceStatsLoading();

  @override
  Stream<DrivingDistanceStatsState> mapEventToState(DrivingDistanceStatsEvent event) async* {
    if (event is LoadDrivingDistanceStats) {
      yield* _mapLoadDrivingDistanceStatsToState(event);
    } else if (event is UpdateDrivingDistanceData) {
      yield* _mapUpdateDrivingDistanceDataToState(event);
    }
  }

  Stream<DrivingDistanceStatsState> _mapLoadDrivingDistanceStatsToState(event) async* {
    _refuelingsSubscription?.cancel();
    _refuelingsBloc.listen(
      (state) {
        if (state is RefuelingsLoaded) {
          add(UpdateDrivingDistanceData(state.refuelings));
        }
      }
    );
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

  Stream<DrivingDistanceStatsState> _mapUpdateDrivingDistanceDataToState(event) async* {
    final data = await _prepData(event.cars);
    yield(DrivingDistanceStatsLoaded(data));
  }

  @override
  Future<void> close() {
    _refuelingsSubscription?.cancel();
    return super.close();
  }
}