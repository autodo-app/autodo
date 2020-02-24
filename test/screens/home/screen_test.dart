import 'package:autodo/integ_test_keys.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/screens/home/screen.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/localization.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

class MockTabBloc extends MockBloc<TabEvent, AppTab> implements TabBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

class MockRepeatsBloc extends MockBloc<RepeatsEvent, RepeatsState>
    implements RepeatsBloc {}

class MockPaidVersionBloc extends MockBloc<PaidVersionEvent, PaidVersionState>
    implements PaidVersionBloc {}

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState>
    implements RefuelingsBloc {}

void main() {
  group('HomeScreen', () {
    TodosBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;
    TabBloc tabBloc;
    PaidVersionBloc paidBloc;
    CarsBloc carsBloc;
    RefuelingsBloc refuelingsBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
      tabBloc = MockTabBloc();
      paidBloc = MockPaidVersionBloc();
      when(paidBloc.observer).thenReturn(RouteObserver());
      carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([Car(name: 'test')]));
      refuelingsBloc = MockRefuelingsBloc();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(tabBloc.state).thenAnswer((_) => AppTab.todos);
      Key scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<TabBloc>.value(
              value: tabBloc,
            ),
            BlocProvider<PaidVersionBloc>.value(value: paidBloc),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(key: scaffoldKey),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(scaffoldKey), findsOneWidget);
      // expect(find.text(JsonIntl.of(context).get(IntlKeys.appTitle), findsOneWidget);
    });

    testWidgets('tab switch', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(tabBloc.state).thenAnswer((_) => AppTab.todos);
      when(tabBloc.add(UpdateTab(AppTab.todos))).thenAnswer((_) => null);
      Key scaffoldKey = Key('scaffold');
      Key todosTabKey = Key('tab');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<TabBloc>.value(
              value: tabBloc,
            ),
            BlocProvider<PaidVersionBloc>.value(value: paidBloc),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(key: scaffoldKey, todosTabKey: todosTabKey),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(todosTabKey));
      await tester.pump();
      verify(tabBloc.add(UpdateTab(AppTab.todos))).called(1);
    });
    group('fab routes', () {
      testWidgets('refueling', (WidgetTester tester) async {
        when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
        when(tabBloc.state).thenAnswer((_) => AppTab.todos);
        Key scaffoldKey = Key('scaffold');
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenReturn(CarsLoaded([Car()]));
        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<TodosBloc>.value(
                value: todosBloc,
              ),
              BlocProvider<FilteredTodosBloc>.value(
                value: filteredTodosBloc,
              ),
              BlocProvider<TabBloc>.value(
                value: tabBloc,
              ),
              BlocProvider<CarsBloc>.value(value: carsBloc),
              BlocProvider<PaidVersionBloc>.value(value: paidBloc),
              BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: HomeScreen(key: scaffoldKey),
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
        when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
        when(tabBloc.state).thenAnswer((_) => AppTab.todos);
        Key scaffoldKey = Key('scaffold');
        final carsBloc = MockCarsBloc();
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([Car()])
            ]));
        when(carsBloc.state).thenReturn(CarsLoaded([Car()]));
        final repeatsBloc = MockRepeatsBloc();
        when(repeatsBloc.state).thenReturn(RepeatsLoaded([Repeat()]));
        whenListen(
            repeatsBloc,
            Stream.fromIterable([
              RepeatsLoaded([Repeat()])
            ]));
        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<TodosBloc>.value(
                value: todosBloc,
              ),
              BlocProvider<FilteredTodosBloc>.value(
                value: filteredTodosBloc,
              ),
              BlocProvider<TabBloc>.value(
                value: tabBloc,
              ),
              BlocProvider<CarsBloc>.value(value: carsBloc),
              BlocProvider<RepeatsBloc>.value(value: repeatsBloc),
              BlocProvider<PaidVersionBloc>.value(value: paidBloc),
              BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: HomeScreen(key: scaffoldKey),
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
      testWidgets('repeat', (WidgetTester tester) async {
        when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
        when(tabBloc.state).thenAnswer((_) => AppTab.todos);
        Key scaffoldKey = Key('scaffold');
        final carsBloc = MockCarsBloc();
        when(carsBloc.state).thenReturn(CarsLoaded([Car(name: 'test')]));
        whenListen(
            carsBloc,
            Stream.fromIterable([
              CarsLoaded([Car(name: 'test')])
            ]));
        final repeatsBloc = MockRepeatsBloc();
        when(repeatsBloc.state).thenReturn(RepeatsLoaded([Repeat()]));
        whenListen(
            repeatsBloc,
            Stream.fromIterable([
              RepeatsLoaded([Repeat()])
            ]));
        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<TodosBloc>.value(
                value: todosBloc,
              ),
              BlocProvider<FilteredTodosBloc>.value(
                value: filteredTodosBloc,
              ),
              BlocProvider<TabBloc>.value(
                value: tabBloc,
              ),
              BlocProvider<CarsBloc>.value(value: carsBloc),
              BlocProvider<RepeatsBloc>.value(value: repeatsBloc),
              BlocProvider<PaidVersionBloc>.value(value: paidBloc),
              BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: HomeScreen(key: scaffoldKey),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(IntegrationTestKeys.mainFab));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(IntegrationTestKeys.fabKeys[2]));
        await tester.pumpAndSettle();
        expect(find.byType(RepeatAddEditScreen), findsOneWidget);
      });
    });
  });
}
