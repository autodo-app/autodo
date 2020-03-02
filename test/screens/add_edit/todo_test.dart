import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/screens/add_edit/forms/barrel.dart';
import 'package:autodo/units/units.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockRepeatsBloc extends MockBloc<RepeatsEvent, RepeatsState>
    implements RepeatsBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

void main() {
  RepeatsBloc repeatsBloc;
  CarsBloc carsBloc;
  BasePrefService pref;

  setUp(() async {
    repeatsBloc = MockRepeatsBloc();
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
              BlocProvider<RepeatsBloc>.value(
                value: repeatsBloc,
              ),
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e) {},
              ),
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
      when(carsBloc.state).thenAnswer((_) => CarsLoaded([Car(name: 'test')]));
      when(repeatsBloc.state).thenAnswer((_) => RepeatsLoaded([]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RepeatsBloc>.value(
                value: repeatsBloc,
              ),
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e) {
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
      await tester.enterText(find.byType(RepeatForm), 'test');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(saved, true);
    });
    testWidgets('date button', (WidgetTester tester) async {
      final key = Key('screen');
      when(carsBloc.state).thenAnswer((_) => CarsLoaded([]));
      when(repeatsBloc.state).thenAnswer((_) => RepeatsLoaded([]));
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RepeatsBloc>.value(
                value: repeatsBloc,
              ),
              BlocProvider<CarsBloc>.value(
                value: carsBloc,
              ),
            ],
            child: MaterialApp(
              home: TodoAddEditScreen(
                key: key,
                isEditing: false,
                onSave: (a, b, c, d, e) {},
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
  });
}
