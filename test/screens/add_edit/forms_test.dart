import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/add_edit/forms/barrel.dart';

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
  });
}
