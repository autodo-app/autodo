import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

void main() {
  CarsBloc carsBloc;

  setUp(() {
    carsBloc = MockCarsBloc();
  });

  group('RepeatsScreen', () {
    testWidgets('render', (WidgetTester tester) async {
      final key = Key('screen');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CarsBloc>.value(
              value: carsBloc,
            ),
          ],
          child: MaterialApp(
            home: RepeatAddEditScreen(
              key: key,
              isEditing: false,
              onSave: (a, b, c) {},
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
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CarsBloc>.value(
              value: carsBloc,
            ),
          ],
          child: MaterialApp(
            home: RepeatAddEditScreen(
              key: key,
              isEditing: false,
              onSave: (a, b, c) {
                saved = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var field in find.byType(TextFormField).evaluate()) {
        await tester.enterText(find.byWidget(field.widget), '10');
      }
      await tester.pump();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(saved, true);
    });
  });
}
