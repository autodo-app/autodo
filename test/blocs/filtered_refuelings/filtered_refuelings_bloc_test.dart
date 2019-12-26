import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState>
    implements RefuelingsBloc {}
class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

void main() {
  group('FilteredRefuelingsBloc', () {
    final refueling = Refueling(
      carName: 'test',
      id: '0',
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
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([Car()]));
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car()])]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc, carsBloc: carsBloc);
      }, 
      expect: [
        FilteredRefuelingsLoaded(
          [refueling],
          VisibilityFilter.all,
          [Car()]
        ),
      ]
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'should update the VisibilityFilter when filter is active',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state)
            .thenReturn(RefuelingsLoaded([refueling]));
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([Car()]));
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car()])]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc, carsBloc: carsBloc);
      },
      act: (FilteredRefuelingsBloc bloc) async =>
          bloc.add(UpdateRefuelingsFilter(VisibilityFilter.active)),
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded(
          [refueling],
          VisibilityFilter.all,
          [Car()]
        ),
        FilteredRefuelingsLoaded(
          [refueling],
          VisibilityFilter.active,
          [Car()]
        ),
      ],
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'should update the VisibilityFilter when filter is completed',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state)
            .thenReturn(RefuelingsLoaded([refueling]));
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([Car()]));
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car()])]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc, carsBloc: carsBloc);
      },
      act: (FilteredRefuelingsBloc bloc) async =>
          bloc.add(UpdateRefuelingsFilter(VisibilityFilter.completed)),
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded(
          [refueling],
          VisibilityFilter.all,
          [Car()]
        ),
        FilteredRefuelingsLoaded([refueling], VisibilityFilter.completed, [Car()]),
      ],
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'loading',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state)
            .thenReturn(RefuelingsLoading());
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([Car()]));
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car()])]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc, carsBloc: carsBloc);
      },
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoading(),
      ],
    );

    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'not loaded',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state)
            .thenReturn(RefuelingsNotLoaded());
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([Car()]));
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car()])]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc, carsBloc: carsBloc);
      },
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsNotLoaded(),
      ],
    );
    
    final car = Car(  
      name: 'test',
      averageEfficiency: 1.0
    );
    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'shade efficiency',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state)
            .thenReturn(RefuelingsLoaded([refueling]));
        final carsBloc = MockCarsBloc();
        
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([car]));
        // whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([car])]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc, carsBloc: carsBloc);
      },
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded(
          [refueling.copyWith(efficiencyColor: Color(0xffff0000))],
          VisibilityFilter.all,
          [car]
        ),
      ],
    );
    blocTest<FilteredRefuelingsBloc, FilteredRefuelingsEvent, FilteredRefuelingsState>(
      'cars updated',
      build: () {
        final refuelingsBloc = MockRefuelingsBloc();
        when(refuelingsBloc.state)
            .thenReturn(RefuelingsLoaded([refueling]));
        final carsBloc = MockCarsBloc();
        
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([Car()]));
        whenListen(carsBloc, Stream.fromIterable([CarsLoaded([car])]));
        return FilteredRefuelingsBloc(refuelingsBloc: refuelingsBloc, carsBloc: carsBloc);
      },
      expect: <FilteredRefuelingsState>[
        FilteredRefuelingsLoaded(
          [refueling.copyWith(efficiencyColor: Color(0))],
          VisibilityFilter.all,
          [Car()]
        ),
        FilteredRefuelingsLoaded(
          [refueling.copyWith(efficiencyColor: Color(0xffff0000))],
          VisibilityFilter.all,
          [car]
        ),
      ],
    );
  }); 
}