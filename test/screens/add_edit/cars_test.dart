import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCarsBloc extends Mock implements CarsBloc {}

void main() {
  group('AddEditCarScreen', () {
    testWidgets('render', (WidgetTester tester) async {
      await tester.pumpWidget(
        // MultiBlocProvider(
        //   providers: [],
        MaterialApp(
          home: Scaffold(
            body: CarAddEditScreen(onSave: (a, b, c, d, e, f, g) {}),
          ),
        ),
        // ),
      );
      await tester.pump();
      expect(find.byType(CarAddEditScreen), findsOneWidget);
    });
  });
}
