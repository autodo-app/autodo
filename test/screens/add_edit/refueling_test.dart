import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/screens/add_edit/forms/barrel.dart';

void main() {
  group('RefuelingsScreen', () {
    testWidgets('render', (WidgetTester tester) async {
      final key = Key('screen');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
          ],
          child: MaterialApp(
            home: RefuelingAddEditScreen(
              key: key,
              isEditing: false,
              onSave: (a,b,c,d,e) {},
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
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
          ],
          child: MaterialApp(
            home: RefuelingAddEditScreen(
              key: key,
              isEditing: false,
              onSave: (a,b,c,d,e) {saved = true;},
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
      await tester.enterText(find.byType(CarForm), 'test');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(saved, true);
    });
    testWidgets('date button', (WidgetTester tester) async {
      final key = Key('screen');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
          ],
          child: MaterialApp(
            home: RefuelingAddEditScreen(
              key: key,
              isEditing: false,
              onSave: (a,b,c,d,e) {},
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