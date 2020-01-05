import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('repeats state', () {
    test('sort with mileage interval', () {
      final state = RepeatsLoaded([
        Repeat(mileageInterval: 1000),
        Repeat(mileageInterval: 500),
        Repeat(mileageInterval: 2000)
      ]);
      expect(state.sorted(), [
        Repeat(mileageInterval: 500),
        Repeat(mileageInterval: 1000),
        Repeat(mileageInterval: 2000)
      ]);
    });
    test('sort with name', () {
      final state = RepeatsLoaded([
        Repeat(mileageInterval: 1000, name: 'b'),
        Repeat(mileageInterval: 1000, name: 'a')
      ]);
      expect(state.sorted(), [
        Repeat(mileageInterval: 1000, name: 'a'),
        Repeat(mileageInterval: 1000, name: 'b')
      ]);
    });
  });
}
