import 'package:flutter_test/flutter_test.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('EfficiencyState', () {
    test('toString', () {
      final refueling = Refueling(
          id: '0',
          mileage: 0,
          amount: 10,
          cost: 10.0,
          efficiency: 1.0,
          date: DateTime.fromMillisecondsSinceEpoch(0),
          carName: 'test');
      expect(
          EfficiencyStatsLoaded([
            Series<FuelMileagePoint, DateTime>(
              id: 'Fuel Mileage vs Time',
              domainFn: (point, _) => point.date,
              measureFn: (point, _) => point.efficiency,
              data: [
                FuelMileagePoint(refueling.date, refueling.efficiency),
                FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(100), 2.0)
              ],
            ),
            Series<FuelMileagePoint, DateTime>(
              id: 'EMA',
              domainFn: (point, _) => point.date,
              measureFn: (point, _) => point.efficiency,
              data: [
                FuelMileagePoint(refueling.date, refueling.efficiency),
                FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(100),
                    EfficiencyStatsBloc.emaFilter(1.0, 2.0))
              ],
            )
          ]).toString(),
          'EfficiencyStatsLoaded { fuelEfficiencyData:[FuelMileagePoint { date: '
          '1970-01-01 00:00:00.000Z, efficiency: 1.0 }, FuelMileagePoint { date: '
          '1970-01-01 00:00:00.100Z, efficiency: 2.0 }][FuelMileagePoint { date: '
          '1970-01-01 00:00:00.000Z, efficiency: 1.0 }, FuelMileagePoint { date: '
          '1970-01-01 00:00:00.100Z, efficiency: 1.2 }] }');
    });
  });
}
