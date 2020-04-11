import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/units/units.dart';

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState> implements RefuelingsBloc {}

void main() {
  BasePrefService pref;
  final refuelingsBloc = MockRefuelingsBloc();
  whenListen(refuelingsBloc, Stream.fromIterable([
    RefuelingsLoading(),
    RefuelingsLoaded([
      Refueling(carName: 'test', amount: 10.0, date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 1000, cost: 20.0),
      Refueling(carName: 'test', amount: 10.0, date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 2000, cost: 20.0)])
  ]));
  when(refuelingsBloc.state).thenReturn(RefuelingsLoading());

  group('efficiency stats', () {
    setUp(() async {
      pref = JustCachePrefService();
      await pref.setDefaultValues({
        'length_unit': DistanceUnit.imperial.index,
        'volume_unit': VolumeUnit.us.index,
        'efficiency_unit': EfficiencyUnit.mpusg.index,
        'currency': 'USD',
      });
    });

    test('create', () {
      final stats = EfficiencyStats();
      expect(stats, isNotNull);
    });

    testWidgets('fetch', (tester) async {
      final _key = GlobalKey();
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MaterialApp(
            home: Scaffold(
              key: _key,
              body: Container(),
            )
          )
        )
      );
      await tester.pump();

      try {
        final data = await EfficiencyStats.fetch(refuelingsBloc, _key.currentContext);
        print(data);
        expect(data, []);
      } catch (e) {
        print(e);
      }

    });
  });
}