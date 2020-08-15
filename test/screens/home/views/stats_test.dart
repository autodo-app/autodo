import 'dart:math';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/home/views/charts/barrel.dart';
import 'package:autodo/screens/home/views/stats.dart';
import 'package:autodo/units/units.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

void main() {
  BasePrefService pref;

  setUp(() async {
    pref = PrefServiceCache();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'efficiency_unit': EfficiencyUnit.mpusg.index,
      'currency': 'USD',
    });
  });

  group('StatsScreen', () {
    testWidgets('no data', (WidgetTester tester) async {
      final dataBloc = MockDataBloc();
      when(dataBloc.state).thenReturn(DataLoaded());

      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DataBloc>.value(value: dataBloc),
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
      final dataBloc = MockDataBloc();
      when(dataBloc.state).thenReturn(DataLoaded());

      final refuelings = List<Refueling>.generate(
          100,
          (int index) => Refueling(
                id: '$index',
                odomSnapshot: OdomSnapshot(
                    mileage: index * 200.0,
                    date: DateTime.fromMillisecondsSinceEpoch(
                        1546300800000 + index * 864000000),
                    car: 'test'),
                amount: rnd.nextDouble() * 30 + 10,
                cost: rnd.nextDouble() * 30 + 10,
                efficiency: 1.0,
              ));

      final car = Car(
          name: 'test',
          odomSnapshot: OdomSnapshot(
              date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0),
          distanceRateHistory: List<DistanceRatePoint>.generate(
              100,
              (int index) => DistanceRatePoint(
                  DateTime.fromMillisecondsSinceEpoch(
                      1546300800000 + index * 864000000),
                  index / 20.0)));

      when(dataBloc.state)
          .thenAnswer((_) => DataLoaded(cars: [car], refuelings: refuelings));

      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DataBloc>.value(value: dataBloc),
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
