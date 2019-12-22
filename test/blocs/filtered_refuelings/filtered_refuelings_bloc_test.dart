import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState>
    implements RefuelingsBloc {}

void main() {
  group('FilteredRefuelingsBloc', () {
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
    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'adds RefuelingsUpdated when RefuelingsBloc.state emits RefuelingsLoaded',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state).thenReturn(RefuelingsLoaded([refueling]));
        whenListen(
          refuelingsBloc,
          Stream<RefuelingsState>.fromIterable([RefuelingsLoaded([refueling])]),
        );
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc);
      }, 
      expect: [
        FilteredRefuelingsLoaded(
          [refueling],
          VisibilityFilter.all,
        ),
      ]
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'should update the VisibilityFilter when filter is active',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state)
            .thenReturn(RefuelingsLoaded([refueling]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc);
      },
      act: (FilteredRefuelingsBloc bloc) async =>
          bloc.add(UpdateRefuelingsFilter(VisibilityFilter.active)),
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded(
          [refueling],
          VisibilityFilter.all,
        ),
        FilteredRefuelingsLoaded(
          [refueling],
          VisibilityFilter.active,
        ),
      ],
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'should update the VisibilityFilter when filter is completed',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state)
            .thenReturn(RefuelingsLoaded([refueling]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc);
      },
      act: (FilteredRefuelingsBloc bloc) async =>
          bloc.add(UpdateRefuelingsFilter(VisibilityFilter.completed)),
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded(
          [refueling],
          VisibilityFilter.all,
        ),
        FilteredRefuelingsLoaded([refueling], VisibilityFilter.completed),
      ],
    );
  }); 
}