import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/screens/add_edit/forms/barrel.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockRepeatsBloc extends MockBloc<RepeatsEvent, RepeatsState>
    implements RepeatsBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

void main() {
  RepeatsBloc repeatsBloc;
  CarsBloc carsBloc;

  setUp(() {
    repeatsBloc = MockRepeatsBloc();
    carsBloc = MockCarsBloc();
  });

  group('TodosScreen', () {
    testWidgets('render', (WidgetTester tester) async {
      final key = Key('screen');
      await tester.pumpWidget(
        MultiBlocProvider(
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
        MultiBlocProvider(
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
      await tester.enterText(find.byType(CarForm), 'test');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(saved, true);
    });
    testWidgets('date button', (WidgetTester tester) async {
      final key = Key('screen');
      when(carsBloc.state).thenAnswer((_) => CarsLoaded([]));
      when(repeatsBloc.state).thenAnswer((_) => RepeatsLoaded([]));
      await tester.pumpWidget(
        MultiBlocProvider(
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
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });
  });
}
