import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

void main() {
  group('FilteredRefuelingsEvent', () {
    final snap = OdomSnapshot(
      car: 'test',
      mileage: 0,
      date: DateTime.fromMillisecondsSinceEpoch(0),
    );

    final refueling = Refueling(
        id: '0',
        amount: 0,
        cost: 0,
        efficiency: 0.0,
        efficiencyColor: Color(0),
        odomSnapshot: snap);

    final car = Car(
      id: 'test',
      odomSnapshot: snap,
      name: 'test',
    );

    group('UpdateFilter', () {
      test('toString returns correct value', () {
        expect(
          UpdateRefuelingsFilter(VisibilityFilter.active).toString(),
          'UpdateFilter { filter: VisibilityFilter.active }',
        );
      });
      test('props are correct', () {
        expect(
          UpdateRefuelingsFilter(VisibilityFilter.active).props,
          [VisibilityFilter.active],
        );
      });
    });

    group('UpdateRefuelings', () {
      test('toString returns correct value', () {
        expect(
          FilteredRefuelingDataUpdated(refuelings: [refueling]).toString(),
          'UpdateRefuelings { refuelings: [$refueling] }',
        );
      });
      test('props are correct', () {
        expect(
          FilteredRefuelingDataUpdated(refuelings: [refueling]).props,
          [
            [refueling]
          ],
        );
      });
    });
    group('UpdateCars', () {
      test('toString returns correct value', () {
        expect(
          FilteredRefuelingDataUpdated(cars: [car]).toString(),
          'FilteredRefuelingsUpdateCars { cars: ${[car]} }',
        );
      });
      test('props are correct', () {
        expect(
          FilteredRefuelingDataUpdated(cars: [car]).props,
          [
            [car]
          ],
        );
      });
    });
  });
}
