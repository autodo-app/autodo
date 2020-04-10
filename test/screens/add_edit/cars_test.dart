import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

import 'package:autodo/units/units.dart';

class MockCarsBloc extends Mock implements CarsBloc {}

void main() {
  group('AddEditCarScreen', () {
    BasePrefService pref;
    setUp(() async {
      pref = JustCachePrefService();
      await pref.setDefaultValues({
        'length_unit': DistanceUnit.imperial.index,
        'volume_unit': VolumeUnit.us.index,
        'currency': 'USD',
      });
    });
    testWidgets('render', (WidgetTester tester) async {
      await tester.pumpWidget(
        // MultiBlocProvider(
        //   providers: [],
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MaterialApp(
            home: Scaffold(
              body: CarAddEditScreen(onSave: (a, b, c, d, e, f, g) {}),
            ),
          ),
        ),
        // ),
      );
      await tester.pump();
      expect(find.byType(CarAddEditScreen), findsOneWidget);
    });
  });
}
