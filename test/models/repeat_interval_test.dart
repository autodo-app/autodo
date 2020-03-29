import 'package:autodo/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('repeat interval', () {
    test('addToDate', () {
      final epoch = DateTime.fromMillisecondsSinceEpoch(0);
      final interval = RepeatInterval(years: 1, months: 1, days: 1);
      expect(interval.addToDate(epoch), DateTime(1971, 2, 1));
    });
  });
}
