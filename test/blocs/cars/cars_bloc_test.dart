import 'dart:async';

import 'package:autodo/util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockDataRepository extends Mock implements DataRepository {}

class MockRefuelingsBloc extends Mock implements RefuelingsBloc {}

class MockWriteBatch extends Mock implements WriteBatchWrapper {}

class MockDbBloc extends Mock implements DatabaseBloc {}

void main() {
  group('CarsBloc', () {
    test('Null Data Repository', () {
      final refuelingsBloc = MockRefuelingsBloc();
      expect(() => CarsBloc(dbBloc: null, refuelingsBloc: refuelingsBloc),
          throwsAssertionError);
    });
    test('Null Refuelings Bloc', () {
      final dbBloc = MockDbBloc();
      expect(() => CarsBloc(dbBloc: dbBloc, refuelingsBloc: null),
          throwsAssertionError);
    });
    group('LoadCars', () {
      blocTest<CarsBloc, CarsEvent, CarsState>('CarsLoaded',
          build: () {
            final dataRepository = MockDataRepository();
            when(dataRepository.getCurrentCars())
                .thenAnswer((_) async => [Car()]);
            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
            final refuelingsBloc = MockRefuelingsBloc();
            return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
          },
          act: (bloc) async => bloc.add(LoadCars()),
          expect: [
            CarsLoading(),
            CarsLoaded([Car()])
          ]);
      blocTest<CarsBloc, CarsEvent, CarsState>('Cars is null',
          build: () {
            final dataRepository = MockDataRepository();
            when(dataRepository.getCurrentCars()).thenAnswer((_) async => []);
            final refuelingsBloc = MockRefuelingsBloc();
            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
            return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
          },
          act: (bloc) async => bloc.add(LoadCars()),
          expect: [CarsLoading(), CarsLoaded([])]);
      blocTest<CarsBloc, CarsEvent, CarsState>('Event from Refuelings',
          build: () {
            final refueling = Refueling(
              id: '0',
              carName: 'test',
              amount: 10.0,
              cost: 10.0,
              mileage: 1000,
              date: DateTime.fromMillisecondsSinceEpoch(0),
            );
            final dataRepository = MockDataRepository();
            final refuelingsBloc = MockRefuelingsBloc();
            when(dataRepository.getCurrentCars())
                .thenAnswer((_) async => [Car()]);
            whenListen(
                refuelingsBloc,
                Stream<RefuelingsState>.fromIterable([
                  RefuelingsLoaded([refueling])
                ]));
            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
            return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
          },
          act: (bloc) async => bloc.add(LoadCars()),
          expect: [
            CarsLoading(),
            CarsLoaded([Car()]),
          ]);
      blocTest<CarsBloc, CarsEvent, CarsState>('Exception',
          build: () {
            final dataRepository = MockDataRepository();
            final refuelingsBloc = MockRefuelingsBloc();
            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
            return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
          },
          act: (bloc) async => bloc.add(LoadCars()),
          expect: [CarsLoading(), CarsNotLoaded()]);
    });
    group('AddCar', () {
      blocTest<CarsBloc, CarsEvent, CarsState>('Proper behavior', build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.getCurrentCars()).thenAnswer((_) async => [Car()]);
        final refuelingsBloc = MockRefuelingsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      }, act: (bloc) async {
        bloc.add(LoadCars());
        bloc.add(AddCar(Car()));
      }, expect: [
        CarsLoading(),
        CarsLoaded([Car()]),
        CarsLoaded([Car(), Car()])
      ]);
    });
    group('UpdateCar', () {
      blocTest<CarsBloc, CarsEvent, CarsState>('Proper behavior', build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.getCurrentCars())
            .thenAnswer((_) async => [Car(id: '0', name: 'abcd')]);
        final refuelingsBloc = MockRefuelingsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      }, act: (bloc) async {
        bloc.add(LoadCars());
        bloc.add(UpdateCar(Car(id: '0', name: 'dcba')));
      }, expect: [
        CarsLoading(),
        CarsLoaded([Car(id: '0', name: 'abcd')]),
        CarsLoaded([Car(id: '0', name: 'dcba')])
      ]);
    });
    group('DeleteCar', () {
      blocTest<CarsBloc, CarsEvent, CarsState>('Proper behavior', build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.getCurrentCars())
            .thenAnswer((_) async => [Car(id: '0', name: 'abcd')]);
        final refuelingsBloc = MockRefuelingsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      }, act: (bloc) async {
        bloc.add(LoadCars());
        bloc.add(DeleteCar(Car(id: '0', name: 'dcba')));
      }, expect: [
        CarsLoading(),
        CarsLoaded([Car(id: '0', name: 'abcd')]),
        CarsLoaded([])
      ]);
    });
    group('ExternalRefuelingsUpdated', () {
      final refueling = Refueling(
        id: '0',
        carName: 'abcd',
        amount: 10.0,
        cost: 10.0,
        mileage: 11000,
        date: DateTime.fromMillisecondsSinceEpoch(0),
      );
      blocTest<CarsBloc, CarsEvent, CarsState>('First New Refueling',
          build: () {
        final dataRepository = MockDataRepository();
        final writeBatch = MockWriteBatch();
        when(dataRepository.getCurrentCars()).thenAnswer(
            (_) async => [Car(id: '0', name: 'abcd', mileage: 10000)]);
        when(dataRepository.startCarWriteBatch()).thenAnswer((_) => writeBatch);
        final refuelingsBloc = MockRefuelingsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      }, act: (bloc) async {
        bloc.add(LoadCars());
        bloc.add(ExternalRefuelingsUpdated([refueling]));
      }, expect: [
        CarsLoading(),
        CarsLoaded([
          Car(
              id: '0',
              name: 'abcd',
              mileage: 10000,
              distanceRateHistory: <DistanceRatePoint>[])
        ]),
        CarsLoaded([
          Car(
              id: '0',
              name: 'abcd',
              mileage: 11000,
              numRefuelings: 1,
              distanceRate: 0.0,
              lastMileageUpdate:
                  roundToDay(DateTime.fromMillisecondsSinceEpoch(0)),
              distanceRateHistory: <DistanceRatePoint>[])
        ])
      ]);
      blocTest<CarsBloc, CarsEvent, CarsState>('Second New Refueling',
          build: () {
        final dataRepository = MockDataRepository();
        final writeBatch = MockWriteBatch();
        when(dataRepository.getCurrentCars()).thenAnswer((_) async =>
            [Car(id: '0', name: 'abcd', mileage: 10000, numRefuelings: 1)]);
        when(dataRepository.startCarWriteBatch()).thenAnswer((_) => writeBatch);
        final refuelingsBloc = MockRefuelingsBloc();
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return CarsBloc(dbBloc: dbBloc, refuelingsBloc: refuelingsBloc);
      }, act: (bloc) async {
        bloc.add(LoadCars());
        bloc.add(ExternalRefuelingsUpdated(
            [refueling, refueling.copyWith(efficiency: 1.0, mileage: 12000)]));
      }, expect: [
        CarsLoading(),
        CarsLoaded([
          Car(
              id: '0',
              name: 'abcd',
              mileage: 10000,
              numRefuelings: 1,
              distanceRateHistory: <DistanceRatePoint>[])
        ]),
        CarsLoaded([
          Car(
              id: '0',
              name: 'abcd',
              mileage: 12000,
              numRefuelings: 2,
              averageEfficiency: 0.5,
              distanceRate: 0.0,
              lastMileageUpdate:
                  roundToDay(DateTime.fromMillisecondsSinceEpoch(0)),
              distanceRateHistory: [
                DistanceRatePoint(
                    DateTime.fromMillisecondsSinceEpoch(0), double.infinity)
              ])
        ])
      ]);
      blocTest(
        'Subscription',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.cars())
              .thenAnswer((_) => Stream<List<Car>>.fromIterable([
                    [Car()]
                  ]));
          when(dataRepository.getCurrentCars())
              .thenAnswer((_) async => [Car()]);
          final dbBloc = MockDbBloc();
          whenListen(dbBloc, Stream.fromIterable([DbLoaded(dataRepository)]));
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return CarsBloc(dbBloc: dbBloc, refuelingsBloc: MockRefuelingsBloc());
        },
        expect: [
          CarsLoading(),
          CarsLoaded([Car()]),
        ],
      );
    });
  });
}
