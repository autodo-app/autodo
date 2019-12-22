import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/widgets/barrel.dart';

void main() {
  group('AutoScrollField', () {
    final key = Key('field');
    final node = FocusNode();
    final child = TextFormField(focusNode: node);
    final position = 100.0;
    final controller = ScrollController();
    Widget app;

    setUp(() {
      app = MaterialApp(
        home: Scaffold(  
          body: ListView( 
            controller: controller,
            children : [
              Container(height: 100), // padding to allow the field to scroll
              AutoScrollField(  
                key: key,
                child: child,
                focusNode: node,
                position: position,
                controller: controller,
              ),
              Container(height: 6000) // padding to allow the field to scroll
            ]
          )
        ),
      );
    });

    testWidgets('render properly', (tester) async {
      await tester.pumpWidget(app);

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('scrolls properly', (tester) async {
      await tester.pumpWidget(app);

      node.requestFocus();
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(controller.offset, position);
    });
  });
}