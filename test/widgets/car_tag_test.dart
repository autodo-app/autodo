import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/widgets/barrel.dart';

void main() {
  group('CarTag', () {
    Widget app;
    final key = Key('tag');
    setUp(() {
      app = MaterialApp(  
        home: Scaffold( 
          body: CarTag(
            key: key,
            color: Colors.blue,
            text: 'here'
          ),
        ),
      );
    });
    testWidgets('render', (tester) async {
      await tester.pumpWidget(app);

      expect(find.byKey(key), findsOneWidget);
    });
  });
}