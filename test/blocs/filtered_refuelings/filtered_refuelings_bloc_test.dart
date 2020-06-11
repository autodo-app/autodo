import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

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

FilteredRefuelingsBloc buildFunc() {
  final dataBloc = MockDataBloc();
  when(dataBloc.state).thenReturn(DataLoaded(refuelings: [refueling], cars: [car]));
  whenListen(
    dataBloc,
    Stream<DataState>.fromIterable([
      DataLoaded(refuelings: [refueling], cars: [car])
    ]),
  );
  return FilteredRefuelingsBloc(dataBloc: dataBloc);
}

void main() {
  group('FilteredDataBloc', () {
    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent,
            FilteredRefuelingsState>(
      'adds DataUpdated when DataBloc.state emits DataLoaded',
      build: buildFunc, 
      expect: [
        FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [car]),
    ]);

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent,
        FilteredRefuelingsState>(
      'should update the VisibilityFilter when filter is active',
      build: buildFunc,
      act: (FilteredRefuelingsBloc bloc) async =>
          bloc.add(UpdateRefuelingsFilter(VisibilityFilter.active)),
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [car]),
        FilteredRefuelingsLoaded([refueling], VisibilityFilter.active, [car]),
      ],
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent,
        FilteredRefuelingsState>(
      'should update the VisibilityFilter when filter is completed',
      build: buildFunc,
      act: (FilteredRefuelingsBloc bloc) async =>
          bloc.add(UpdateRefuelingsFilter(VisibilityFilter.completed)),
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [car]),
        FilteredRefuelingsLoaded(
            [refueling], VisibilityFilter.completed, [car]),
      ],
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent,
        FilteredRefuelingsState>(
      'loading',
      build: buildFunc,
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoading(),
      ],
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent,
        FilteredRefuelingsState>(
      'not loaded',
      build: buildFunc,
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsNotLoaded(),
      ],
    );

    // final car = Car(name: 'test', averageEfficiency: 1.0);
    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent,
        FilteredRefuelingsState>(
      'shade efficiency',
      build: buildFunc,
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded(
            [refueling.copyWith(efficiencyColor: Color(0xffff0000))],
            VisibilityFilter.all,
            [car]),
      ],
    );
    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent,
        FilteredRefuelingsState>(
      'cars updated',
      build: buildFunc,
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded(
            [refueling.copyWith(efficiencyColor: Color(0))],
            VisibilityFilter.all,
            [car]),
        FilteredRefuelingsLoaded(
            [refueling.copyWith(efficiencyColor: Color(0xffff0000))],
            VisibilityFilter.all,
            [car]),
      ],
    );
  });
}
