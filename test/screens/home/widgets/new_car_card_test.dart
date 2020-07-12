import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/screens/home/widgets/barrel.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/units/units.dart';

class MockPaidVersionBloc extends MockBloc<PaidVersionEvent, PaidVersionState>
    implements PaidVersionBloc {}

class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

class MockDatabaseBloc extends MockBloc<DatabaseEvent, DatabaseState>
    implements DatabaseBloc {}

// ignore: must_be_immutable
class MockStorageRepo extends Mock implements StorageRepository {}

void main() {
  BasePrefService pref;
  final paidVersionBloc = MockPaidVersionBloc();
  whenListen(paidVersionBloc, Stream.fromIterable([PaidVersion()]));
  
  final snap = OdomSnapshot(date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0);
  final dataBloc = MockDataBloc();
  final car = Car(name: 'test', odomSnapshot: snap);
  when(dataBloc.state).thenReturn(DataLoaded(cars: [car]));

  final DatabaseBloc dbBloc = MockDatabaseBloc();
  final StorageRepository storageRepo = MockStorageRepo();
  final dbLoaded = DbLoaded(null, storageRepo: storageRepo);
  when(dbBloc.state).thenReturn(dbLoaded);

  setUp(() async {
    pref = PrefServiceCache();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'efficiency_unit': EfficiencyUnit.mpusg.index,
      'currency': 'USD',
    });
  });

  group('Car Card', () {
    testWidgets('render', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<PaidVersionBloc>.value(value: paidVersionBloc),
              BlocProvider<DataBloc>.value(value: dataBloc),
              BlocProvider<DatabaseBloc>.value(value: dbBloc),
            ],
            child: MaterialApp(
                home: Scaffold(
              body: NewCarCard(),
            )),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(NewCarCard), findsOneWidget);
    });
    testWidgets('tap', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<PaidVersionBloc>.value(value: paidVersionBloc),
              BlocProvider<DataBloc>.value(value: dataBloc),
              BlocProvider<DatabaseBloc>.value(value: dbBloc),
            ],
            child: MaterialApp(
                home: Scaffold(
              body: NewCarCard(),
            )),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(NewCarCard), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.pump();
      expect(find.byType(CarAddEditScreen), findsOneWidget);
    });
  });
}
