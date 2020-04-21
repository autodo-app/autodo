import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/units/units.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/screens/home/screen.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/generated/localization.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

class MockPaidVersionBloc extends MockBloc<PaidVersionEvent, PaidVersionState>
    implements PaidVersionBloc {}

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState>
    implements RefuelingsBloc {}

void main() {
  group('HomeScreen', () {
    TodosBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;
    PaidVersionBloc paidBloc;
    CarsBloc carsBloc;
    RefuelingsBloc refuelingsBloc;
    BasePrefService pref;

    setUp(() async {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
      paidBloc = MockPaidVersionBloc();
      when(paidBloc.observer).thenReturn(RouteObserver());
      carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([Car(name: 'test')]));
      refuelingsBloc = MockRefuelingsBloc();

      pref = JustCachePrefService();
      await pref.setDefaultValues({
        'length_unit': DistanceUnit.imperial.index,
        'volume_unit': VolumeUnit.us.index,
        'currency': 'USD',
      });
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded(todos: []));
      final scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<PaidVersionBloc>.value(value: paidBloc),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(key: scaffoldKey, tab: AppTab.todos),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(scaffoldKey), findsOneWidget);
    });

    testWidgets('tab switch', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded(todos: []));
      final scaffoldKey = GlobalKey<HomeScreenState>();
      final todosTabKey = Key('tab');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<PaidVersionBloc>.value(value: paidBloc),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(
                key: scaffoldKey,
                todosTabKey: todosTabKey,
                tab: AppTab.refuelings,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(todosTabKey));
      await tester.pump();
      expect(scaffoldKey.currentState.tab, AppTab.todos);
    });
    group('fab routes', () {
      testWidgets('refueling', (WidgetTester tester) async {
        when(todosBloc.state).thenAnswer((_) => TodosLoaded(todos: []));
        final scaffoldKey = Key('scaffold');
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenReturn(CarsLoaded([Car()]));
        await tester.pumpWidget(
          ChangeNotifierProvider<BasePrefService>.value(
            value: pref,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<TodosBloc>.value(
                  value: todosBloc,
                ),
                BlocProvider<FilteredTodosBloc>.value(
                  value: filteredTodosBloc,
                ),
                BlocProvider<CarsBloc>.value(value: carsBloc),
                BlocProvider<PaidVersionBloc>.value(value: paidBloc),
                BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
              ],
              child: MaterialApp(
                home: Scaffold(
                  body: HomeScreen(key: scaffoldKey, tab: AppTab.todos),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(IntegrationTestKeys.mainFab));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(IntegrationTestKeys.fabKeys[0]));
        await tester.pumpAndSettle();
        expect(find.byType(RefuelingAddEditScreen), findsOneWidget);
      });
      testWidgets('todo', (WidgetTester tester) async {
        when(todosBloc.state).thenAnswer((_) => TodosLoaded(todos: []));
        final scaffoldKey = Key('scaffold');
        final carsBloc = MockCarsBloc();
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([Car()])
            ]));
        when(carsBloc.state).thenReturn(CarsLoaded([Car()]));

        await tester.pumpWidget(
          ChangeNotifierProvider<BasePrefService>.value(
            value: pref,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<TodosBloc>.value(
                  value: todosBloc,
                ),
                BlocProvider<FilteredTodosBloc>.value(
                  value: filteredTodosBloc,
                ),
                BlocProvider<CarsBloc>.value(value: carsBloc),
                BlocProvider<PaidVersionBloc>.value(value: paidBloc),
                BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
              ],
              child: MaterialApp(
                home: Scaffold(
                  body: HomeScreen(key: scaffoldKey, tab: AppTab.todos),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(IntegrationTestKeys.mainFab));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(IntegrationTestKeys.fabKeys[1]));
        await tester.pumpAndSettle();
        expect(find.byType(TodoAddEditScreen), findsOneWidget);
      });
    });
  });
}
