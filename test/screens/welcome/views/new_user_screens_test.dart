import 'package:autodo/localization.dart';
import 'package:autodo/repositories/repositories.dart';
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

class MockCarsBloc extends Mock implements CarsBloc {}

class MockRepeatsBloc extends MockBloc<RepeatsEvent, RepeatsState>
    implements RepeatsBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockDatabaseBloc extends MockBloc<DatabaseEvent, DatabaseState>
    implements DatabaseBloc {}

// ignore: must_be_immutable
class MockRepo extends Mock implements DataRepository {}

void main() {
  group('new user screens', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final authBloc = MockAuthenticationBloc();
    whenListen(
        authBloc, Stream.fromIterable([RemoteAuthenticated('', '', false)]));
    when(authBloc.state).thenReturn(RemoteAuthenticated('', '', false));
    final dbBloc = MockDatabaseBloc();
    // whenListen(dbBloc, Stream.fromIterable([DbLoaded(MockRepo())]));
    when(dbBloc.state).thenReturn(DbLoaded(MockRepo(), true));
    testWidgets('mileage', (tester) async {
      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<AuthenticationBloc>.value(value: authBloc),
        BlocProvider<DatabaseBloc>.value(value: dbBloc)
      ], child: MaterialApp(home: NewUserScreen())));
      expect(find.byType(NewUserScreen), findsOneWidget);
    });
    testWidgets('Latest complete', (tester) async {
      final carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([]));
      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<AuthenticationBloc>.value(value: authBloc),
        BlocProvider<DatabaseBloc>.value(value: dbBloc),
        BlocProvider<CarsBloc>.value(value: carsBloc),
      ], child: MaterialApp(home: NewUserScreen())));
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
      final carsBloc = MockCarsBloc();
      final repeatsBloc = MockRepeatsBloc();
      whenListen(
          repeatsBloc,
          Stream.fromIterable([
            RepeatsLoaded([
              Repeat(name: 'oil', mileageInterval: 1000),
              Repeat(name: 'tireRotation', mileageInterval: 1000)
            ])
          ]));
      when(repeatsBloc.state).thenReturn(RepeatsLoaded([
        Repeat(name: 'oil', mileageInterval: 1000),
        Repeat(name: 'tireRotation', mileageInterval: 1000)
      ]));
      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<AuthenticationBloc>.value(value: authBloc),
        BlocProvider<DatabaseBloc>.value(value: dbBloc),
        BlocProvider<CarsBloc>.value(value: carsBloc),
        BlocProvider<RepeatsBloc>.value(value: repeatsBloc),
      ], child: MaterialApp(home: NewUserScreen())));
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
      final carsBloc = MockCarsBloc();
      final repeatsBloc = MockRepeatsBloc();
      whenListen(
          repeatsBloc,
          Stream.fromIterable([
            RepeatsLoaded([
              Repeat(name: 'oil', mileageInterval: 1000),
              Repeat(name: 'tireRotation', mileageInterval: 1000)
            ])
          ]));
      when(repeatsBloc.state).thenReturn(RepeatsLoaded([
        Repeat(name: 'oil', mileageInterval: 1000),
        Repeat(name: 'tireRotation', mileageInterval: 1000)
      ]));
      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<AuthenticationBloc>.value(value: authBloc),
        BlocProvider<DatabaseBloc>.value(value: dbBloc),
        BlocProvider<CarsBloc>.value(value: carsBloc),
        BlocProvider<RepeatsBloc>.value(value: repeatsBloc),
      ], child: MaterialApp(home: NewUserScreen())));
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
      final carsBloc = MockCarsBloc();
      final repeatsBloc = MockRepeatsBloc();
      whenListen(
          repeatsBloc,
          Stream.fromIterable([
            RepeatsLoaded([
              Repeat(name: 'oil', mileageInterval: 1000),
              Repeat(name: 'tireRotation', mileageInterval: 1000)
            ])
          ]));
      when(repeatsBloc.state).thenReturn(RepeatsLoaded([
        Repeat(name: 'oil', mileageInterval: 1000),
        Repeat(name: 'tireRotation', mileageInterval: 1000)
      ]));
      await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(value: authBloc),
            BlocProvider<DatabaseBloc>.value(value: dbBloc),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<RepeatsBloc>.value(value: repeatsBloc),
          ],
          child: MaterialApp(home: NewUserScreen(), routes: {
            AutodoRoutes.home: (context) => Container(),
          })));
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
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
