import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/screens/add_edit/car.dart';

void main() {
  group('AddEditCarScreen', () {
    testWidgets('render', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
          ],
          child: MaterialApp(
            home: Scaffold(
              body: EditCarListScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(EditCarListScreen), findsOneWidget);
    });
    testWidgets('back', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
          ],
          child: MaterialApp(
            home: EditCarListScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(find.byType(EditCarListScreen), findsOneWidget);
    });
  });
}