import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/screens/home/views/refuelings.dart';
import 'package:autodo/screens/home/widgets/refueling_card.dart';

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState>
    implements RefuelingsBloc {}

class MockFilteredRefuelingsBloc
    extends MockBloc<FilteredRefuelingsLoaded, FilteredRefuelingsState>
    implements FilteredRefuelingsBloc {}

void main() {
  RefuelingsBloc refuelingsBloc;
  FilteredRefuelingsBloc filteredRefuelingsBloc;

  setUp(() {
    refuelingsBloc = MockRefuelingsBloc();
    filteredRefuelingsBloc = MockFilteredRefuelingsBloc();
  });

  group('RefuelingsScreen', () {
    testWidgets('loading', (WidgetTester tester) async {
      when(filteredRefuelingsBloc.state).thenAnswer((_) => FilteredRefuelingsLoading());
      Key refuelingsKey = Key('refuelings');
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
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });
    testWidgets('not loaded', (WidgetTester tester) async {
      when(filteredRefuelingsBloc.state).thenAnswer((_) => FilteredRefuelingsNotLoaded());
      Key refuelingsKey = Key('refuelings');
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
      when(filteredRefuelingsBloc.state).thenAnswer((_) => FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [Car()]));
      Key refuelingsKey = Key('refuelings');
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
      when(filteredRefuelingsBloc.state).thenAnswer((_) => FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [Car()]));
      Key refuelingsKey = Key('refuelings');
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
      when(filteredRefuelingsBloc.state).thenAnswer((_) => FilteredRefuelingsLoaded([refueling], VisibilityFilter.all, [Car()]));
      Key refuelingsKey = Key('refuelings');
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
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RefuelingCard));
      await tester.pumpAndSettle();
      expect(find.byKey(refuelingsKey), findsOneWidget);
    });
  });
}