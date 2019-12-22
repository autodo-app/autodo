import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/entities/entities.dart';

void main() {
  group('RefuelingEntity', () {
    final refueling = RefuelingEntity('', '', 0, DateTime.fromMillisecondsSinceEpoch(0), 0.0, 0.0, Color(0), 0.0, Color(0));
    test('props', () {
      expect(refueling.props, ['', '', 0, DateTime.fromMillisecondsSinceEpoch(0), 0.0, 0.0, Color(0), 0.0, Color(0)]);
    });
    test('toString', () {
      expect(refueling.toString(), 'RefuelingEntity { id: , name: , carColor: '
      '${Color(0)}, mileage: 0, date: '
      '${DateTime.fromMillisecondsSinceEpoch(0)}, amount: 0.0, '
      'cost: 0.0, efficiency: 0.0, efficiencyColor: ${Color(0)} }');
    });
  });
}