import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/entities/entities.dart';

void main() {
  group('RepeatEntity', () {
    final repeat = RepeatEntity('', '', 0, Duration(hours: 0), ['']);
    test('props', () {
      expect(repeat.props, ['', '', 0, Duration(hours: 0), ['']]);
    });
    test('toString', () {
      expect(repeat.toString(), 'RepeatEntity { id: , name: , mileage'
      'Interval: 0, dateInterval: ${Duration(hours: 0)}, cars: '
      '[]}');
    });
  });
}