import 'package:autodo/screens/settings/screen.dart';
import 'package:autodo/units/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

void main() {
  BasePrefService pref;

  setUp(() async {
    pref = JustCachePrefService();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('Settings Screen', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('display', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: PrefService(
            service: pref,
            child: MaterialApp(
              home: SettingsScreen(),
            ),
          ),
        ),
      );
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
