import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('EfficiencyStatsEvent', () {
    final refueling = Refueling(
      id: '0', 
      mileage: 0, 
      amount: 10,
      cost: 10.0,
      date: DateTime.fromMillisecondsSinceEpoch(0),
      carName: 'test'
    );
    test('Load props', () {
      expect(LoadEfficiencyStats().props, []);
    });
    test('Update props', () {
      expect(UpdateEfficiencyData([refueling]).props, [[refueling]]);
    });
    test('Update toString', () {
      expect(UpdateEfficiencyData([refueling]).toString(), "UpdateEfficiencyData { refuelings: ${[refueling]} }");
    });
  });
}