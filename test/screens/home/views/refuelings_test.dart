import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/home/views/refuelings.dart';
import 'package:autodo/screens/home/widgets/refueling_card.dart';
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

class MockFilteredRefuelingsBloc
    extends MockBloc<FilteredRefuelingsLoaded, FilteredRefuelingsState>
    implements FilteredRefuelingsBloc {}

void main() {
  RefuelingsBloc refuelingsBloc;
  FilteredRefuelingsBloc filteredRefuelingsBloc;
  BasePrefService pref;

  setUp(() async {
    refuelingsBloc = MockRefuelingsBloc();
    filteredRefuelingsBloc = MockFilteredRefuelingsBloc();
    pref = JustCachePrefService();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('RefuelingsScreen', () {
    testWidgets('loading', (WidgetTester tester) async {
      when(filteredRefuelingsBloc.state)
          .thenAnswer((_) => FilteredRefuelingsLoading());
      final refuelingsKey = Key('refuelings');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RefuelingsBloc>.value(
                value: refuelingsBloc,
              ),
              BlocProvider<FilteredRefuelingsBloc>.value(
                value: filteredRefuelingsBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RefuelingsScreen(key: refuelingsKey),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });
    testWidgets('not loaded', (WidgetTester tester) async {
      when(filteredRefuelingsBloc.state)
          .thenAnswer((_) => FilteredRefuelingsNotLoaded());
      final refuelingsKey = Key('refuelings');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<RefuelingsBloc>.value(
              value: refuelingsBloc,
            ),
            BlocProvider<FilteredRefuelingsBloc>.value(
              value: filteredRefuelingsBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: RefuelingsScreen(key: refuelingsKey),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(refuelingsKey), findsOneWidget);
    });
    testWidgets('tap', (WidgetTester tester) async {
      final refueling = Refueling(
        carName: 'test',
        amount: 10.0,
        cost: 10.0,
        mileage: 1000,
        date: DateTime.fromMillisecondsSinceEpoch(0),
      );
      when(filteredRefuelingsBloc.state).thenAnswer((_) =>
          FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [Car()]));
      final refuelingsKey = Key('refuelings');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RefuelingsBloc>.value(
                value: refuelingsBloc,
              ),
              BlocProvider<FilteredRefuelingsBloc>.value(
                value: filteredRefuelingsBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RefuelingsScreen(key: refuelingsKey),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RefuelingCard));
      await tester.pump();
      expect(find.byKey(refuelingsKey), findsOneWidget);
    });
    testWidgets('dismiss', (WidgetTester tester) async {
      final refueling = Refueling(
        carName: 'test',
        amount: 10.0,
        cost: 10.0,
        mileage: 1000,
        date: DateTime.fromMillisecondsSinceEpoch(0),
      );
      when(filteredRefuelingsBloc.state).thenAnswer((_) =>
          FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [Car()]));
      final refuelingsKey = Key('refuelings');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RefuelingsBloc>.value(
                value: refuelingsBloc,
              ),
              BlocProvider<FilteredRefuelingsBloc>.value(
                value: filteredRefuelingsBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RefuelingsScreen(key: refuelingsKey),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.fling(find.byType(RefuelingCard), Offset(-300, 0), 10000.0);
      await tester.pumpAndSettle();
      verify(refuelingsBloc.add(DeleteRefueling(refueling))).called(1);
    });
    testWidgets('tap', (WidgetTester tester) async {
      final refueling = Refueling(
        carName: 'test',
        amount: 10.0,
        cost: 10.0,
        mileage: 1000,
        date: DateTime.fromMillisecondsSinceEpoch(0),
      );
      when(filteredRefuelingsBloc.state).thenAnswer((_) =>
          FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [Car()]));
      final refuelingsKey = Key('refuelings');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RefuelingsBloc>.value(
                value: refuelingsBloc,
              ),
              BlocProvider<FilteredRefuelingsBloc>.value(
                value: filteredRefuelingsBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RefuelingsScreen(key: refuelingsKey),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RefuelingCard));
      await tester.pumpAndSettle();
      expect(find.byKey(refuelingsKey), findsOneWidget);
    });
  });
}
