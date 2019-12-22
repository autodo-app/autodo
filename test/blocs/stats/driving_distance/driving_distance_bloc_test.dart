import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockCarsBloc extends Mock implements CarsBloc {}

void main() {
  group('DrivingDistanceStatsBloc', () {
    test('Null Assertion', () {
      expect(() => DrivingDistanceStatsBloc(carsBloc: null), throwsAssertionError);
    });
    final car = Car(
      name: 'abcd',
      distanceRateHistory: [
      DistanceRatePoint(DateTime.fromMillisecondsSinceEpoch(0), 1.0),
      DistanceRatePoint(DateTime.fromMillisecondsSinceEpoch(1000), 2.0),
    ]);
    blocTest('LoadDrivingDistanceStats',
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([CarsLoaded([car])]));
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([car]));
        return DrivingDistanceStatsBloc(carsBloc: carsBloc);
      },
      act: (bloc) async => bloc.add(LoadDrivingDistanceStats()),
      expect: [
        DrivingDistanceStatsLoading(),
        DrivingDistanceStatsLoaded([
          Series<DistanceRatePoint, DateTime>(
            id: car.name, 
            domainFn: (point, _) => point.date,
            measureFn: (point, _) => point.distanceRate,
            data: car.distanceRateHistory,
          )
        ])
      ],
    );
    blocTest('UpdateDrivingDistanceData', 
      build: () {
        final carsBloc = MockCarsBloc();
        whenListen(carsBloc, Stream.fromIterable([CarsLoaded([car])]));
        when(carsBloc.state).thenAnswer((_) => CarsLoaded([car]));
        return DrivingDistanceStatsBloc(carsBloc: carsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadDrivingDistanceStats());
        bloc.add(UpdateDrivingDistanceData([car, car.copyWith(name: 'test')]));
      },
      expect: [
        DrivingDistanceStatsLoading(),
        DrivingDistanceStatsLoaded([
          Series<DistanceRatePoint, DateTime>(
            id: car.name, 
            domainFn: (point, _) => point.date,
            measureFn: (point, _) => point.distanceRate,
            data: car.distanceRateHistory,
          )
        ]),
        DrivingDistanceStatsLoaded([
          Series<DistanceRatePoint, DateTime>(
            id: car.name, 
            domainFn: (point, _) => point.date,
            measureFn: (point, _) => point.distanceRate,
            data: car.distanceRateHistory,
          ),
          Series<DistanceRatePoint, DateTime>(
            id: 'test', 
            domainFn: (point, _) => point.date,
            measureFn: (point, _) => point.distanceRate,
            data: car.distanceRateHistory,
          )
        ])
      ]
    );
  });
}