import 'package:charts_flutter/flutter.dart';
import 'package:flutter/widgets.dart';

import '../../../blocs/blocs.dart';
import '../../../units/units.dart';
import '../../models.dart';
import '../distanceratepoint.dart';

class DrivingDistanceStats {
  static Future<List<Series<DistanceRatePoint, DateTime>>> fetch(
    DataBloc dataBloc,
    BuildContext context,
  ) async {
    var state = dataBloc.state;
    if (state is DataLoaded) {
      return _prepData(state.cars, context);
    }

    await for (final _state in dataBloc) {
      if (_state is DataLoaded) {
        state = _state;
        break;
      }
    }

    if (state is DataLoaded) {
      return _prepData(state.cars, context);
    }

    throw 'Unable to load car';
  }

  static Future<List<Series<DistanceRatePoint, DateTime>>> _prepData(
    List<Car> cars,
    BuildContext context,
  ) async {
    final out = <Series<DistanceRatePoint, DateTime>>[];
    final distance = Distance.of(context);
    final unit = distance.unitString(context, short: true);

    for (var car in cars) {
      final points = car.distanceRateHistory;

      if (points == null || points.isEmpty) continue;

      out.add(
        Series<DistanceRatePoint, DateTime>(
          id: car.name,
          // colorFn: (_, __) {
          //   var primaryColor = Theme.of(context).primaryColor;
          //   return Color(r: primaryColor.red, g: primaryColor.green, b: primaryColor.blue);
          // },
          domainFn: (DistanceRatePoint point, _) => point.date,
          measureFn: (DistanceRatePoint point, _) =>
              distance.internalToUnit(point.distanceRate),
          measureFormatterFn: (DistanceRatePoint point, _) =>
              (num v) => '${distance.format(v)} $unit',
          domainFormatterFn: (DistanceRatePoint t, int _) => (v) => 'd',
          labelAccessorFn: (DistanceRatePoint point, _) => 'HELLO $point',
          data: points,
        ),
      );
    }

    return out;
  }
}
