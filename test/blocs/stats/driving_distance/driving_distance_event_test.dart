import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';

void main() {
  group('DrivingDistanceStatsEvent', () {
    test('Load props', () {
      expect(LoadDrivingDistanceStats().props, []);
    });
    test('Update props', () {
      expect(UpdateDrivingDistanceData([Car()]).props, [[Car()]]);
    });
    test('Update toString', () {
      expect(UpdateDrivingDistanceData([Car()]).toString(), "UpdateDrivingDistanceData { cars: ${[Car()]} }");
    });
  });
}