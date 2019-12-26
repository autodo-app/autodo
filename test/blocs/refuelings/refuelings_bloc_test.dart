import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:equatable/equatable.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';

class MockDataRepository extends Mock with EquatableMixin implements DataRepository {}
class MockWriteBatch extends Mock implements WriteBatchWrapper {}
class MockDbBloc extends Mock implements DatabaseBloc {}

void main() {
  group('RefuelingsBloc', () {
    test('Null Data Repository', () {
      expect(() => RefuelingsBloc(dbBloc: null), throwsAssertionError);
    });
    group('LoadRefuelings', () {
      final refueling = Refueling(
        id: '0',
        carName: 'abcd',
        amount: 10.0,
        cost: 10.0,
        mileage: 11000,
        date: DateTime.fromMillisecondsSinceEpoch(0),
      );
      blocTest('Loaded', 
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.refuelings()).thenAnswer((_) => Stream<List<Refueling>>.fromIterable([[refueling]]));
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return RefuelingsBloc(dbBloc: dbBloc);
        },
        act: (bloc) async => bloc.add(LoadRefuelings()),
        expect: [ 
          RefuelingsLoading(),
          RefuelingsLoaded([refueling]),
        ],
      );
      blocTest('NotLoaded', 
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.refuelings()).thenAnswer((_) => Stream<List<Refueling>>.fromIterable([null]));
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return RefuelingsBloc(dbBloc: dbBloc);
        },
        act: (bloc) async => bloc.add(LoadRefuelings()),
        expect: [ 
          RefuelingsLoading(),
          RefuelingsNotLoaded(),
        ],
      );
      blocTest('Caught Exception', 
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.refuelings()).thenThrow(Exception());
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return RefuelingsBloc(dbBloc: dbBloc);
        },
        act: (bloc) async => bloc.add(LoadRefuelings()),
        expect: [ 
          RefuelingsLoading(),
          RefuelingsNotLoaded(),
        ],
      );
    });
    final refueling1 = Refueling(
      id: '0', 
      mileage: 0, 
      amount: 10,
      cost: 10.0,
      date: DateTime.fromMillisecondsSinceEpoch(0),
      carName: 'test'
    );
    final refueling2 = Refueling(
      id: '0', 
      mileage: 1000, 
      amount: 10,
      efficiency: 100,
      cost: 10.0,
      date: DateTime.fromMillisecondsSinceEpoch(0),
      carName: 'test'
    );
    blocTest('AddRefueling', 
      build: () {
        final writeBatch = MockWriteBatch();
        final dataRepository = MockDataRepository();
        
        when(dataRepository.refuelings())
          .thenAnswer((_) => 
            Stream<List<Refueling>>.fromIterable(
              [[refueling1]]
          ));
        when(dataRepository.startRefuelingWriteBatch())
          .thenAnswer((_) => writeBatch);
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return RefuelingsBloc(dbBloc: dbBloc);
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
        final writeBatch = MockWriteBatch();
        final dataRepository = MockDataRepository();
        when(dataRepository.refuelings())
          .thenAnswer((_) => 
            Stream<List<Refueling>>.fromIterable(
              [[refueling1]]
          ));
        when(dataRepository.startRefuelingWriteBatch())
          .thenAnswer((_) => writeBatch);
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return RefuelingsBloc(dbBloc: dbBloc);
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
        final writeBatch = MockWriteBatch();
        final dataRepository = MockDataRepository();
        when(dataRepository.refuelings())
          .thenAnswer((_) => 
            Stream<List<Refueling>>.fromIterable(
              [[refueling1]]
          ));
        when(dataRepository.startRefuelingWriteBatch())
          .thenAnswer((_) => writeBatch);
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return RefuelingsBloc(dbBloc: dbBloc);
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
    // final refueling3 = Refueling(
    //   id: '0', 
    //   mileage: 0, 
    //   amount: 10,
    //   cost: 10.0,
    //   efficiency: 1.0,
    //   date: DateTime.fromMillisecondsSinceEpoch(0),
    //   carName: 'test'
    // );
    // blocTest('CarsUpdated', 
    //   build: () {
    //     final carsBloc = MockCarsBloc();
    //     final writeBatch = MockWriteBatch();
    //     whenListen(carsBloc, Stream<CarsState>.fromIterable([CarsLoaded([Car(name: 'test')])]));
    //     final dataRepository = MockDataRepository();
    //     when(dataRepository.refuelings())
    //       .thenAnswer((_) => 
    //         Stream<List<Refueling>>.fromIterable(
    //           [[refueling3]]
    //       ));
    //     when(dataRepository.startRefuelingWriteBatch())
    //       .thenAnswer((_) => writeBatch);
    //     final dbBloc = MockDbBloc();
    //     when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
    //     return RefuelingsBloc(dbBloc: dbBloc);
    //   },
    //   act: (bloc) async {
    //     bloc.add(LoadRefuelings());
    //     bloc.add(ExternalCarsUpdated([Car(name: 'test', averageEfficiency: 1.0)]));
    //   },
    //   expect: [ 
    //     RefuelingsLoading(),
    //     RefuelingsLoaded([refueling3]),
    //     RefuelingsLoaded([refueling3.copyWith(efficiencyColor: Color(0xffff0000))]),
    //   ],
    // );
  });
}