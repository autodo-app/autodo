import 'package:autodo/generated/localization.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/units/units.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/routes.dart';
import 'package:autodo/screens/welcome/views/new_user_setup/screen.dart';
import 'package:autodo/screens/welcome/views/new_user_setup/latestcompleted.dart';
import 'package:autodo/screens/welcome/views/new_user_setup/setrepeats.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockCarsBloc extends Mock implements CarsBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockDatabaseBloc extends MockBloc<DatabaseEvent, DatabaseState>
    implements DatabaseBloc {}

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

// ignore: must_be_immutable
class MockRepo extends Mock implements DataRepository {}

void main() {
  BasePrefService pref;
  final todosLoaded = TodosLoaded([
    Todo(name: 'oil', mileageRepeatInterval: 3500),
    Todo(name: 'tireRotation', mileageRepeatInterval: 7500)
  ]);

  setUp(() async {
    pref = JustCachePrefService();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('new user screens', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final authBloc = MockAuthenticationBloc();
    whenListen(
        authBloc, Stream.fromIterable([RemoteAuthenticated('', '', false)]));
    when(authBloc.state).thenReturn(RemoteAuthenticated('', '', false));
    final dbBloc = MockDatabaseBloc();
    when(dbBloc.state).thenReturn(DbLoaded(MockRepo(), newUser: true));
    testWidgets('mileage', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(providers: [
            BlocProvider<AuthenticationBloc>.value(value: authBloc),
            BlocProvider<DatabaseBloc>.value(value: dbBloc)
          ], child: MaterialApp(home: NewUserScreen())),
        ),
      );
      expect(find.byType(NewUserScreen), findsOneWidget);
    });
    testWidgets('Latest complete', (tester) async {
      final carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(providers: [
            BlocProvider<AuthenticationBloc>.value(value: authBloc),
            BlocProvider<DatabaseBloc>.value(value: dbBloc),
            BlocProvider<CarsBloc>.value(value: carsBloc),
          ], child: MaterialApp(home: NewUserScreen())),
        ),
      );
      expect(find.byType(NewUserScreen), findsOneWidget);
      for (var w in find.byType(TextFormField).evaluate()) {
        // put values in for mileage form
        await tester.enterText(find.byWidget(w.widget), '2000');
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(IntlKeys.next));
      await tester.pumpAndSettle();
      expect(find.byType(LatestRepeatsScreen), findsOneWidget);
    });
    testWidgets('set repeats', (tester) async {
      final todosBloc = MockTodosBloc();
      when(todosBloc.state).thenReturn(todosLoaded);
      final carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([Car(name: 'test')]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(providers: [
            BlocProvider<AuthenticationBloc>.value(value: authBloc),
            BlocProvider<DatabaseBloc>.value(value: dbBloc),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<TodosBloc>.value(value: todosBloc),
          ], child: MaterialApp(home: NewUserScreen())),
        ),
      );
      expect(find.byType(NewUserScreen), findsOneWidget);
      for (var w in find.byType(TextFormField).evaluate()) {
        // put values in for mileage form
        await tester.enterText(find.byWidget(w.widget), '2000');
        await tester.pump();
      }
      await tester.tap(find.text(IntlKeys.next));
      await tester.pumpAndSettle();
      expect(find.byType(LatestRepeatsScreen), findsOneWidget);
      await tester.tap(find.text(IntlKeys.next));
      await tester.pumpAndSettle();
      expect(find.byType(SetRepeatsScreen), findsOneWidget);
    });
    testWidgets('set repeats back', (tester) async {
      final todosBloc = MockTodosBloc();
      when(todosBloc.state).thenReturn(
          TodosLoaded([Todo(name: 'oil'), Todo(name: 'tireRotation')]));
      final carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([Car(name: 'test')]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(providers: [
            BlocProvider<AuthenticationBloc>.value(value: authBloc),
            BlocProvider<DatabaseBloc>.value(value: dbBloc),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<TodosBloc>.value(value: todosBloc),
          ], child: MaterialApp(home: NewUserScreen())),
        ),
      );
      expect(find.byType(NewUserScreen), findsOneWidget);
      for (var w in find.byType(TextFormField).evaluate()) {
        // put values in for mileage form
        await tester.enterText(find.byWidget(w.widget), '2000');
        await tester.pump();
      }
      await tester.tap(find.text(IntlKeys.next));
      await tester.pumpAndSettle();
      expect(find.byType(LatestRepeatsScreen), findsOneWidget);
      await tester.tap(find.text(IntlKeys.next));
      await tester.pumpAndSettle();
      expect(find.byType(SetRepeatsScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(LatestRepeatsScreen), findsOneWidget);
    });
    testWidgets('set repeats next', (tester) async {
      final todosBloc = MockTodosBloc();
      whenListen(todosBloc, Stream.fromIterable([todosLoaded]));
      when(todosBloc.state).thenReturn(todosLoaded);
      final carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([Car(name: 'test')]));
      final homeKey = GlobalKey();
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
              providers: [
                BlocProvider<AuthenticationBloc>.value(value: authBloc),
                BlocProvider<DatabaseBloc>.value(value: dbBloc),
                BlocProvider<CarsBloc>.value(value: carsBloc),
                BlocProvider<TodosBloc>.value(value: todosBloc),
              ],
              child: MaterialApp(home: NewUserScreen(), routes: {
                AutodoRoutes.home: (context) => Container(key: homeKey),
              })),
        ),
      );
      expect(find.byType(NewUserScreen), findsOneWidget);
      for (var w in find.byType(TextFormField).evaluate()) {
        // put values in for mileage form
        await tester.enterText(find.byWidget(w.widget), '2000');
        await tester.pump();
      }
      await tester.tap(find.text(IntlKeys.next));
      await tester.pumpAndSettle();
      expect(find.byType(LatestRepeatsScreen), findsOneWidget);
      await tester.tap(find.text(IntlKeys.next));
      await tester.pumpAndSettle();
      expect(find.byType(SetRepeatsScreen), findsOneWidget);
      await tester.tap(find.text(IntlKeys.next));
      await tester.pumpAndSettle();
      expect(find.byKey(homeKey), findsOneWidget);
    });
  });
}
