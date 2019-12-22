import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/widgets/barrel.dart';

void main() {
  group('AutoScrollField', () {
    final key = Key('field');
    final node = FocusNode();
    final child = TextFormField(focusNode: node);
    final controller = ScrollController();
    testWidgets('render properly', (tester) async {
      final app = MaterialApp(
        home: Scaffold(  
          body: ListView( 
            controller: controller,
            children : [
              Container(height: 100), // padding to allow the field to scroll
              AutoScrollField(  
                key: key,
                child: child,
                focusNode: node,
                position: 100.0,
                controller: controller,
              ),
              Container(height: 6000) // padding to allow the field to scroll
            ]
          )
        ),
      );
      await tester.pumpWidget(app);

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('scrolls to position', (tester) async {
      final app = MaterialApp(
        home: Scaffold(  
          body: ListView( 
            controller: controller,
            children : [
              Container(height: 100), // padding to allow the field to scroll
              AutoScrollField(  
                key: key,
                child: child,
                focusNode: node,
                position: 100.0,
                controller: controller,
              ),
              Container(height: 6000) // padding to allow the field to scroll
            ]
          )
        ),
      );
      await tester.pumpWidget(app);

      node.requestFocus();
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(controller.offset, 100.0);
    });

    testWidgets('scrolls properly without a set position', (tester) async {
      final app = MaterialApp(
        home: Scaffold(  
          body: ListView( 
            controller: controller,
            children : [
              Container(height: 100), // padding to allow the field to scroll
              AutoScrollField(  
                key: key,
                child: child,
                focusNode: node,
                controller: controller,
              ),
              Container(height: 6000) // padding to allow the field to scroll
            ]
          )
        ),
      );
      await tester.pumpWidget(app);

      node.requestFocus();
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      expect(controller.offset, 100.0);
    });
  });
}