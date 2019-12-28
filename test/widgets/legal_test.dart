import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:autodo/widgets/widgets.dart';

void main() {
  group('LegalWidget', () {
    testWidgets('render', (tester) async {
      final scaffold = GlobalKey<ScaffoldState>();
      final policy = Key('policy');
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(key: scaffold, body: Container())));
      showDialog(
        context: scaffold.currentContext,
        builder: (context) =>
            PrivacyPolicy(RichText(text: TextSpan(text: 'test')), key: policy),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(policy), findsOneWidget);
    });
    testWidgets('button', (tester) async {
      final scaffold = GlobalKey<ScaffoldState>();
      final policy = Key('policy');
      final button = Key('button');
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(key: scaffold, body: Container())));
      showDialog(
        context: scaffold.currentContext,
        builder: (context) => PrivacyPolicy(
          RichText(text: TextSpan(text: 'test')),
          key: policy,
          buttonKey: button,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(policy), findsOneWidget);

      await tester.tap(find.byKey(button));
      await tester.pumpAndSettle();
      expect(find.byKey(policy), findsNothing);
    });
  });
}
