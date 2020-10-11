// import 'package:autodo/generated/localization.dart';
// import 'package:autodo/repositories/repositories.dart';
// import 'package:autodo/units/units.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:mockito/mockito.dart';

// import 'package:autodo/blocs/blocs.dart';
// import 'package:autodo/models/models.dart';
// import 'package:autodo/screens/welcome/views/new_user_setup/screen.dart';
// import 'package:autodo/screens/welcome/views/new_user_setup/latestcompleted.dart';
// import 'package:autodo/screens/welcome/views/new_user_setup/setrepeats.dart';
// import 'package:pref/pref.dart';
// import 'package:provider/provider.dart';

// class MockAuthenticationBloc
//     extends MockBloc<AuthenticationEvent, AuthenticationState>
//     implements AuthenticationBloc {}

// class MockDatabaseBloc extends MockBloc<DatabaseEvent, DatabaseState>
//     implements DatabaseBloc {}

// class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

// // ignore: must_be_immutable
// class MockRepo extends Mock implements DataRepository {}

// void main() {
//   BasePrefService pref;
//   final dataLoaded = DataLoaded(todos: [
//     Todo(name: 'oil', mileageRepeatInterval: 3500),
//     Todo(name: 'tire_rotation', mileageRepeatInterval: 7500)
//   ], cars: [
//     Car(name: 'test', odomSnapshot: null)
//   ]);

//   setUp(() async {
//     pref = PrefServiceCache();
//     await pref.setDefaultValues({
//       'length_unit': DistanceUnit.imperial.index,
//       'volume_unit': VolumeUnit.us.index,
//       'currency': 'USD',
//     });
//   });

//   group('new user screens', () {
//     TestWidgetsFlutterBinding.ensureInitialized();
//     final authBloc = MockAuthenticationBloc();
//     whenListen(authBloc, Stream.fromIterable([RemoteAuthenticated('', '')]));
//     when(authBloc.state).thenReturn(RemoteAuthenticated('', ''));
//     final dbBloc = MockDatabaseBloc();
//     when(dbBloc.state).thenReturn(DbLoaded(MockRepo()));
//     testWidgets('mileage', (tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(providers: [
//             BlocProvider<AuthenticationBloc>.value(value: authBloc),
//             BlocProvider<DatabaseBloc>.value(value: dbBloc)
//           ], child: MaterialApp(home: NewUserScreen())),
//         ),
//       );
//       expect(find.byType(NewUserScreen), findsOneWidget);
//     });
//     testWidgets('Latest complete', (tester) async {
//       final dataBloc = MockDataBloc();
//       when(dataBloc.state).thenReturn(
//           DataLoaded(todos: [Todo(name: 'Oil'), Todo(name: 'Tire Rotation')]));
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(
//               providers: [
//                 BlocProvider<AuthenticationBloc>.value(value: authBloc),
//                 BlocProvider<DatabaseBloc>.value(value: dbBloc),
//                 BlocProvider<DataBloc>.value(value: dataBloc),
//               ],
//               child: MaterialApp(
//                 home: NewUserScreen(),
//                 locale: Locale('en'),
//               )),
//         ),
//       );
//       expect(find.byType(NewUserScreen), findsOneWidget);
//       for (var w in find.byType(TextFormField).evaluate()) {
//         // put values in for mileage form
//         await tester.enterText(find.byWidget(w.widget), '2000');
//         await tester.pumpAndSettle();
//       }
//       await tester.tap(find.text(IntlKeys.next));
//       await tester.pumpAndSettle();
//       expect(find.byType(LatestRepeatsScreen), findsOneWidget);
//     });
//     testWidgets('set repeats', (tester) async {
//       final dataBloc = MockDataBloc();
//       when(dataBloc.state).thenReturn(
//           DataLoaded(cars: [Car(name: 'test', odomSnapshot: null)]));
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(
//               providers: [
//                 BlocProvider<AuthenticationBloc>.value(value: authBloc),
//                 BlocProvider<DatabaseBloc>.value(value: dbBloc),
//                 BlocProvider<DataBloc>.value(value: dataBloc),
//               ],
//               child: MaterialApp(
//                 home: NewUserScreen(),
//                 locale: Locale('en'),
//               )),
//         ),
//       );
//       expect(find.byType(NewUserScreen), findsOneWidget);
//       for (var w in find.byType(TextFormField).evaluate()) {
//         // put values in for mileage form
//         await tester.enterText(find.byWidget(w.widget), '2000');
//         await tester.pump();
//       }
//       await tester.tap(find.text(IntlKeys.next));
//       await tester.pumpAndSettle();
//       expect(find.byType(LatestRepeatsScreen), findsOneWidget);
//       await tester.tap(find.text(IntlKeys.next));
//       await tester.pumpAndSettle();
//       expect(find.byType(SetRepeatsScreen), findsOneWidget);
//     });
//     testWidgets('set repeats back', (tester) async {
//       final dataBloc = MockDataBloc();
//       when(dataBloc.state).thenReturn(DataLoaded(
//           todos: [Todo(name: 'oil'), Todo(name: 'tire_rotation')],
//           cars: [Car(name: 'test', odomSnapshot: null)]));
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(providers: [
//             BlocProvider<AuthenticationBloc>.value(value: authBloc),
//             BlocProvider<DatabaseBloc>.value(value: dbBloc),
//             BlocProvider<DataBloc>.value(value: dataBloc),
//           ], child: MaterialApp(home: NewUserScreen())),
//         ),
//       );
//       expect(find.byType(NewUserScreen), findsOneWidget);
//       for (var w in find.byType(TextFormField).evaluate()) {
//         // put values in for mileage form
//         await tester.enterText(find.byWidget(w.widget), '2000');
//         await tester.pump();
//       }
//       await tester.tap(find.text(IntlKeys.next));
//       await tester.pumpAndSettle();
//       expect(find.byType(LatestRepeatsScreen), findsOneWidget);
//       await tester.tap(find.text(IntlKeys.next));
//       await tester.pumpAndSettle();
//       expect(find.byType(SetRepeatsScreen), findsOneWidget);
//       await tester.tap(find.byIcon(Icons.arrow_back));
//       await tester.pumpAndSettle();
//       expect(find.byType(LatestRepeatsScreen), findsOneWidget);
//     });
//     testWidgets('set repeats next', (tester) async {
//       final dataBloc = MockDataBloc();
//       whenListen(dataBloc, Stream.fromIterable([dataLoaded]));
//       when(dataBloc.state).thenReturn(dataLoaded);
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(
//               providers: [
//                 BlocProvider<AuthenticationBloc>.value(value: authBloc),
//                 BlocProvider<DatabaseBloc>.value(value: dbBloc),
//                 BlocProvider<DataBloc>.value(value: dataBloc),
//               ],
//               child: MaterialApp(
//                 home: NewUserScreen(),
//               )),
//         ),
//       );
//       expect(find.byType(NewUserScreen), findsOneWidget);
//       for (var w in find.byType(TextFormField).evaluate()) {
//         // put values in for mileage form
//         await tester.enterText(find.byWidget(w.widget), '2000');
//         await tester.pump();
//       }
//       await tester.tap(find.text(IntlKeys.next));
//       await tester.pumpAndSettle();
//       expect(find.byType(LatestRepeatsScreen), findsOneWidget);
//       await tester.tap(find.text(IntlKeys.next));
//       await tester.pumpAndSettle();
//       expect(find.byType(SetRepeatsScreen), findsOneWidget);
//       await tester.tap(find.text(IntlKeys.next));
//       await tester.pumpAndSettle();
//     });
//   });
// }
void main() {}
