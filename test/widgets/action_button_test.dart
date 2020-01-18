import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/widgets/widgets.dart';

void main() {
  group('ActionButton', () {
    testWidgets('should render properly', (tester) async {
      var buttonKey = Key('button_key');
      var mainKey = Key('main_key');
      var miniKeys = [Key('refueling_key'), Key('todo_key'), Key('repeat_key')];
      Widget home = Scaffold(
          floatingActionButton: Builder(
        builder: (BuildContext context) => AutodoActionButton(
          key: buttonKey,
          mainButtonKey: mainKey,
          miniButtonKeys: miniKeys,
        ),
      ));
      Widget app = MaterialApp(
        home: home,
      );
      await tester.pumpWidget(app);
      Finder buttonFinder = find.byKey(buttonKey);

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
