import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/entities/barrel.dart';

void main() {
  group('CarEntity', () {
    final car = CarEntity('', '', 0, 0, 0.0, 0.0, DateTime.fromMillisecondsSinceEpoch(0), []);
    test('props', () {
      expect(car.props, ['', '', 0, 0, 0.0, 0.0, DateTime.fromMillisecondsSinceEpoch(0), []]);
    });
    test('toString', () {
      expect(car.toString(), 'CarEntity { id: , name: , mileage: 0, '
      'numRefuelings: 0, averageEfficiency: 0.0, distanceRate: '
      '0.0, lastMileageUpdate: ${DateTime.fromMillisecondsSinceEpoch(0)}, distanceRateHistory: [] }');
    });
  });
}