import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/add_edit/forms/barrel.dart';

class MockRepeatsBloc extends Mock implements RepeatsBloc {}

class MockCarsBloc extends Mock implements CarsBloc {}

void main() {
  group('add edit forms', () {
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
    testWidgets('repeat autocomplete', (WidgetTester tester) async {
      final repeatsBloc = MockRepeatsBloc();
      when(repeatsBloc.state).thenReturn(RepeatsLoaded([Repeat(name: 'test')]));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [BlocProvider<RepeatsBloc>.value(value: repeatsBloc)],
          child: MaterialApp(
            home: Card(
              child: RepeatForm(
                requireInput: false,
                onSaved: (_) {},
                node: FocusNode(),
                nextNode: FocusNode(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(RepeatForm));
      await tester.pump();
      await tester.enterText(find.byType(RepeatForm), 't');
      await tester.pumpAndSettle();
      expect(find.byType(RepeatForm), findsOneWidget);
    });
    testWidgets('repeat autocomplete validate', (WidgetTester tester) async {
      final repeatsBloc = MockRepeatsBloc();
      when(repeatsBloc.state).thenReturn(
          RepeatsLoaded([Repeat(name: 'test'), Repeat(name: 'test1')]));
      bool saved = false;
      final key = GlobalKey<FormState>();
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [BlocProvider<RepeatsBloc>.value(value: repeatsBloc)],
          child: MaterialApp(
              home: Card(
            child: Form(
              key: key,
              child: RepeatForm(
                requireInput: true,
                onSaved: (_) {
                  saved = true;
                },
                node: FocusNode(),
                nextNode: FocusNode(),
              ),
            ),
          )),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(RepeatForm));
      await tester.pump();
      await tester.enterText(find.byType(RepeatForm), 'test');
      await tester.pumpAndSettle();
      key.currentState.validate();
      key.currentState.save();
      await tester.pump();
      expect(saved, true);
    });
  });
}
