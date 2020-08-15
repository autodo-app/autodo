import 'package:autodo/widgets/src/upgrade_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';
import 'package:autodo/units/units.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  BasePrefService pref;

  setUp(() async {
    pref = PrefServiceCache();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('Upgrade Dialog', () {
    testWidgets('render - no trial', (tester) async {
      final key = GlobalKey<ScaffoldState>();
      await tester.pumpWidget(ChangeNotifierProvider<BasePrefService>.value(
        value: pref,
        child: MaterialApp(
            home: Scaffold(
              key: key,
              body: GestureDetector(
                onTap: () {
                  showDialog(
                      context: key.currentContext,
                      builder: (context) => UpgradeDialog(
                            context: context,
                            trialUser: false,
                          ));
                },
              ),
            ),
            locale: Locale('en')),
      ));
      await tester.pump();
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(find.byType(UpgradeDialog), findsOneWidget);
    });
    testWidgets('render - trial', (tester) async {
      final key = GlobalKey<ScaffoldState>();
      await tester.pumpWidget(ChangeNotifierProvider<BasePrefService>.value(
        value: pref,
        child: MaterialApp(
            home: Scaffold(
              key: key,
              body: GestureDetector(
                onTap: () {
                  showDialog(
                      context: key.currentContext,
                      builder: (context) => UpgradeDialog(
                            context: context,
                            trialUser: true,
                          ));
                },
              ),
            ),
            locale: Locale('en')),
      ));
      await tester.pump();
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(find.byType(UpgradeDialog), findsOneWidget);
    });
  });
}
