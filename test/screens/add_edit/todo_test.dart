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
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

void main() {
  DataBloc dataBloc;
  BasePrefService pref;

  setUp(() async {
    dataBloc = MockDataBloc();
    pref = PrefServiceCache();
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
              BlocProvider<DataBloc>.value(value: dataBloc),
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
      final snap = OdomSnapshot(
          date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [
        Car(name: '1', odomSnapshot: snap),
        Car(name: '2', odomSnapshot: snap)
      ]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DataBloc>.value(value: dataBloc),
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
      final snap = OdomSnapshot(
          date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [
        Car(name: '1', odomSnapshot: snap),
        Car(name: '2', odomSnapshot: snap),
        Car(name: '3', odomSnapshot: snap),
        Car(name: '4', odomSnapshot: snap)
      ]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DataBloc>.value(value: dataBloc),
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
      final snap = OdomSnapshot(
          date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [
        Car(name: 'test', odomSnapshot: snap),
      ]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DataBloc>.value(value: dataBloc),
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
      final snap = OdomSnapshot(
          date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [
        Car(name: 'test', odomSnapshot: snap),
      ]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DataBloc>.value(value: dataBloc),
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
      final snap = OdomSnapshot(
          date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [
        Car(name: 'test', odomSnapshot: snap),
      ]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DataBloc>.value(value: dataBloc),
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
      final snap = OdomSnapshot(
          date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [
        Car(name: 'test', odomSnapshot: snap),
      ]));
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
              BlocProvider<DataBloc>.value(value: dataBloc),
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
