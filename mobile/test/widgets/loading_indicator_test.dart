import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/widgets/widgets.dart';

void main() {
  group('LoadingIndicator', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      final loadingIndicatorKey = Key('loading_indicator_key');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(key: loadingIndicatorKey),
          ),
        ),
      );
      expect(find.byKey(loadingIndicatorKey), findsOneWidget);
    });
  });
}
