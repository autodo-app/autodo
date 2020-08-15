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
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

class MockPaidVersionBloc extends MockBloc<PaidVersionEvent, PaidVersionState>
    implements PaidVersionBloc {}

class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

void main() {
  group('HomeScreen', () {
    FilteredTodosBloc filteredTodosBloc;
    PaidVersionBloc paidBloc;
    DataBloc dataBloc;
    BasePrefService pref;
    final snap =
        OdomSnapshot(mileage: 0, date: DateTime.fromMillisecondsSinceEpoch(0));
    final cars = [Car(name: 'test', odomSnapshot: snap)];
    final todos = <Todo>[];

    setUp(() async {
      filteredTodosBloc = MockFilteredTodosBloc();
      paidBloc = MockPaidVersionBloc();
      when(paidBloc.observer).thenReturn(RouteObserver());
      dataBloc = MockDataBloc();
      when(dataBloc.state).thenReturn(DataLoaded(cars: cars, todos: todos));

      pref = PrefServiceCache();
      await pref.setDefaultValues({
        'length_unit': DistanceUnit.imperial.index,
        'volume_unit': VolumeUnit.us.index,
        'currency': 'USD',
      });
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      final scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<DataBloc>.value(value: dataBloc),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<PaidVersionBloc>.value(value: paidBloc),
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
      final scaffoldKey = GlobalKey<HomeScreenState>();
      final todosTabKey = Key('tab');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<DataBloc>.value(value: dataBloc),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<PaidVersionBloc>.value(value: paidBloc),
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
        final scaffoldKey = Key('scaffold');
        await tester.pumpWidget(
          ChangeNotifierProvider<BasePrefService>.value(
            value: pref,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<DataBloc>.value(value: dataBloc),
                BlocProvider<FilteredTodosBloc>.value(
                  value: filteredTodosBloc,
                ),
                BlocProvider<PaidVersionBloc>.value(value: paidBloc),
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
        final scaffoldKey = Key('scaffold');

        await tester.pumpWidget(
          ChangeNotifierProvider<BasePrefService>.value(
            value: pref,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<DataBloc>.value(value: dataBloc),
                BlocProvider<FilteredTodosBloc>.value(
                  value: filteredTodosBloc,
                ),
                BlocProvider<PaidVersionBloc>.value(value: paidBloc),
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
