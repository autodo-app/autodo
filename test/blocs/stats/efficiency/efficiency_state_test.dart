import 'package:flutter_test/flutter_test.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';

void main() {
  group('EfficiencyState', () {
    test('toString', () {
      final refueling = Refueling(
        id: '0',
        date: DateTime.fromMillisecondsSinceEpoch(0),
        efficiency: 1.0,
      );
      expect(
        EfficiencyStatsLoaded([
          Series<FuelMileagePoint, DateTime>(
            id: 'Fuel Mileage vs Time', 
            domainFn: (point, _) => point.date,
            measureFn: (point, _) => point.efficiency,
            data: [FuelMileagePoint(refueling.date, refueling.efficiency),
            FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(100), 2.0)],
          ),
          Series<FuelMileagePoint, DateTime>(
            id: 'EMA', 
            domainFn: (point, _) => point.date,
            measureFn: (point, _) => point.efficiency,
            data: [FuelMileagePoint(refueling.date, refueling.efficiency),
            FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(100), EfficiencyStatsBloc.emaFilter(1.0, 2.0))],
          )
        ]).toString(),
        'EfficiencyStatsLoaded { fuelEfficiencyData:[FuelMileagePoint { date: '
        '1969-12-31 19:00:00.000, efficiency: 1.0 }, FuelMileagePoint { date: '
        '1969-12-31 19:00:00.100, efficiency: 2.0 }][FuelMileagePoint { date: '
        '1969-12-31 19:00:00.000, efficiency: 1.0 }, FuelMileagePoint { date: '
        '1969-12-31 19:00:00.100, efficiency: 1.2 }] }'
      );
    });
  });
}