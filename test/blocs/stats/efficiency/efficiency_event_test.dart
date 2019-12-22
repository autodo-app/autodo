import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('EfficiencyStatsEvent', () {
    test('Load props', () {
      expect(LoadEfficiencyStats().props, []);
    });
    test('Update props', () {
      expect(UpdateEfficiencyData([Refueling()]).props, [[Refueling()]]);
    });
    test('Update toString', () {
      expect(UpdateEfficiencyData([Refueling()]).toString(), "UpdateEfficiencyData { refuelings: ${[Refueling()]} }");
    });
  });
}