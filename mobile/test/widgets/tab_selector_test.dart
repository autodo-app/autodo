import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('TabSelector', () {
    testWidgets('should render properly', (WidgetTester tester) async {
      final todosTabKey = Key('todosTab');
      final refuelingsTabKey = Key('refuelingsTab');
      final statsTabKey = Key('statsTab');
      final garageTabKey = Key('garageTab');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: TabSelector(
              onTabSelected: (_) => null,
              activeTab: AppTab.todos,
              todosTabKey: todosTabKey,
              refuelingsTabKey: refuelingsTabKey,
              statsTabKey: statsTabKey,
              garageTabKey: garageTabKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(todosTabKey), findsOneWidget);
      expect(find.byKey(refuelingsTabKey), findsOneWidget);
      expect(find.byKey(statsTabKey), findsOneWidget);
      expect(find.byKey(garageTabKey), findsOneWidget);
    });

    testWidgets('should call onTabSelected with correct index when tab tapped',
        (WidgetTester tester) async {
      AppTab selectedTab;
      final todosTabKey = Key('todosTab');
      final refuelingsTabKey = Key('refuelingsTab');
      final statsTabKey = Key('statsTab');
      final garageTabKey = Key('garageTab');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: TabSelector(
              onTabSelected: (appTab) {
                selectedTab = appTab;
              },
              activeTab: AppTab.todos,
              todosTabKey: todosTabKey,
              refuelingsTabKey: refuelingsTabKey,
              statsTabKey: statsTabKey,
              garageTabKey: garageTabKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final todoTabFinder = find.byKey(todosTabKey);
      final refuelingTabFinder = find.byKey(refuelingsTabKey);
      final statsTabFinder = find.byKey(statsTabKey);
      final garageTabFinder = find.byKey(garageTabKey);
      expect(todoTabFinder, findsOneWidget);
      expect(statsTabFinder, findsOneWidget);
      await tester.tap(todoTabFinder);
      expect(selectedTab, AppTab.todos);
      await tester.tap(refuelingTabFinder);
      expect(selectedTab, AppTab.refuelings);
      await tester.tap(statsTabFinder);
      expect(selectedTab, AppTab.stats);
      await tester.tap(garageTabFinder);
      expect(selectedTab, AppTab.garage);
    });
  });
}
