import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/screens/welcome/screen.dart';
import 'package:autodo/screens/welcome/widgets/scroller/tutorial1.dart';
import 'package:autodo/screens/welcome/widgets/scroller/tutorial2.dart';

void main() {
  group('WelcomeScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        // MultiBlocProvider(
          // providers: [],
          MaterialApp(home: WelcomeScreen(key: scaffoldKey)),
        // ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(scaffoldKey), findsOneWidget);
    });
    testWidgets('tap page indicator', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      List<Key> dotKeys = [Key('dot1'), Key('dot2'), Key('dot3')];
      await tester.pumpWidget(
        // MultiBlocProvider(
        //   providers: [],
          MaterialApp(
              home: WelcomeScreen(
            key: scaffoldKey,
            dotKeys: dotKeys,
          )),
        // ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(dotKeys[1]));
      await tester.pumpAndSettle();
      expect(find.byType(Tutorial1), findsOneWidget);
    });
    testWidgets('show tutorial2', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      List<Key> dotKeys = [Key('dot1'), Key('dot2'), Key('dot3')];
      await tester.pumpWidget(
        // MultiBlocProvider(
          // providers: [],
          MaterialApp(
              home: WelcomeScreen(
            key: scaffoldKey,
            dotKeys: dotKeys,
          )),
        // ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(dotKeys[2]));
      await tester.pumpAndSettle();
      expect(find.byType(Tutorial2), findsOneWidget);
    });
  });
}
