import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/widgets/widgets.dart';

void main() {
  group('ActionButton', () {
    testWidgets('should render properly', (tester) async {
      final buttonKey = Key('button_key');
      final mainKey = Key('main_key');
      final miniKeys = [
        Key('refueling_key'),
        Key('todo_key'),
        Key('repeat_key')
      ];
      final Widget home = Scaffold(
          floatingActionButton: Builder(
        builder: (BuildContext context) => AutodoActionButton(
          key: buttonKey,
          mainButtonKey: mainKey,
          miniButtonKeys: miniKeys,
        ),
      ));
      final Widget app = MaterialApp(
        home: home,
      );
      await tester.pumpWidget(app);
      final buttonFinder = find.byKey(buttonKey);

      expect(buttonFinder, findsOneWidget);

      // open the button
      await tester.tap(find.byKey(mainKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 10));
      expect(find.byType(FloatingActionButton), findsNWidgets(4));

      // press the mini buttons
      await tester.tap(find.byKey(miniKeys[2]));
      await tester.pump();
      // expect(navCount, 1);
      // currently doing nothing on button press

      await tester.tap(find.byKey(mainKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 10));
      expect(find.byKey(mainKey), findsOneWidget);
    });
  });
}
