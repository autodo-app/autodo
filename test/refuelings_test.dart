import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:autodo/blocs/refuelings/barrel.dart';
import 'package:autodo/blocs/cars/barrel.dart';
import 'package:autodo/repositories/barrel.dart';

class MockDataRepository extends Mock implements FirebaseDataRepository {}
class MockCarsBloc extends Mock implements CarsBloc {}

void main() {
  group('RefuelingsBloc', () {
    DataRepository dataRepository;
    CarsBloc carsBloc;
    RefuelingsBloc refuelingsBloc;

    setUp(() {
      dataRepository = MockDataRepository();
      carsBloc = MockCarsBloc();
      refuelingsBloc = RefuelingsBloc(
        dataRepository: dataRepository,
        carsBloc: carsBloc
      );
    });

    test('throws AssertionError if inputs is null', () {
      expect(
        () => RefuelingsBloc(dataRepository: null, carsBloc: null),
        throwsA(isAssertionError),
      );
    });

    // Create a group for each event
    group('LoadRefuelings', () {
      blocTest(
        'emits [WeatherInitial, WeatherLoadInProgress, WeatherLoadSuccess] when WeatherRequested is added and getWeather succeeds',
        build: () {
          when(weatherRepository.getWeather(city: 'Chicago')).thenAnswer(
            (_) => Future.value(
              Weather(
                temperature: 10,
                condition: Condition.cloudy,
              ),
            ),
          );
          return weatherBloc;
        },
        act: (bloc) => bloc.add(WeatherRequested(city: 'Chicago')),
        expect: [
          WeatherInitial(),
          WeatherLoadInProgress(),
          WeatherLoadSuccess(
            weather: Weather(
              temperature: 10,
              condition: Condition.cloudy,
            ),
          )
        ],
      );

      blocTest(
        'emits [WeatherInitial, WeatherLoadInProgress, WeatherLoadFailure] when WeatherRequested is added and getWeather fails',
        build: () {
          when(weatherRepository.getWeather(city: 'Chicago')).thenThrow('oops');
          return weatherBloc;
        },
        act: (bloc) => bloc.add(WeatherRequested(city: 'Chicago')),
        expect: [
          WeatherInitial(),
          WeatherLoadInProgress(),
          WeatherLoadFailure(),
        ],
      );
    });
  });
}