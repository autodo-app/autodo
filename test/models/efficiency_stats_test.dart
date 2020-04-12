import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/units/units.dart';

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState>
    implements RefuelingsBloc {}

void main() {
  BasePrefService pref;
  final refuelingsBloc = MockRefuelingsBloc();
  final refuelingsShort = [
    Refueling(
        carName: 'test',
        amount: 10.0,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        mileage: 1000,
        cost: 20.0),
    Refueling(
        carName: 'test',
        amount: 10.0,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        mileage: 2000,
        cost: 20.0),
  ];
  final refuelingsLong = List<Refueling>.from(refuelingsShort)
    ..add(Refueling(
        carName: 'test',
        amount: 10.0,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        mileage: 3000,
        cost: 20.0));


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

    testWidgets('short refuelings', (tester) async {
      whenListen(
        refuelingsBloc,
        Stream.fromIterable([
          RefuelingsLoading(),
          RefuelingsLoaded(refuelingsShort),
        ]));
      when(refuelingsBloc.state).thenReturn(RefuelingsLoaded(refuelingsShort));

      final _key = GlobalKey();
      await tester.pumpWidget(ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MaterialApp(
              home: Scaffold(
            key: _key,
            body: Container(),
          ))));
      await tester.pump();

      final data =
          await EfficiencyStats.fetch(refuelingsBloc, _key.currentContext);
      expect(data, []);
    });

    testWidgets('long refuelings', (tester) async {
      whenListen(
        refuelingsBloc,
        Stream.fromIterable([
          RefuelingsLoading(),
          RefuelingsLoaded(refuelingsLong),
        ]));
      when(refuelingsBloc.state).thenReturn(RefuelingsLoaded(refuelingsLong));

      final _key = GlobalKey();
      await tester.pumpWidget(ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MaterialApp(
              home: Scaffold(
            key: _key,
            body: Container(),
          ))));
      await tester.pump();

      final data =
          await EfficiencyStats.fetch(refuelingsBloc, _key.currentContext);
      final expectedRawData = [
        FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(0), 235.2145833333333),
        FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(0), 235.2145833333333),
      ];
      final expectedEmaData = [
        FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(0), 235.2145833333333),
        FuelMileagePoint(DateTime.fromMillisecondsSinceEpoch(0), 235.2145833333333),
      ];
      expect(data.length, 2);
      expect(data.first.data, expectedRawData);
      expect(data.last.data, expectedEmaData);
      expect(data.first.colorFn(0), charts.Color(r: 00, g: 0x7f, b: 00));
      expect(data.first.colorFn(1), charts.Color(r: 00, g: 0x7f, b: 00));
    });
  });
}
