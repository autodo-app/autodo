import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/units/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockCarsBloc extends Mock implements CarsBloc {}

void main() {
  BasePrefService pref;

  setUp(() async {
    pref = JustCachePrefService();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('RefuelingsScreen', () {
    testWidgets('render', (WidgetTester tester) async {
      final key = Key('screen');
      final carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([Car()]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [BlocProvider<CarsBloc>.value(value: carsBloc)],
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
    testWidgets('save', (WidgetTester tester) async {
      final key = Key('screen');
      var saved = false;
      final carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([Car()]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [BlocProvider<CarsBloc>.value(value: carsBloc)],
            child: MaterialApp(
              home: RefuelingAddEditScreen(
                  key: key,
                  isEditing: false,
                  onSave: (a, b, c, d, e) {
                    saved = true;
                  },
                  cars: [Car(name: 'test')]),
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
      final carsBloc = MockCarsBloc();
      when(carsBloc.state).thenReturn(CarsLoaded([Car()]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [BlocProvider<CarsBloc>.value(value: carsBloc)],
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
