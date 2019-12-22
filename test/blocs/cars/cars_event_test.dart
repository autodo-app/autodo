import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('CarsEvent', () {
    test('LoadCars', () {
      expect(LoadCars().props, []);
    });
    group('AddCar', () {
      test('props', () {
        expect(AddCar(Car()).props, [Car()]);
      });
      test('toString', () {
        expect(AddCar(Car()).toString(), 'AddCar { car: ${Car()} }');
      });
    });
    group('UpdateCar', () {
      test('props', () {
        expect(UpdateCar(Car()).props, [Car()]);
      });
      test('toString', () {
        expect(UpdateCar(Car()).toString(), 'UpdateCar { updatedCar: ${Car()} }');
      });
    });
    group('DeleteCar', () {
      test('props', () {
        expect(DeleteCar(Car()).props, [Car()]);
      });
      test('toString', () {
        expect(DeleteCar(Car()).toString(), 'DeleteCar { car: ${Car()} }');
      });
    });
    group('ExternalRefuelingsUpdated', () {
      test('props', () {
        expect(ExternalRefuelingsUpdated([Refueling()]).props, [[Refueling()]]);
      });
      test('toString', () {
        expect(ExternalRefuelingsUpdated([Refueling()]).toString(), 'ExternalRefuelingsUpdated { refuelings: ${[Refueling()]} }');
      });
    });
  });
}