// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:pref/pref.dart';
// import 'package:provider/provider.dart';

// import 'package:autodo/blocs/blocs.dart';
// import 'package:autodo/models/models.dart';
// import 'package:autodo/repositories/repositories.dart';
// import 'package:autodo/screens/home/views/barrel.dart';
// import 'package:autodo/units/units.dart';

// class MockPaidVersionBloc extends MockBloc<PaidVersionEvent, PaidVersionState>
//     implements PaidVersionBloc {}

// class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

// class MockDatabaseBloc extends MockBloc<DatabaseEvent, DatabaseState>
//     implements DatabaseBloc {}

// // ignore: must_be_immutable
// class MockStorageRepo extends Mock implements StorageRepository {}

// void main() {
//   BasePrefService pref;
//   final paidVersionBloc = MockPaidVersionBloc();
//   whenListen(paidVersionBloc, Stream.fromIterable([PaidVersion()]));

//   final dataBloc = MockDataBloc();
//   final dataState = DataLoaded(cars: [
//     Car(
//         name: 'test',
//         odomSnapshot: OdomSnapshot(
//             date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0))
//   ]);
//   when(dataBloc.state).thenReturn(dataState);

//   final DatabaseBloc dbBloc = MockDatabaseBloc();
//   final StorageRepository storageRepo = MockStorageRepo();
//   final dbLoaded = DbLoaded(null, storageRepo: storageRepo);
//   when(dbBloc.state).thenReturn(dbLoaded);

//   setUp(() async {
//     pref = PrefServiceCache();
//     await pref.setDefaultValues({
//       'length_unit': DistanceUnit.imperial.index,
//       'volume_unit': VolumeUnit.us.index,
//       'efficiency_unit': EfficiencyUnit.mpusg.index,
//       'currency': 'USD',
//     });
//   });

//   group('Garage Screen', () {
//     group('render', () {
//       testWidgets('no paid version avail', (tester) async {
//         await tester.pumpWidget(
//           ChangeNotifierProvider<BasePrefService>.value(
//             value: pref,
//             child: MultiBlocProvider(
//               providers: [
//                 BlocProvider<PaidVersionBloc>.value(value: paidVersionBloc),
//                 BlocProvider<DataBloc>.value(value: dataBloc),
//                 BlocProvider<DatabaseBloc>.value(value: dbBloc),
//               ],
//               child: MaterialApp(
//                   home: Scaffold(
//                 body: GarageScreen(),
//               )),
//             ),
//           ),
//         );
//         await tester.pump();
//         expect(find.byType(GarageScreen), findsOneWidget);
//       });

//       testWidgets('pro version', (tester) async {
//         when(paidVersionBloc.state).thenReturn(PaidVersion());
//         await tester.pumpWidget(
//           ChangeNotifierProvider<BasePrefService>.value(
//             value: pref,
//             child: MultiBlocProvider(
//               providers: [
//                 BlocProvider<PaidVersionBloc>.value(value: paidVersionBloc),
//                 BlocProvider<DataBloc>.value(value: dataBloc),
//                 BlocProvider<DatabaseBloc>.value(value: dbBloc),
//               ],
//               child: MaterialApp(
//                   home: Scaffold(
//                 body: GarageScreen(),
//               )),
//             ),
//           ),
//         );
//         await tester.pump();
//         expect(find.byType(GarageScreen), findsOneWidget);
//       });

//       testWidgets('paid version avail', (tester) async {
//         when(paidVersionBloc.state).thenReturn(BasicVersion());
//         await tester.pumpWidget(
//           ChangeNotifierProvider<BasePrefService>.value(
//             value: pref,
//             child: MultiBlocProvider(
//               providers: [
//                 BlocProvider<PaidVersionBloc>.value(value: paidVersionBloc),
//                 BlocProvider<DataBloc>.value(value: dataBloc),
//                 BlocProvider<DatabaseBloc>.value(value: dbBloc),
//               ],
//               child: MaterialApp(
//                   home: Scaffold(
//                 body: GarageScreen(),
//               )),
//             ),
//           ),
//         );
//         await tester.pump();
//         expect(find.byType(GarageScreen), findsOneWidget);
//       });
//     });
//   });
// }
void main() {}
