import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('DeleteTodoSnackBar', () {
    testWidgets('should render properly', (WidgetTester tester) async {
      final snackBarKey = Key('snack_bar_key');
      final tapTarget = Key('tap_target_key');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
                  context: context,
                  key: snackBarKey,
                  onUndo: () {},
                  todo: Todo(name: 'test'),
                ));
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 100.0,
                width: 100.0,
                key: tapTarget,
              ),
            );
          }),
        ),
      ));
      await tester.tap(find.byKey(tapTarget));
      await tester.pump();

      final Finder snackBarFinder = find.byKey(snackBarKey);

      expect(snackBarFinder, findsOneWidget);
      expect(
        ((snackBarFinder.evaluate().first.widget as SnackBar).content as Text)
            .data,
        IntlKeys.todoDeleted,
      );
      expect(find.text(IntlKeys.undo), findsOneWidget);
    });

    testWidgets('should call onUndo when undo tapped',
        (WidgetTester tester) async {
      int tapCount = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
                  context: context,
                  onUndo: () {
                    ++tapCount;
                  },
                  todo: Todo(name: 'test'),
                ));
              },
              child: const Text('X'),
            );
          }),
        ),
      ));
      await tester.tap(find.text('X'));
      await tester.pump(); // start animation
      await tester.pump(const Duration(milliseconds: 750));

      expect(tapCount, equals(0));
      await tester.tap(find.text(IntlKeys.undo));
      expect(tapCount, equals(1));
    });
  });

  group('DeleteRefuelingSnackBar', () {
    testWidgets('should render properly', (WidgetTester tester) async {
      final snackBarKey = Key('snack_bar_key');
      final tapTarget = Key('tap_target_key');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showSnackBar(DeleteRefuelingSnackBar(
                  context: context,
                  key: snackBarKey,
                  onUndo: () {},
                ));
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 100.0,
                width: 100.0,
                key: tapTarget,
              ),
            );
          }),
        ),
      ));
      await tester.tap(find.byKey(tapTarget));
      await tester.pump();

      final Finder snackBarFinder = find.byKey(snackBarKey);

      expect(snackBarFinder, findsOneWidget);
      expect(find.text(IntlKeys.undo), findsOneWidget);
    });

    testWidgets('should call onUndo when undo tapped',
        (WidgetTester tester) async {
      int tapCount = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showSnackBar(DeleteRefuelingSnackBar(
                  context: context,
                  onUndo: () {
                    ++tapCount;
                  },
                ));
              },
              child: const Text('X'),
            );
          }),
        ),
      ));
      await tester.tap(find.text('X'));
      await tester.pump(); // start animation
      await tester.pump(const Duration(milliseconds: 750));

      expect(tapCount, equals(0));
      await tester.tap(find.text(IntlKeys.undo));
      expect(tapCount, equals(1));
    });
  });
  group('DeleteRepeatSnackBar', () {
    testWidgets('should render properly', (WidgetTester tester) async {
      final snackBarKey = Key('snack_bar_key');
      final tapTarget = Key('tap_target_key');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showSnackBar(DeleteRepeatSnackBar(
                  context: context,
                  key: snackBarKey,
                  onUndo: () {},
                ));
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 100.0,
                width: 100.0,
                key: tapTarget,
              ),
            );
          }),
        ),
      ));
      await tester.tap(find.byKey(tapTarget));
      await tester.pump();

      final Finder snackBarFinder = find.byKey(snackBarKey);

      expect(snackBarFinder, findsOneWidget);
      expect(find.text(IntlKeys.undo), findsOneWidget);
    });

    testWidgets('should call onUndo when undo tapped',
        (WidgetTester tester) async {
      int tapCount = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showSnackBar(DeleteRepeatSnackBar(
                  context: context,
                  onUndo: () {
                    ++tapCount;
                  },
                ));
              },
              child: const Text('X'),
            );
          }),
        ),
      ));
      await tester.tap(find.text('X'));
      await tester.pump(); // start animation
      await tester.pump(const Duration(milliseconds: 750));

      expect(tapCount, equals(0));
      await tester.tap(find.text(IntlKeys.undo));
      expect(tapCount, equals(1));
    });
  });
}
