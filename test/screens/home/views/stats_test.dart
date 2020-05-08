import 'dart:math';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/home/views/charts/barrel.dart';
import 'package:autodo/screens/home/views/stats.dart';
import 'package:autodo/units/units.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState>
    implements RefuelingsBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

void main() {
  BasePrefService pref;

  setUp(() async {
    pref = JustCachePrefService();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'efficiency_unit': EfficiencyUnit.mpusg.index,
      'currency': 'USD',
    });
  });

  group('StatsScreen', () {
    testWidgets('no data', (WidgetTester tester) async {
      final carsBloc = MockCarsBloc();
      final refuelingsBloc = MockRefuelingsBloc();

      when(carsBloc.state).thenAnswer((_) => CarsLoaded());
      when(refuelingsBloc.state).thenAnswer((_) => RefuelingsLoaded());

      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
              BlocProvider<RefuelingsBloc>.value(
                value: refuelingsBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: StatisticsScreen(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FuelMileageHistory), findsOneWidget);
      expect(find.byType(DrivingDistanceChart), findsOneWidget);
    });

    testWidgets('loaded', (WidgetTester tester) async {
      final rnd = Random(1234);
      final carsBloc = MockCarsBloc();
      final refuelingsBloc = MockRefuelingsBloc();

      final refuelings = List<Refueling>.generate(
          100,
          (int index) => Refueling(
              id: '$index',
              mileage: index * 200.0,
              amount: rnd.nextDouble() * 30 + 10,
              cost: rnd.nextDouble() * 30 + 10,
              efficiency: 1.0,
              date: DateTime.fromMillisecondsSinceEpoch(
                  1546300800000 + index * 864000000),
              carName: 'test'));

      final car = Car(
          name: 'test',
          distanceRateHistory: List<DistanceRatePoint>.generate(
              100,
              (int index) => DistanceRatePoint(
                  DateTime.fromMillisecondsSinceEpoch(
                      1546300800000 + index * 864000000),
                  index / 20.0)));

      when(carsBloc.state).thenAnswer((_) => CarsLoaded([car]));
      whenListen(
          refuelingsBloc,
          Stream.fromIterable([
            RefuelingsLoading(),
            RefuelingsLoaded(refuelings),
          ]));
      when(refuelingsBloc.state)
          .thenAnswer((_) => RefuelingsLoaded(refuelings));

      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
              BlocProvider<RefuelingsBloc>.value(
                value: refuelingsBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: StatisticsScreen(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FuelMileageHistory), findsOneWidget);
      expect(find.byType(DrivingDistanceChart), findsOneWidget);
    });
  });
}
