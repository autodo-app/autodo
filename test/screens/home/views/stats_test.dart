import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/screens/home/views/stats.dart';
import 'package:autodo/screens/home/views/charts/barrel.dart';

class MockEfficiencyStatsBloc
    extends MockBloc<EfficiencyStatsEvent, EfficiencyStatsState>
    implements EfficiencyStatsBloc {}

class MockDrivingDistanceStatsBloc
    extends MockBloc<DrivingDistanceStatsEvent, DrivingDistanceStatsState>
    implements DrivingDistanceStatsBloc {}

void main() {
  EfficiencyStatsBloc effBloc;
  DrivingDistanceStatsBloc driveBloc;

  setUp(() {
    effBloc = MockEfficiencyStatsBloc();
    driveBloc = MockDrivingDistanceStatsBloc();
  });

  group('RefuelingsScreen', () {
    testWidgets('loading', (WidgetTester tester) async {
      when(effBloc.state).thenAnswer((_) => EfficiencyStatsLoading());
      when(driveBloc.state).thenAnswer((_) => DrivingDistanceStatsLoading());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<EfficiencyStatsBloc>.value(
              value: effBloc,
            ),
            BlocProvider<DrivingDistanceStatsBloc>.value(
              value: driveBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: StatisticsScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(LoadingIndicator), findsNWidgets(2));
    });
    testWidgets('no data', (WidgetTester tester) async {
      when(effBloc.state).thenAnswer((_) => EfficiencyStatsLoaded([]));
      when(driveBloc.state).thenAnswer((_) => DrivingDistanceStatsLoaded([]));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<EfficiencyStatsBloc>.value(
              value: effBloc,
            ),
            BlocProvider<DrivingDistanceStatsBloc>.value(
              value: driveBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: StatisticsScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FuelMileageHistory), findsOneWidget);
      expect(find.byType(DrivingDistanceHistory), findsOneWidget);
    });
    testWidgets('loaded', (WidgetTester tester) async {
      final refueling = Refueling(
          id: '0',
          mileage: 0,
          amount: 10,
          cost: 10.0,
          efficiency: 1.0,
          date: DateTime.fromMillisecondsSinceEpoch(0),
          carName: 'test');
      final effData = [
        Series<FuelMileagePoint, DateTime>(
          id: 'Fuel Mileage vs Time',
          domainFn: (point, _) => point.date,
          measureFn: (point, _) => point.efficiency,
          data: [
            FuelMileagePoint(refueling.date, refueling.efficiency),
            FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(100), 2.0)
          ],
        ),
        Series<FuelMileagePoint, DateTime>(
          id: 'EMA',
          domainFn: (point, _) => point.date,
          measureFn: (point, _) => point.efficiency,
          data: [
            FuelMileagePoint(refueling.date, refueling.efficiency),
            FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(100),
                EfficiencyStatsBloc.emaFilter(1.0, 2.0))
          ],
        )
      ];
      final car = Car(name: 'abcd', distanceRateHistory: [
        DistanceRatePoint(DateTime.fromMillisecondsSinceEpoch(0), 1.0),
        DistanceRatePoint(DateTime.fromMillisecondsSinceEpoch(1000), 2.0),
      ]);
      final driveData = [
        Series<DistanceRatePoint, DateTime>(
          id: car.name,
          domainFn: (point, _) => point.date,
          measureFn: (point, _) => point.distanceRate,
          data: car.distanceRateHistory,
        )
      ];
      when(effBloc.state).thenAnswer((_) => EfficiencyStatsLoaded(effData));
      when(driveBloc.state)
          .thenAnswer((_) => DrivingDistanceStatsLoaded(driveData));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<EfficiencyStatsBloc>.value(
              value: effBloc,
            ),
            BlocProvider<DrivingDistanceStatsBloc>.value(
              value: driveBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: StatisticsScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FuelMileageHistory), findsOneWidget);
      expect(find.byType(DrivingDistanceHistory), findsOneWidget);
    });
  });
}
