import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/widgets.dart';

import '../../../blocs/blocs.dart';
import '../../../units/units.dart';
import '../../../util.dart';
import '../../models.dart';

class EfficiencyStats {
  static const EMA_CUTOFF = 8;

  static Future<List<Series<FuelMileagePoint, DateTime>>> fetch(
    DataBloc dataBloc,
    BuildContext context,
  ) async {
    var state = dataBloc.state;
    if (state is DataLoaded) {
      return _prepData(state.refuelings, context);
    }

    await for (final _state in dataBloc) {
      if (_state is DataLoaded) {
        state = _state;
        break;
      }
    }

    if (state is DataLoaded) {
      return _prepData(state.refuelings, context);
    }

    throw 'Unable to load refuelings';
  }

  static double _emaFilter(double prev, double current) =>
      roundToPrecision(0.8 * prev + 0.2 * current, 3);

  static Future<List<Series<FuelMileagePoint, DateTime>>> _prepData(
    List<Refueling> refuelings,
    BuildContext context,
  ) async {
    final efficiencyUnit = Efficiency.of(context, listen: false);
    // final volume = Volume.of(context);

    final points = <FuelMileagePoint>[];
    double mileage;

    for (final refueling in refuelings) {
      if (mileage == null) {
        mileage = refueling.odomSnapshot.mileage;
        continue;
      }

      if (refueling.amount <= 0) continue;
      final dist = refueling.odomSnapshot.mileage - mileage;
      mileage = refueling.odomSnapshot.mileage;
      if (dist <= 0) continue;
      final efficiency = efficiencyUnit.internalToUnit(dist / refueling.amount);
      points.add(FuelMileagePoint(refueling.odomSnapshot.date, efficiency));
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
        newEfficiency = _emaFilter(last.efficiency, point.efficiency);
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
}
