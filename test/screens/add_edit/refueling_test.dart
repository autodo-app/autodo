import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/units/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';
import 'package:autodo/screens/add_edit/forms/barrel.dart';

class MockDataBloc extends Mock implements DataBloc {}

void main() {
  BasePrefService pref;

  setUp(() async {
    pref = PrefServiceCache();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('RefuelingsScreen', () {
    testWidgets('render', (WidgetTester tester) async {
      final key = Key('screen');
      final dataBloc = MockDataBloc();
      final snap = OdomSnapshot(date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [Car(name: 'test', odomSnapshot: snap)]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [BlocProvider<DataBloc>.value(value: dataBloc),],
            child: MaterialApp(
              home: RefuelingAddEditScreen(
                  key: key,
                  isEditing: false,
                  onSave: (a, b, c, d, e) {},
                  cars: []),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(key), findsOneWidget);
    });
    testWidgets('render w/toggle', (WidgetTester tester) async {
      final key = Key('screen');
      final dataBloc = MockDataBloc();
      final snap = OdomSnapshot(date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [Car(name: 'test', odomSnapshot: snap)]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [BlocProvider<DataBloc>.value(value: dataBloc),],
            child: MaterialApp(
              home: RefuelingAddEditScreen(
                  key: key,
                  isEditing: false,
                  onSave: (a, b, c, d, e) {},
                  cars: [Car(name: '1'), Car(name: '2')]),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(key), findsOneWidget);
      expect(find.byType(CarToggleForm), findsOneWidget);
    });
    testWidgets('render w/autocomplete', (WidgetTester tester) async {
      final key = Key('screen');
      final dataBloc = MockDataBloc();
      final snap = OdomSnapshot(date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [Car(name: 'test', odomSnapshot: snap)]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [BlocProvider<DataBloc>.value(value: dataBloc),],
            child: MaterialApp(
              home: RefuelingAddEditScreen(
                  key: key,
                  isEditing: false,
                  onSave: (a, b, c, d, e) {},
                  cars: [
                    Car(name: '1', odomSnapshot: snap),
                    Car(name: '2', odomSnapshot: snap),
                    Car(name: '3', odomSnapshot: snap),
                    Car(name: '4', odomSnapshot: snap),
                  ]),
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
      final dataBloc = MockDataBloc();
      final snap = OdomSnapshot(date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [Car(name: 'test', odomSnapshot: snap)]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [BlocProvider<DataBloc>.value(value: dataBloc),],
            child: MaterialApp(
              home: RefuelingAddEditScreen(
                  key: key,
                  isEditing: false,
                  onSave: (a, b, c, d, e) {
                    saved = true;
                  },
                  cars: [Car(name: 'test', odomSnapshot: snap)]),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var field in find.byType(TextFormField).evaluate()) {
        if ((field.widget as TextFormField).controller != null) {
          await tester.enterText(find.byWidget(field.widget), '01/01/1970');
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
      final dataBloc = MockDataBloc();
      final snap = OdomSnapshot(date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
      when(dataBloc.state).thenReturn(DataLoaded(cars: [Car(name: 'test', odomSnapshot: snap)]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [BlocProvider<DataBloc>.value(value: dataBloc),],
            child: MaterialApp(
              home: RefuelingAddEditScreen(
                  key: key,
                  isEditing: false,
                  onSave: (a, b, c, d, e) {},
                  cars: []),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });
  });
}
