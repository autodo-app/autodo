import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/models/models.dart';
import '../../refuelings/barrel.dart';
import 'package:autodo/util.dart';
import 'event.dart';
import 'state.dart';

class EfficiencyStatsBloc
    extends Bloc<EfficiencyStatsEvent, EfficiencyStatsState> {
  final RefuelingsBloc _refuelingsBloc;
  StreamSubscription _refuelingsSubscription;
  static const EMA_CUTOFF = 8;

  EfficiencyStatsBloc({@required refuelingsBloc})
      : assert(refuelingsBloc != null),
        _refuelingsBloc = refuelingsBloc;

  @override
  EfficiencyStatsState get initialState => EfficiencyStatsLoading();

  @override
  Stream<EfficiencyStatsState> mapEventToState(
      EfficiencyStatsEvent event) async* {
    if (event is LoadEfficiencyStats) {
      yield* _mapLoadEfficiencyStatsToState(event);
    } else if (event is UpdateEfficiencyData) {
      yield* _mapUpdateEfficiencyDataToState(event);
    }
  }

  Stream<EfficiencyStatsState> _mapLoadEfficiencyStatsToState(event) async* {
    if (_refuelingsBloc.state is RefuelingsLoaded) {
      final data = await _prepData(
          (_refuelingsBloc.state as RefuelingsLoaded).refuelings);
      yield EfficiencyStatsLoaded(data);
    }
    _refuelingsSubscription?.cancel();
    _refuelingsBloc.listen((state) {
      if (state is RefuelingsLoaded) {
        add(UpdateEfficiencyData(state.refuelings));
      }
    });
  }

  // _interpolateDate(DateTime prev, DateTime next) {
  //   return DateTime.fromMillisecondsSinceEpoch(
  //       (prev.millisecondsSinceEpoch + next.millisecondsSinceEpoch / 2)
  //           .toInt());
  // }

  static double emaFilter(prev, current) =>
      roundToPrecision(0.8 * prev + 0.2 * current, 3);

  Future<List<Series<FuelMileagePoint, DateTime>>> _prepData(refuelings) async {
    final points = <FuelMileagePoint>[];
    for (var r in refuelings) {
      if (r.efficiency == double.infinity || r.efficiency == 0) continue;
      points.add(FuelMileagePoint(r.date, r.efficiency));
    }

    final emaData = <FuelMileagePoint>[];
    for (var point in points) {
      if (emaData.isEmpty) {
        emaData.add(point);
        continue;
      }
      final last = emaData[emaData.length - 1];
      final newDate = point.date;
      double newEfficiency;
      if (points.indexOf(point) < EMA_CUTOFF) {
        // for first few values, just do simple moving average
        newEfficiency = (last.efficiency + point.efficiency) / 2;
      } else {
        newEfficiency = emaFilter(last.efficiency, point.efficiency);
      }

      final newPoint = FuelMileagePoint(newDate, newEfficiency);
      // var interDate = _interpolateDate(last.date, point.date);
      // var interEfficiency = last.efficiency * 0.8 + newPoint.efficiency * 0.2;
      // var interpolate = FuelMileagePoint(interDate, interEfficiency);
      // emaData.add(interpolate);
      emaData.add(newPoint);
    }

    final mpgs = points.map((val) => val.efficiency);
    // Not worth displaying a line graph with only one point
    if (mpgs.length < 2) return [];

    final maxMeasure = mpgs.reduce(max);
    final minMeasure = mpgs.reduce(min);

    return [
      Series<FuelMileagePoint, DateTime>(
        id: 'Fuel Mileage vs Time',
        // Providing a color function is optional.
        colorFn: (FuelMileagePoint point, _) {
          // Shade the point from red to green depending on its position relative to min/max
          final scale = scaleToUnit(point.efficiency, minMeasure, maxMeasure);
          final hue = scale * 120; // 0 is red, 120 is green in HSV space
          final rgb = hsv2rgb(HSV(hue, 1.0, 0.5));
          return Color(
              r: (rgb.r * 255).toInt(),
              g: (rgb.g * 255).toInt(),
              b: (rgb.b * 255).toInt());
        },
        domainFn: (FuelMileagePoint point, _) => point.date,
        measureFn: (FuelMileagePoint point, _) => point.efficiency,
        // Providing a radius function is optional.
        radiusPxFn: (FuelMileagePoint point, _) =>
            6.0, // all values have the same radius for now
        data: points,
      ),
      // Configure our custom line renderer for this series.
      Series<FuelMileagePoint, DateTime>(
          id: 'EMA',
          colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
          domainFn: (FuelMileagePoint point, _) => point.date,
          measureFn: (FuelMileagePoint point, _) => point.efficiency,
          // measureUpperBoundFn: (p, idx) => 1.5 * p.efficiency, // used to shade area above/below curve
          // measureLowerBoundFn: (p, idx) => 0.667 * p.efficiency,
          data: emaData)
        ..setAttribute(rendererIdKey, 'customLine'),
    ];
  }

  Stream<EfficiencyStatsState> _mapUpdateEfficiencyDataToState(event) async* {
    final data = await _prepData(event.refuelings);
    yield EfficiencyStatsLoaded(data);
  }

  @override
  Future<void> close() {
    _refuelingsSubscription?.cancel();
    return super.close();
  }
}
