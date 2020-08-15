import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/home/views/refuelings.dart';
import 'package:autodo/screens/home/widgets/refueling_card.dart';
import 'package:autodo/units/units.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

class MockFilteredRefuelingsBloc
    extends MockBloc<FilteredRefuelingsLoaded, FilteredRefuelingsState>
    implements FilteredRefuelingsBloc {}

void main() {
  FilteredRefuelingsBloc filteredRefuelingsBloc;
  DataBloc dataBloc;
  BasePrefService pref;

  setUp(() async {
    filteredRefuelingsBloc = MockFilteredRefuelingsBloc();
    dataBloc = MockDataBloc();
    pref = PrefServiceCache();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('RefuelingsScreen', () {
    testWidgets('not loaded', (WidgetTester tester) async {
      when(filteredRefuelingsBloc.state)
          .thenAnswer((_) => FilteredRefuelingsNotLoaded());
      final refuelingsKey = Key('refuelings');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<DataBloc>.value(value: dataBloc),
            BlocProvider<FilteredRefuelingsBloc>.value(
              value: filteredRefuelingsBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: RefuelingsScreen(key: refuelingsKey),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(refuelingsKey), findsOneWidget);
    });
    testWidgets('load', (WidgetTester tester) async {
      final snap = OdomSnapshot(
          car: 'test',
          mileage: 1000,
          date: DateTime.fromMillisecondsSinceEpoch(0));
      final refueling = Refueling(
        amount: 10.0,
        cost: 10.0,
        odomSnapshot: snap,
      );
      when(filteredRefuelingsBloc.state).thenAnswer((_) =>
          FilteredRefuelingsLoaded([refueling], VisibilityFilter.all,
              [Car(name: 'test', odomSnapshot: snap)]));
      when(dataBloc.state).thenReturn(
          DataLoaded(cars: [Car(name: 'test', odomSnapshot: snap)]));
      final refuelingsKey = Key('refuelings');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DataBloc>.value(value: dataBloc),
              BlocProvider<FilteredRefuelingsBloc>.value(
                value: filteredRefuelingsBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RefuelingsScreen(key: refuelingsKey),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RefuelingCard), findsOneWidget);
    });
  });
}
