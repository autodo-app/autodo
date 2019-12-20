import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';

void main() {
  group('RefuelingsEvents', () {
    test('LoadRefuelings props', () {
      expect(LoadRefuelings().props, []);
    });
    group('AddRefueling', () {
      test('props', () {
        expect(AddRefueling(Refueling()).props, [Refueling()]);
      });
      test('toString', () {
        expect(AddRefueling(Refueling()).toString(), 'AddRefueling { refueling: ${Refueling()} }');
      });
    });
    group('UpdateRefueling', () {
      test('props', () {
        expect(UpdateRefueling(Refueling()).props, [Refueling()]);
      });
      test('toString', () {
        expect(UpdateRefueling(Refueling()).toString(), 'UpdateRefueling { refueling: ${Refueling()} }');
      });
    });
    group('DeleteRefueling', () {
      test('props', () {
        expect(DeleteRefueling(Refueling()).props, [Refueling()]);
      });
      test('toString', () {
        expect(DeleteRefueling(Refueling()).toString(), 'DeleteRefueling { refueling: ${Refueling()} }');
      });
    });
    group('ExternalCarsUpdated', () {
      test('props', () {
        expect(ExternalCarsUpdated([Car()]).props, [[Car()]]);
      });
      test('toString', () {
        expect(ExternalCarsUpdated([Car()]).toString(), 'ExternalCarsUpdated { cars: ${[Car()]} }');
      });
    });
  });
}