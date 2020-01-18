import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('DrivingDistanceStatsEvent', () {
    test('Load props', () {
      expect(LoadDrivingDistanceStats().props, []);
    });
    test('Update props', () {
      expect(UpdateDrivingDistanceData([Car()]).props, [
        [Car()]
      ]);
    });
    test('Update toString', () {
      expect(UpdateDrivingDistanceData([Car()]).toString(),
          "UpdateDrivingDistanceData { cars: ${[Car()]} }");
    });
  });
}
