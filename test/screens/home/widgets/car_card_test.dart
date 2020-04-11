import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:image_test_utils/image_test_utils.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/screens/home/widgets/barrel.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/units/units.dart';

class MockPaidVersionBloc extends MockBloc<PaidVersionEvent, PaidVersionState> implements PaidVersionBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

class MockDatabaseBloc extends MockBloc<DatabaseEvent, DatabaseState>
    implements DatabaseBloc {}

class MockStorageRepo extends Mock implements StorageRepository {} // ignore: must_be_immutable

void main() {
  BasePrefService pref;
  final paidVersionBloc = MockPaidVersionBloc();
  whenListen(paidVersionBloc, Stream.fromIterable([PaidVersion()]));
  final carsBloc = MockCarsBloc();
  final carsState = CarsLoaded([Car(name: 'test')]);
  whenListen(carsBloc, Stream.fromIterable([carsState]));
  when(carsBloc.state).thenReturn(carsState);
  final DatabaseBloc dbBloc = MockDatabaseBloc();
  final StorageRepository storageRepo = MockStorageRepo();
  final dbLoaded = DbLoaded(null, storageRepo: storageRepo);
  when(dbBloc.state).thenReturn(dbLoaded);

  setUp(() async {
    pref = JustCachePrefService();
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
              BlocProvider<CarsBloc>.value(value: carsBloc),
              BlocProvider<DatabaseBloc>.value(value: dbBloc),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: CarCard(Car(name: 'test')),
              )
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(CarCard), findsOneWidget);
    });
    testWidgets('tap', (tester) async {
      when(storageRepo.getDownloadUrl(any)).thenAnswer((_) async => '');
      await provideMockedNetworkImages(() async {
        await tester.pumpWidget(
          ChangeNotifierProvider<BasePrefService>.value(
            value: pref,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<PaidVersionBloc>.value(value: paidVersionBloc),
                BlocProvider<CarsBloc>.value(value: carsBloc),
                BlocProvider<DatabaseBloc>.value(value: dbBloc),
              ],
              child: MaterialApp(
                home: Scaffold(
                  body: CarCard(Car(name: 'test')),
                )
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(CarCard), findsOneWidget);

        await tester.tap(find.byType(Card));
        await tester.pump();
        await tester.pump();
        expect(find.byType(CarAddEditScreen), findsOneWidget);
      });
    });
  });
}