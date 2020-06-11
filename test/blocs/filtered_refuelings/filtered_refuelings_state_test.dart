import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

void main() {
  group('FilteredRefuelingsState', () {
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

    test('props are correct', () {
      expect(
        FilteredRefuelingsLoading().props,
        [],
      );
    });
    group('FilteredRefuelingsLoaded', () {
      test('toString returns correct value', () {
        expect(
          FilteredRefuelingsLoaded(
              [refueling], VisibilityFilter.active, [car]).toString(),
          'FilteredRefuelingsLoaded { filteredRefuelings: [$refueling], activeFilter: VisibilityFilter.active, cars: ${[car]} }',
        );
      });
      test('props are correct', () {
        expect(
          FilteredRefuelingsLoaded(
              [refueling], VisibilityFilter.active, [car]).props,
          [
            [refueling],
            VisibilityFilter.active,
            [car]
          ],
        );
      });
    });
  });
}
