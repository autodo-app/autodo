import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/widgets/widgets.dart';

void main() {
  group('ActionButton', () {
    testWidgets('should render properly', (tester) async {
      var buttonKey = Key('button_key');
      var mainKey = Key('main_key');
      var miniKeys = [Key('refueling_key'), Key('todo_key'), Key('repeat_key')];
      int navCount = 0;
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
        onUnknownRoute: (_) {
          navCount++;
          return MaterialPageRoute(
              builder: (context) => home, // effectively do nothing
              settings: RouteSettings(name: '/'));
        },
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
      expect(navCount, 1);

      await tester.tap(find.byKey(mainKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 10));
      expect(find.byKey(mainKey), findsOneWidget);
    });
    // testWidgets('should call onUndo when undo tapped',
    //     (WidgetTester tester) async {
    //   int tapCount = 0;
    //   await tester.pumpWidget(MaterialApp(
    //     home: Scaffold(
    //       body: Builder(builder: (BuildContext context) {
    //         return GestureDetector(
    //           onTap: () {
    //             Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
    //               onUndo: () {
    //                 ++tapCount;
    //               },
    //               localizations: ArchSampleLocalizations(Locale('en')),
    //               todo: Todo('take out trash'),
    //             ));
    //           },
    //           child: const Text('X'),
    //         );
    //       }),
    //     ),
    //   ));
    //   await tester.tap(find.text('X'));
    //   await tester.pump(); // start animation
    //   await tester.pump(const Duration(milliseconds: 750));

    //   expect(tapCount, equals(0));
    //   await tester.tap(find.text('Undo'));
    //   expect(tapCount, equals(1));
    // });
  });
}
