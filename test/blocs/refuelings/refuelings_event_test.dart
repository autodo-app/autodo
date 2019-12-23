import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('RefuelingsEvents', () {
    final refueling = Refueling(
      id: '0', 
      mileage: 0, 
      amount: 10,
      cost: 10.0,
      date: DateTime.fromMillisecondsSinceEpoch(0),
      carName: 'test'
    );
    test('LoadRefuelings props', () {
      expect(LoadRefuelings().props, []);
    });
    group('AddRefueling', () {
      test('props', () {
        expect(AddRefueling(refueling).props, [refueling]);
      });
      test('toString', () {
        expect(AddRefueling(refueling).toString(), 'AddRefueling { refueling: $refueling }');
      });
    });
    group('UpdateRefueling', () {
      test('props', () {
        expect(UpdateRefueling(refueling).props, [refueling]);
      });
      test('toString', () {
        expect(UpdateRefueling(refueling).toString(), 'UpdateRefueling { refueling: $refueling }');
      });
    });
    group('DeleteRefueling', () {
      test('props', () {
        expect(DeleteRefueling(refueling).props, [refueling]);
      });
      test('toString', () {
        expect(DeleteRefueling(refueling).toString(), 'DeleteRefueling { refueling: $refueling }');
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