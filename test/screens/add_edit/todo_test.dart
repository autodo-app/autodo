import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/screens/add_edit/forms/barrel.dart';
import 'package:autodo/screens/add_edit/forms/repeat_interval.dart';
import 'package:autodo/units/units.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

void main() {
  CarsBloc carsBloc;
  BasePrefService pref;

  setUp(() async {
    carsBloc = MockCarsBloc();
    pref = JustCachePrefService();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('TodosScreen', () {
    testWidgets('render', (WidgetTester tester) async {
      final key = Key('screen');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e, f) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(key), findsOneWidget);
    });
    testWidgets('render w/car toggle form', (WidgetTester tester) async {
      final key = Key('screen');
      when(carsBloc.state)
          .thenReturn(CarsLoaded([Car(name: '1'), Car(name: '2')]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e, f) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(key), findsOneWidget);
      expect(find.byType(CarToggleForm), findsOneWidget);
    });
    testWidgets('render w/car autocomplete form', (WidgetTester tester) async {
      final key = Key('screen');
      when(carsBloc.state).thenReturn(CarsLoaded(
          [Car(name: '1'), Car(name: '2'), Car(name: '3'), Car(name: '4')]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e, f) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(key), findsOneWidget);
      expect(find.byType(CarForm), findsOneWidget);
    });
    testWidgets('save', (WidgetTester tester) async {
      final key = Key('screen');
      var saved = false;
      when(carsBloc.state).thenAnswer((_) => CarsLoaded([Car(name: 'test')]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e, f) {
                  saved = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var field in find.byType(TextFormField).evaluate()) {
        if ((field.widget as TextFormField).controller != null) {
          await tester.enterText(find.byWidget(field.widget), '01/01/3000');
        } else {
          await tester.enterText(find.byWidget(field.widget), '10');
        }
      }
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(saved, true);
    });
    testWidgets('date button', (WidgetTester tester) async {
      final key = Key('screen');
      when(carsBloc.state).thenAnswer((_) => CarsLoaded([]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e, f) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });
    testWidgets('repeat button', (WidgetTester tester) async {
      final key = Key('screen');
      when(carsBloc.state).thenAnswer((_) => CarsLoaded([]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e, f) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.repeat));
      await tester.pumpAndSettle();
      expect(find.byType(RepeatIntervalSelector), findsOneWidget);
    });
    testWidgets('repeatIntervalToString', (WidgetTester tester) async {
      final key = GlobalKey<TodoAddEditScreenState>();
      when(carsBloc.state).thenAnswer((_) => CarsLoaded([]));
      final screen = TodoAddEditScreen(
        key: key,
        isEditing: false,
        onSave: (a, b, c, d, e, f) {},
      );
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: screen,
              locale: Locale('en'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // now check all repeatIntervalString options
      expect(
          key.currentState.repeatIntervalToString(RepeatInterval()), 'never');
      expect(key.currentState.repeatIntervalToString(RepeatInterval(days: 1)),
          'every day');
      expect(key.currentState.repeatIntervalToString(RepeatInterval(days: 2)),
          'every 2 days');
      expect(key.currentState.repeatIntervalToString(RepeatInterval(days: 7)),
          'every week');
      expect(key.currentState.repeatIntervalToString(RepeatInterval(months: 1)),
          'every month');
      expect(key.currentState.repeatIntervalToString(RepeatInterval(months: 2)),
          'every 2 months');
      expect(key.currentState.repeatIntervalToString(RepeatInterval(years: 1)),
          'every year');
      expect(key.currentState.repeatIntervalToString(RepeatInterval(years: 2)),
          'every 2 years');
    });
  });
}
