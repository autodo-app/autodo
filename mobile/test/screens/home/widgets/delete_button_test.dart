import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/screens/home/widgets/delete_button.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

void main() {
  group('DeleteButton', () {
    testWidgets('renders', (WidgetTester tester) async {
      final todosKey = Key('todos');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteButton(key: todosKey, onDelete: () {}),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(todosKey), findsOneWidget);
    });
    testWidgets('press', (WidgetTester tester) async {
      final todosKey = Key('todos');
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteButton(
                key: todosKey,
                onDelete: () {
                  pressed = true;
                }),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(todosKey));
      await tester.pump();

      expect(pressed, true);
    });
  });
}
