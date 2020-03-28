import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/add_edit/forms/barrel.dart';
import 'package:autodo/units/units.dart';

class MockCarsBloc extends Mock implements CarsBloc {}

void main() {
  group('add edit forms', () {
    BasePrefService pref;

    setUp(() async {
      pref = JustCachePrefService();
      await pref.setDefaultValues({
        'length_unit': DistanceUnit.imperial.index,
        'volume_unit': VolumeUnit.us.index,
        'currency': 'USD',
      });
    });
    testWidgets('car autocomplete', (WidgetTester tester) async {
      final carsBloc = MockCarsBloc();
      when(carsBloc.state)
          .thenReturn(CarsLoaded([Car(name: 'test'), Car(name: 'test1')]));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [BlocProvider<CarsBloc>.value(value: carsBloc)],
          child: MaterialApp(
            home: Card(
              child: CarForm(
                onSaved: (_) {},
                node: FocusNode(),
                nextNode: FocusNode(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(CarForm));
      await tester.pump();
      await tester.enterText(find.byType(CarForm), 't');
      await tester.pumpAndSettle();
      expect(find.byType(CarForm), findsOneWidget);
    });
    testWidgets('car checkbox', (tester) async {
      await tester.pumpWidget(
        // MultiBlocProvider(
        //   providers: [],
        MaterialApp(
          home: Card(
            child: CarsCheckboxForm(
              cars: [Car(name: 'test')],
              onSaved: (_) {},
            ),
          ),
        ),
        // ),
      );
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
    });
    group('repeat interval', () {
      testWidgets('render', (WidgetTester tester) async {
        final carsBloc = MockCarsBloc();
        when(carsBloc.state)
            .thenReturn(CarsLoaded([Car(name: 'test'), Car(name: 'test1')]));
        await tester.pumpWidget(
          ChangeNotifierProvider<BasePrefService>.value(
            value: pref,
            child: MultiBlocProvider(
              providers: [BlocProvider<CarsBloc>.value(value: carsBloc)],
              child:
                  MaterialApp(home: RepeatIntervalSelector(onSaved: (a, b) {})),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(RepeatIntervalSelector), findsOneWidget);
      });
      testWidgets('buttons', (WidgetTester tester) async {
        final carsBloc = MockCarsBloc();
        final key = GlobalKey<RepeatIntervalSelectorState>();
        when(carsBloc.state)
            .thenReturn(CarsLoaded([Car(name: 'test'), Car(name: 'test1')]));
        await tester.pumpWidget(
          ChangeNotifierProvider<BasePrefService>.value(
            value: pref,
            child: MultiBlocProvider(
              providers: [BlocProvider<CarsBloc>.value(value: carsBloc)],
              child: MaterialApp(
                  home: RepeatIntervalSelector(key: key, onSaved: (a, b) {})),
            ),
          ),
        );
        await tester.pump();
        await tester.tap(find.byKey(
            RepeatIntervalSelector.radioKeys[DateRepeatInterval.WEEKLY]));
        await tester.pumpAndSettle();
        expect(key.currentState.dateInterval, RepeatInterval(days: 7));
        await tester.tap(find.byKey(
            RepeatIntervalSelector.radioKeys[DateRepeatInterval.MONTHLY]));
        await tester.pumpAndSettle();
        expect(key.currentState.dateInterval, RepeatInterval(months: 1));
        await tester.tap(find.byKey(
            RepeatIntervalSelector.radioKeys[DateRepeatInterval.YEARLY]));
        await tester.pumpAndSettle();
        expect(key.currentState.dateInterval, RepeatInterval(years: 1));
        await tester.tap(find.byKey(
            RepeatIntervalSelector.radioKeys[DateRepeatInterval.CUSTOM]));
        await tester.pumpAndSettle();
        expect(key.currentState.dateInterval, null);
        await tester.tap(find
            .byKey(RepeatIntervalSelector.radioKeys[DateRepeatInterval.NEVER]));
        await tester.pump();
        expect(key.currentState.dateInterval, null);
        expect(find.byType(RepeatIntervalSelector), findsOneWidget);
      });
      testWidgets('save', (WidgetTester tester) async {
        final carsBloc = MockCarsBloc();
        when(carsBloc.state)
            .thenReturn(CarsLoaded([Car(name: 'test'), Car(name: 'test1')]));
        var saved = false;
        await tester.pumpWidget(
          ChangeNotifierProvider<BasePrefService>.value(
            value: pref,
            child: MultiBlocProvider(
              providers: [BlocProvider<CarsBloc>.value(value: carsBloc)],
              child: MaterialApp(home: RepeatIntervalSelector(onSaved: (a, b) {
                saved = true;
              })),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(RepeatIntervalSelector), findsOneWidget);
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        expect(saved, true);
      });
    });
  });
}
