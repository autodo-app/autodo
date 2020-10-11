// import 'package:autodo/screens/settings/screen.dart';
// import 'package:autodo/units/units.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:pref/pref.dart';
// import 'package:provider/provider.dart';

// void main() {
//   BasePrefService pref;

//   setUp(() async {
//     pref = PrefServiceCache();
//     await pref.setDefaultValues({
//       'length_unit': DistanceUnit.imperial.index,
//       'volume_unit': VolumeUnit.us.index,
//       'currency': 'USD',
//     });
//   });

//   group('Settings Screen', () {
//     TestWidgetsFlutterBinding.ensureInitialized();

//     testWidgets('display', (tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: PrefService(
//             service: pref,
//             child: MaterialApp(
//               home: SettingsScreen(),
//             ),
//           ),
//         ),
//       );
//       expect(find.byType(SettingsScreen), findsOneWidget);
//     });

//     testWidgets('delete account dialog render', (tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: PrefService(
//             service: pref,
//             child: MaterialApp(
//               home: SettingsScreen(),
//             ),
//           ),
//         ),
//       );
//       expect(find.byType(SettingsScreen), findsOneWidget);
//       await tester.tap(find.byKey(ValueKey('__delete_account_button__')));
//       await tester.pumpAndSettle();
//       expect(find.byType(Dialog), findsOneWidget);
//     });
//   });
// }
void main() {}
