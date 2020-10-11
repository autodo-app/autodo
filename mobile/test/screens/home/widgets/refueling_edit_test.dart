// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:pref/pref.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mockito/mockito.dart';

// import 'package:autodo/blocs/blocs.dart';
// import 'package:autodo/screens/add_edit/barrel.dart';
// import 'package:autodo/screens/home/widgets/refueling_edit_button.dart';
// import 'package:autodo/models/models.dart';
// import 'package:autodo/units/units.dart';

// class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

// void main() {
//   BasePrefService pref;
//   DataBloc dataBloc;
//   final snap = OdomSnapshot(
//     date: DateTime.fromMillisecondsSinceEpoch(0),
//     mileage: 10.0,
//     car: 'test',
//   );
//   final car = Car(name: 'test', odomSnapshot: snap);
//   final refueling = Refueling(amount: 10.0, odomSnapshot: snap, cost: 10.0);

//   setUp(() async {
//     dataBloc = MockDataBloc();
//     when(dataBloc.state)
//         .thenReturn(DataLoaded(cars: [car], refuelings: [refueling]));
//     pref = PrefServiceCache();
//     await pref.setDefaultValues({
//       'length_unit': DistanceUnit.imperial.index,
//       'volume_unit': VolumeUnit.us.index,
//       'currency': 'USD',
//     });
//   });

//   group('RefuelingEditButton', () {
//     testWidgets('renders', (WidgetTester tester) async {
//       final refuelingsKey = Key('refuelings');
//       await tester.pumpWidget(ChangeNotifierProvider<BasePrefService>.value(
//         value: pref,
//         child: MultiBlocProvider(
//           providers: [
//             BlocProvider<DataBloc>.value(value: dataBloc),
//           ],
//           child: MaterialApp(
//             home: Scaffold(
//               body:
//                   RefuelingEditButton(key: refuelingsKey, refueling: refueling),
//             ),
//           ),
//         ),
//       ));
//       await tester.pumpAndSettle();
//       expect(find.byKey(refuelingsKey), findsOneWidget);
//     });
//     testWidgets('press', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       await tester.pumpWidget(ChangeNotifierProvider<BasePrefService>.value(
//         value: pref,
//         child: MultiBlocProvider(
//           providers: [
//             BlocProvider<DataBloc>.value(value: dataBloc),
//           ],
//           child: MaterialApp(
//             home: Scaffold(
//               body: RefuelingEditButton(key: todosKey, refueling: refueling),
//             ),
//           ),
//         ),
//       ));
//       await tester.pumpAndSettle();
//       await tester.tap(find.byKey(todosKey));
//       await tester.pumpAndSettle();

//       expect(find.byType(RefuelingAddEditScreen), findsOneWidget);
//     });
//     testWidgets('press and save', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       var _saved = false;
//       when(dataBloc.add(any)).thenAnswer((realInvocation) {
//         _saved = true;
//       });
//       await tester.pumpWidget(ChangeNotifierProvider<BasePrefService>.value(
//         value: pref,
//         child: MultiBlocProvider(
//           providers: [
//             BlocProvider<DataBloc>.value(value: dataBloc),
//           ],
//           child: MaterialApp(
//             home: Scaffold(
//               body: RefuelingEditButton(key: todosKey, refueling: refueling),
//             ),
//           ),
//         ),
//       ));
//       await tester.pumpAndSettle();
//       await tester.tap(find.byKey(todosKey));
//       await tester.pumpAndSettle();

//       expect(find.byType(RefuelingAddEditScreen), findsOneWidget);

//       await tester.tap(find.byType(FloatingActionButton));
//       await tester.pumpAndSettle();
//       expect(_saved, true);
//     });
//   });
// }
void main() {}
