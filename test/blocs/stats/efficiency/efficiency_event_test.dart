import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';

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