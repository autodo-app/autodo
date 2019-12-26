import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState>
    implements RefuelingsBloc {}

void main() {
  group('FilteredRefuelingsEvent', () {
    final refueling = Refueling(
      carName: '',
      id: '',
      mileage: 0,
      date: DateTime.fromMillisecondsSinceEpoch(0),
      amount: 0,
      cost: 0,
      carColor: Color(0),
      efficiency: 0.0,
      efficiencyColor: Color(0)
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
          UpdateRefuelings([refueling]).toString(),
          'UpdateRefuelings { refuelings: [$refueling] }',
        );
      });
      test('props are correct', () {
        expect(
          UpdateRefuelings([refueling]).props,
          [[refueling]],
        );
      });
    });
    group('UpdateCars', () {
      test('toString returns correct value', () {
        expect(
          FilteredRefuelingsUpdateCars([Car()]).toString(),
          'FilteredRefuelingsUpdateCars { cars: ${[Car()]} }',
        );
      });
      test('props are correct', () {
        expect(
          FilteredRefuelingsUpdateCars([Car()]).props,
          [[Car()]],
        );
      });
    });
  });
}