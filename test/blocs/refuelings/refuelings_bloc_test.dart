import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';

class MockDataRepository extends Mock with EquatableMixin implements DataRepository {}
class MockCarsBloc extends Mock implements CarsBloc {}
class MockWriteBatch extends Mock implements WriteBatchWrapper {}

void main() {
  group('RefuelingsBloc', () {
    test('Null Data Repository', () {
      final carsBloc = MockCarsBloc();
      expect(() => RefuelingsBloc(carsBloc: carsBloc, dataRepository: null), throwsAssertionError);
    });
    test('Null Cars Bloc', () {
      final dataRepository = MockDataRepository();
      expect(() => RefuelingsBloc(dataRepository: dataRepository, carsBloc: null), throwsAssertionError);
    });
    group('LoadRefuelings', () {
      blocTest('Loaded', 
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(carsBloc, Stream.fromIterable([[Car()]]));
          final dataRepository = MockDataRepository();
          when(dataRepository.refuelings()).thenAnswer((_) => Stream<List<Refueling>>.fromIterable([[Refueling()]]));
          return RefuelingsBloc(dataRepository: dataRepository, carsBloc: carsBloc);
        },
        act: (bloc) async => bloc.add(LoadRefuelings()),
        expect: [ 
          RefuelingsLoading(),
          RefuelingsLoaded([Refueling()]),
        ],
      );
      blocTest('NotLoaded', 
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(carsBloc, Stream.fromIterable([[Car()]]));
          final dataRepository = MockDataRepository();
          when(dataRepository.refuelings()).thenAnswer((_) => Stream<List<Refueling>>.fromIterable([null]));
          return RefuelingsBloc(dataRepository: dataRepository, carsBloc: carsBloc);
        },
        act: (bloc) async => bloc.add(LoadRefuelings()),
        expect: [ 
          RefuelingsLoading(),
          RefuelingsNotLoaded(),
        ],
      );
      blocTest('Caught Exception', 
        build: () {
          final carsBloc = MockCarsBloc();
          whenListen(carsBloc, Stream.fromIterable([[Car()]]));
          final dataRepository = MockDataRepository();
          when(dataRepository.refuelings()).thenThrow(Exception());
          return RefuelingsBloc(dataRepository: dataRepository, carsBloc: carsBloc);
        },
        act: (bloc) async => bloc.add(LoadRefuelings()),
        expect: [ 
          RefuelingsLoading(),
          RefuelingsNotLoaded(),
        ],
      );
    });
    final refueling1 = Refueling(id: '0', mileage: 0, amount: 10);
    final refueling2 = Refueling(id: '0', mileage: 1000, amount: 10, efficiency: 100);
    blocTest('AddRefueling', 
      build: () {
        final carsBloc = MockCarsBloc();
        final writeBatch = MockWriteBatch();
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car(name: 'test')])]));
        final dataRepository = MockDataRepository();
        
        when(dataRepository.refuelings())
          .thenAnswer((_) => 
            Stream<List<Refueling>>.fromIterable(
              [[refueling1]]
          ));
        when(dataRepository.startRefuelingWriteBatch())
          .thenAnswer((_) => writeBatch);
        return RefuelingsBloc(dataRepository: dataRepository, carsBloc: carsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadRefuelings());
        bloc.add(AddRefueling(refueling2));
      },
      expect: [ 
        RefuelingsLoading(),
        RefuelingsLoaded([refueling1]),
        RefuelingsLoaded([refueling1, refueling2]),
      ],
    );
    blocTest('UpdateRefueling', 
      build: () {
        final carsBloc = MockCarsBloc();
        final writeBatch = MockWriteBatch();
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car(name: 'test')])]));
        final dataRepository = MockDataRepository();
        
        when(dataRepository.refuelings())
          .thenAnswer((_) => 
            Stream<List<Refueling>>.fromIterable(
              [[refueling1]]
          ));
        when(dataRepository.startRefuelingWriteBatch())
          .thenAnswer((_) => writeBatch);
        return RefuelingsBloc(dataRepository: dataRepository, carsBloc: carsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadRefuelings());
        bloc.add(UpdateRefueling(refueling1.copyWith(mileage: 1000)));
      },
      expect: [ 
        RefuelingsLoading(),
        RefuelingsLoaded([refueling1]),
        RefuelingsLoaded([refueling1.copyWith(mileage: 1000, efficiency: 100)]),
      ],
    );
    blocTest('DeleteRefueling', 
      build: () {
        final carsBloc = MockCarsBloc();
        final writeBatch = MockWriteBatch();
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car(name: 'test')])]));
        final dataRepository = MockDataRepository();
        
        when(dataRepository.refuelings())
          .thenAnswer((_) => 
            Stream<List<Refueling>>.fromIterable(
              [[refueling1]]
          ));
        when(dataRepository.startRefuelingWriteBatch())
          .thenAnswer((_) => writeBatch);
        return RefuelingsBloc(dataRepository: dataRepository, carsBloc: carsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadRefuelings());
        bloc.add(DeleteRefueling(refueling1));
      },
      expect: [ 
        RefuelingsLoading(),
        RefuelingsLoaded([refueling1]),
        RefuelingsLoaded([]),
      ],
    );
    blocTest('CarsUpdated', 
      build: () {
        final carsBloc = MockCarsBloc();
        final writeBatch = MockWriteBatch();
        whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car(name: 'test')])]));
        final dataRepository = MockDataRepository();
        when(dataRepository.refuelings())
          .thenAnswer((_) => 
            Stream<List<Refueling>>.fromIterable(
              [[Refueling(carName: 'test', efficiency: 1.0, id: '0')]]
          ));
        when(dataRepository.startRefuelingWriteBatch())
          .thenAnswer((_) => writeBatch);
        return RefuelingsBloc(dataRepository: dataRepository, carsBloc: carsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadRefuelings());
        bloc.add(ExternalCarsUpdated([Car(name: 'test', averageEfficiency: 1.0)]));
      },
      expect: [ 
        RefuelingsLoading(),
        RefuelingsLoaded([Refueling(carName: 'test', efficiency: 1.0, id: '0')]),
        RefuelingsLoaded([Refueling(carName: 'test', efficiency: 1.0, id: '0', efficiencyColor: Color(0xffff0000))]),
      ],
    );
  });
}