import 'dart:async';

import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/repositories/data_repository.dart';
import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';

class MockDataRepository extends Mock implements DataRepository {}
class MockRefuelingsBloc extends Mock implements RefuelingsBloc {}
class MockWriteBatch extends Mock implements WriteBatchWrapper {}

void main() {
  group('CarsBloc', () {
    test('Null Data Repository', () {
      final refuelingsBloc = MockRefuelingsBloc();
      expect(
        () => CarsBloc(dataRepository: null, refuelingsBloc: refuelingsBloc),
        throwsAssertionError
      );
    });
    test('Null Refuelings Bloc', () {
      final dataRepository = MockDataRepository();
      expect(
        () => CarsBloc(dataRepository: dataRepository, refuelingsBloc: null),
        throwsAssertionError
      );
    });
    group('LoadCars', () {
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'CarsLoaded',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([[Car()]]));
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async => bloc.add(LoadCars()),
        expect: [
          CarsLoading(),
          CarsLoaded([Car()])
        ]
      );
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'Cars is null',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([null]));
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async => bloc.add(LoadCars()),
        expect: [
          CarsLoading(),
          CarsNotLoaded()
        ]
      );
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'Event from Refuelings',
        build: () {
          final dataRepository = MockDataRepository();
          final refuelingsBloc = MockRefuelingsBloc();
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([[Car()]]));
          whenListen(refuelingsBloc, 
            Stream<RefuelingsState>.fromIterable([
              RefuelingsLoaded([Refueling()])
            ])
          );
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async => bloc.add(LoadCars()),
        expect: [
          CarsLoading(),
          CarsLoaded([Car()]),
        ]
      );
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'Exception',
        build: () {
          final dataRepository = MockDataRepository();
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async => bloc.add(LoadCars()),
        expect: [
          CarsLoading(),
          CarsNotLoaded()
        ]
      );
    });
    group('AddCar', () {
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'Proper behavior',
        build: () {
          final dataRepository = MockDataRepository();  
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([[Car()]]));
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async {
          bloc.add(LoadCars());
          bloc.add(AddCar(Car()));
        },
        expect: [
          CarsLoading(),
          CarsLoaded([Car()]),
          CarsLoaded([Car(), Car()])
        ]
      );
    });
    group('UpdateCar', () {
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'Proper behavior',
        build: () {
          final dataRepository = MockDataRepository();  
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([[Car(id: '0', name: 'abcd')]]));
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async {
          bloc.add(LoadCars());
          bloc.add(UpdateCar(Car(id: '0', name: 'dcba')));
        },
        expect: [
          CarsLoading(),
          CarsLoaded([Car(id: '0', name: 'abcd')]),
          CarsLoaded([Car(id: '0', name: 'dcba')])
        ]
      );
    });
    group('DeleteCar', () {
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'Proper behavior',
        build: () {
          final dataRepository = MockDataRepository();  
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([[Car(id: '0', name: 'abcd')]]));
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async {
          bloc.add(LoadCars());
          bloc.add(DeleteCar(Car(id: '0', name: 'dcba')));
        },
        expect: [
          CarsLoading(),
          CarsLoaded([Car(id: '0', name: 'abcd')]),
          CarsLoaded([])
        ]
      );
    });
    group('ExternalRefuelingsUpdated', () {
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'First New Refueling',
        build: () {
          final dataRepository = MockDataRepository();  
          final writeBatch = MockWriteBatch();
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([[Car(id: '0', name: 'abcd', mileage: 10000)]]));
          when(dataRepository.startCarWriteBatch())
            .thenAnswer((_) => writeBatch);
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async {
          bloc.add(LoadCars());
          bloc.add(ExternalRefuelingsUpdated([Refueling(carName: 'abcd', mileage: 11000, date: DateTime.fromMillisecondsSinceEpoch(0))]));
        },
        expect: [
          CarsLoading(),
          CarsLoaded([Car(id: '0', name: 'abcd', mileage: 10000,
            distanceRateHistory: [
              DistanceRatePoint(roundToDay(DateTime.fromMillisecondsSinceEpoch(0)), double.infinity)]
          )]),
          CarsLoaded([Car(
            id: '0', 
            name: 'abcd', 
            mileage: 11000, 
            numRefuelings: 1, 
            distanceRate: double.infinity, 
            lastMileageUpdate: roundToDay(DateTime.fromMillisecondsSinceEpoch(0)),
            distanceRateHistory: [
              DistanceRatePoint(roundToDay(DateTime.fromMillisecondsSinceEpoch(0)), double.infinity)]
          )])
        ]
      );
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'Second New Refueling',
        build: () {
          final dataRepository = MockDataRepository();  
          final writeBatch = MockWriteBatch();
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([[Car(id: '0', name: 'abcd', mileage: 10000, numRefuelings: 1)]]));
          when(dataRepository.startCarWriteBatch())
            .thenAnswer((_) => writeBatch);
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async {
          bloc.add(LoadCars());
          bloc.add(ExternalRefuelingsUpdated([Refueling(carName: 'abcd', mileage: 11000, date: DateTime.fromMillisecondsSinceEpoch(0), efficiency: 1.0)]));
        },
        expect: [
          CarsLoading(),
          CarsLoaded([Car(id: '0', name: 'abcd', mileage: 10000, numRefuelings: 1,
            distanceRateHistory: [
              DistanceRatePoint(roundToDay(DateTime.fromMillisecondsSinceEpoch(0)), double.infinity)]
          )]),
          CarsLoaded([Car(
            id: '0', 
            name: 'abcd', 
            mileage: 11000, 
            numRefuelings: 2, 
            averageEfficiency: 0.5,
            distanceRate: double.infinity, 
            lastMileageUpdate: roundToDay(DateTime.fromMillisecondsSinceEpoch(0)),
            distanceRateHistory: [
              DistanceRatePoint(roundToDay(DateTime.fromMillisecondsSinceEpoch(0)), double.infinity)]
          )])
        ]
      );
      blocTest<CarsBloc, CarsEvent, CarsState>(
        'Efficiency EMA',
        build: () {
          final dataRepository = MockDataRepository();  
          final writeBatch = MockWriteBatch();
          when(dataRepository.cars())
            .thenAnswer((_) => Stream<List<Car>>.fromIterable([[Car(id: '0', name: 'abcd', mileage: 10000, numRefuelings: 8)]]));
          when(dataRepository.startCarWriteBatch())
            .thenAnswer((_) => writeBatch);
          final refuelingsBloc = MockRefuelingsBloc();
          return CarsBloc(
            dataRepository: dataRepository,
            refuelingsBloc: refuelingsBloc
          );
        },
        act: (bloc) async {
          bloc.add(LoadCars());
          bloc.add(ExternalRefuelingsUpdated([Refueling(carName: 'abcd', mileage: 11000, date: DateTime.fromMillisecondsSinceEpoch(0), efficiency: 1.0)]));
        },
        expect: [
          CarsLoading(),
          CarsLoaded([Car(id: '0', name: 'abcd', mileage: 10000, numRefuelings: 8,
            distanceRateHistory: [
              DistanceRatePoint(roundToDay(DateTime.fromMillisecondsSinceEpoch(0)), double.infinity)]
          )]),
          CarsLoaded([Car(
            id: '0', 
            name: 'abcd', 
            mileage: 11000, 
            numRefuelings: 9, 
            averageEfficiency: 0.1,
            distanceRate: double.infinity, 
            lastMileageUpdate: roundToDay(DateTime.fromMillisecondsSinceEpoch(0)),
            distanceRateHistory: [
              DistanceRatePoint(roundToDay(DateTime.fromMillisecondsSinceEpoch(0)), double.infinity)]
          )])
        ]
      );
    });
  });
}