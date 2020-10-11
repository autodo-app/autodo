// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pref/pref.dart';
// import 'package:provider/provider.dart';

// import 'package:autodo/screens/home/widgets/barrel.dart';
// import 'package:autodo/blocs/blocs.dart';
// import 'package:autodo/models/models.dart';
// import 'package:autodo/units/units.dart';

// class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

// class MockFilteredTodosBloc
//     extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
//     implements FilteredTodosBloc {}

// void main() {
//   BasePrefService pref;

//   setUp(() async {
//     pref = PrefServiceCache();
//     await pref.setDefaultValues({
//       'length_unit': DistanceUnit.imperial.index,
//       'volume_unit': VolumeUnit.us.index,
//       'currency': 'USD',
//     });
//   });
//   group('TodosCard', () {
//     DataBloc dataBloc;
//     FilteredTodosBloc filteredTodosBloc;
//     Car car;

//     setUp(() {
//       dataBloc = MockDataBloc();
//       filteredTodosBloc = MockFilteredTodosBloc();
//       car = Car(
//           name: 'car',
//           odomSnapshot: OdomSnapshot(
//               date: DateTime.fromMillisecondsSinceEpoch(0), mileage: 0));
//     });

//     testWidgets('renders', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<DataBloc>.value(value: dataBloc),
//             BlocProvider<FilteredTodosBloc>.value(
//               value: filteredTodosBloc,
//             ),
//           ],
//           child: MaterialApp(
//             home: Scaffold(
//               body: TodoListCard(
//                 key: todosKey,
//                 todo: Todo(name: 'test', completed: false, carId: 'car'),
//                 onDelete: () {},
//                 car: car,
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//       expect(find.byKey(todosKey), findsOneWidget);
//     });
//     testWidgets('past due', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<DataBloc>.value(value: dataBloc),
//             BlocProvider<FilteredTodosBloc>.value(
//               value: filteredTodosBloc,
//             ),
//           ],
//           child: MaterialApp(
//             home: Scaffold(
//               body: TodoListCard(
//                 key: todosKey,
//                 todo: Todo(
//                     name: 'test',
//                     dueState: TodoDueState.PAST_DUE,
//                     completed: false,
//                     carId: 'car'),
//                 onDelete: () {},
//                 car: car,
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//       expect(find.byKey(todosKey), findsOneWidget);
//     });
//     testWidgets('due soon', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<DataBloc>.value(value: dataBloc),
//             BlocProvider<FilteredTodosBloc>.value(
//               value: filteredTodosBloc,
//             ),
//           ],
//           child: MaterialApp(
//             home: Scaffold(
//               body: TodoListCard(
//                 key: todosKey,
//                 todo: Todo(
//                     name: 'test',
//                     dueState: TodoDueState.DUE_SOON,
//                     completed: false,
//                     carId: 'car'),
//                 onDelete: () {},
//                 car: car,
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//       expect(find.byKey(todosKey), findsOneWidget);
//     });
//     testWidgets('check', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       var checkboxChanged = false;
//       when(dataBloc.add(any)).thenAnswer((_) {
//         checkboxChanged = true;
//       });
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<DataBloc>.value(value: dataBloc),
//             BlocProvider<FilteredTodosBloc>.value(
//               value: filteredTodosBloc,
//             ),
//           ],
//           child: MaterialApp(
//             home: Scaffold(
//               body: TodoListCard(
//                 key: todosKey,
//                 todo: Todo(name: 'test', completed: false, carId: 'car'),
//                 onDelete: () {},
//                 car: car,
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//       await tester.tap(find.byType(RoundedCheckbox));
//       await tester.pump();
//       expect(checkboxChanged, true);
//     });
//     testWidgets('dismiss', (WidgetTester tester) async {
//       when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({
//             null: [Todo(name: '', completed: false)]
//           }, VisibilityFilter.all));
//       final todosKey = Key('todos');
//       var dismissed = false;
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<DataBloc>.value(value: dataBloc),
//             BlocProvider<FilteredTodosBloc>.value(
//               value: filteredTodosBloc,
//             ),
//           ],
//           child: MaterialApp(
//             home: Scaffold(
//               body: TodoListCard(
//                 key: todosKey,
//                 todo: Todo(name: 'test', completed: false, carId: 'car'),
//                 onDelete: () {
//                   dismissed = true;
//                 },
//                 car: car,
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//       await tester.fling(find.byKey(todosKey), Offset(-300, 0), 10000.0);
//       await tester.pumpAndSettle();
//       expect(dismissed, true);
//     });
//     testWidgets('dueMileage no dueDate', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(
//             providers: [
//               BlocProvider<DataBloc>.value(value: dataBloc),
//               BlocProvider<FilteredTodosBloc>.value(
//                 value: filteredTodosBloc,
//               ),
//             ],
//             child: MaterialApp(
//               home: Scaffold(
//                 body: TodoListCard(
//                   key: todosKey,
//                   todo: Todo(
//                       name: 'test',
//                       dueState: TodoDueState.PAST_DUE,
//                       dueMileage: 1000,
//                       completed: false,
//                       carId: 'car'),
//                   onDelete: () {},
//                   car: car,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//       expect(find.byKey(todosKey), findsOneWidget);
//     });
//     testWidgets('dueDate no dueMileage', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       await tester.pumpWidget(
//         ChangeNotifierProvider<BasePrefService>.value(
//           value: pref,
//           child: MultiBlocProvider(
//             providers: [
//               BlocProvider<DataBloc>.value(value: dataBloc),
//               BlocProvider<FilteredTodosBloc>.value(
//                 value: filteredTodosBloc,
//               ),
//             ],
//             child: MaterialApp(
//               home: Scaffold(
//                 body: TodoListCard(
//                   key: todosKey,
//                   todo: Todo(
//                       name: 'test',
//                       dueState: TodoDueState.PAST_DUE,
//                       dueDate: DateTime.fromMillisecondsSinceEpoch(0),
//                       completed: false,
//                       carId: 'car'),
//                   onDelete: () {},
//                   car: car,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//       expect(find.byKey(todosKey), findsOneWidget);
//     });
//   });
// }
void main() {}
