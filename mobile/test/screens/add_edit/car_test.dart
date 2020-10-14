// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:pref/pref.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:image_test_utils/image_test_utils.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// import 'package:autodo/blocs/blocs.dart';
// import 'package:autodo/repositories/repositories.dart';
// import 'package:autodo/screens/add_edit/barrel.dart';
// import 'package:autodo/units/units.dart';
// import 'package:autodo/models/models.dart';

// class MockDatabaseBloc extends MockBloc<DatabaseEvent, DatabaseState>
//     implements DatabaseBloc {}

// class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

// // ignore: must_be_immutable
// class MockStorageRepo extends Mock implements StorageRepository {}

// void main() {
//   group('AddEditCarScreen', () {
//     BasePrefService pref;
//     final DatabaseBloc dbBloc = MockDatabaseBloc();
//     final DataBloc dataBloc = MockDataBloc();
//     final StorageRepository storageRepo = MockStorageRepo();
//     when(dbBloc.state).thenReturn(DbLoaded(null, storageRepo: storageRepo));

//     setUp(() async {
//       pref = PrefServiceCache();
//       await pref.setDefaultValues({
//         'length_unit': DistanceUnit.imperial.index,
//         'volume_unit': VolumeUnit.us.index,
//         'efficiency_unit': EfficiencyUnit.mpusg.index,
//         'currency': 'USD',
//       });
//     });

//     testWidgets('render - add', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MaterialApp(
//             home: Scaffold(
//               body: CarAddEditScreen(onSave: (a, b, c, d, e, f, g) {}),
//             ),
//           ),
//         ),
//       );
//       await tester.pump();
//       expect(find.byType(CarAddEditScreen), findsOneWidget);
//     });

//     testWidgets('render - details', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(
//             providers: [
//               BlocProvider<DatabaseBloc>.value(value: dbBloc),
//               BlocProvider<DataBloc>.value(value: dataBloc),
//             ],
//             child: MaterialApp(
//               home: Scaffold(
//                 body: CarAddEditScreen(
//                     car: Car(name: 'test', odomSnapshot: null),
//                     onSave: (a, b, c, d, e, f, g) {}),
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pump();
//       expect(find.byType(CarAddEditScreen), findsOneWidget);
//     });

//     testWidgets('render - editing', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(
//             providers: [
//               BlocProvider<DatabaseBloc>.value(value: dbBloc),
//               BlocProvider<DataBloc>.value(value: dataBloc),
//             ],
//             child: MaterialApp(
//               home: Scaffold(
//                 body: CarAddEditScreen(
//                     car: Car(name: 'test', odomSnapshot: null),
//                     isEditing: true,
//                     onSave: (a, b, c, d, e, f, g) {}),
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pump();
//       expect(find.byType(CarAddEditScreen), findsOneWidget);
//     });

//     group('headers', () {
//       testWidgets('render', (WidgetTester tester) async {
//         await tester.pumpWidget(
//           ChangeNotifierProvider<BasePrefService>.value(
//             value: pref,
//             child: MultiBlocProvider(
//               providers: [
//                 BlocProvider<DatabaseBloc>.value(value: dbBloc),
//                 BlocProvider<DataBloc>.value(value: dataBloc),
//               ],
//               child: MaterialApp(
//                 home: Scaffold(
//                   body: CarAddEditHeaderNoImage(
//                     car: Car(name: 'test', odomSnapshot: null),
//                     onSaved: (_) {},
//                     imagePicker: ({source}) async => File('test.jpg'),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//         await tester.pump();
//         expect(find.byType(CarAddEditHeaderNoImage), findsOneWidget);
//       });
//       testWidgets('pick image', (WidgetTester tester) async {
//         var stored = false;
//         when(storageRepo.storeAsset(any)).thenAnswer((_) async {
//           stored = true;
//         });
//         await tester.pumpWidget(
//           ChangeNotifierProvider<BasePrefService>.value(
//             value: pref,
//             child: MultiBlocProvider(
//               providers: [
//                 BlocProvider<DatabaseBloc>.value(value: dbBloc),
//                 BlocProvider<DataBloc>.value(value: dataBloc),
//               ],
//               child: MaterialApp(
//                 home: Scaffold(
//                   body: CarAddEditHeaderNoImage(
//                     car: Car(name: 'test', odomSnapshot: null),
//                     onSaved: (_) {},
//                     imagePicker: ({source}) async => File('test.jpg'),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//         await tester.pump();
//         expect(find.byType(CarAddEditHeaderNoImage), findsOneWidget);
//         await tester.tap(find.byIcon(Icons.camera_alt));
//         await tester.pumpAndSettle();
//         expect(stored, true);
//       });
//       testWidgets('filtered image render', (WidgetTester tester) async {
//         when(storageRepo.getDownloadUrl(any)).thenAnswer((_) async => '');
//         await provideMockedNetworkImages(() async {
//           await tester.pumpWidget(
//             ChangeNotifierProvider<BasePrefService>.value(
//               value: pref,
//               child: MultiBlocProvider(
//                 providers: [
//                   BlocProvider<DatabaseBloc>.value(value: dbBloc),
//                   BlocProvider<DataBloc>.value(value: dataBloc),
//                 ],
//                 child: MaterialApp(
//                   home: Scaffold(
//                     body: CarAddEditScreen(
//                         car: Car(name: 'test', odomSnapshot: null),
//                         onSave: (a, b, c, d, e, f, g) {}),
//                   ),
//                 ),
//               ),
//             ),
//           );
//           await tester.pump();
//           expect(find.byType(CarAddEditScreen), findsOneWidget);
//           expect(find.byType(CachedNetworkImage), findsOneWidget);
//         });
//       });
//       testWidgets('switch to edit', (WidgetTester tester) async {
//         when(storageRepo.getDownloadUrl(any)).thenAnswer((_) async => '');
//         final key = GlobalKey<CarAddEditScreenState>();
//         await provideMockedNetworkImages(() async {
//           // Starting in details mode
//           await tester.pumpWidget(
//             ChangeNotifierProvider<BasePrefService>.value(
//               value: pref,
//               child: MultiBlocProvider(
//                 providers: [
//                   BlocProvider<DatabaseBloc>.value(value: dbBloc),
//                   BlocProvider<DataBloc>.value(value: dataBloc),
//                 ],
//                 child: MaterialApp(
//                   home: Scaffold(
//                     body: CarAddEditScreen(
//                         key: key,
//                         car: Car(name: 'test', odomSnapshot: null),
//                         onSave: (a, b, c, d, e, f, g) {}),
//                   ),
//                 ),
//               ),
//             ),
//           );
//           await tester.pump();
//           expect(find.byType(CarAddEditScreen), findsOneWidget);
//           expect(key.currentState.mode, CarDetailsMode.DETAILS);

//           await tester.tap(find.byIcon(Icons.edit));
//           await tester.pump();
//           expect(key.currentState.mode, CarDetailsMode.EDIT);
//         });
//       });
//     });

//     testWidgets('save', (WidgetTester tester) async {
//       var saved = false;
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MaterialApp(
//             home: Scaffold(
//               body: CarAddEditScreen(onSave: (a, b, c, d, e, f, g) {
//                 saved = true;
//               }),
//             ),
//           ),
//         ),
//       );
//       await tester.pump();
//       expect(find.byType(CarAddEditScreen), findsOneWidget);

//       for (var field in find.byType(TextFormField).evaluate()) {
//         await tester.enterText(find.byWidget(field.widget), '10');
//       }

//       await tester.tap(find.byType(FloatingActionButton));
//       await tester.pump();
//       expect(saved, true);
//     });
//   });
// }
void main() {}
