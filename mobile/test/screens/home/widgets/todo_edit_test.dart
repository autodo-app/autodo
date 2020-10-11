// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:pref/pref.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:autodo/blocs/blocs.dart';
// import 'package:autodo/screens/add_edit/barrel.dart';
// import 'package:autodo/screens/home/widgets/todo_edit_button.dart';
// import 'package:autodo/models/models.dart';
// import 'package:autodo/units/units.dart';

// class MockDataBloc extends MockBloc<DataEvent, DataState> implements DataBloc {}

// void main() {
//   BasePrefService pref;
//   DataBloc dataBloc;

//   setUp(() async {
//     dataBloc = MockDataBloc();
//     pref = PrefServiceCache();
//     await pref.setDefaultValues({
//       'length_unit': DistanceUnit.imperial.index,
//       'volume_unit': VolumeUnit.us.index,
//       'currency': 'USD',
//     });
//   });

//   group('TodoEditButton', () {
//     testWidgets('renders', (WidgetTester tester) async {
//       final todosKey = Key('todos');
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: TodoEditButton(key: todosKey, todo: Todo()),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//       expect(find.byKey(todosKey), findsOneWidget);
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
//               body: TodoEditButton(key: todosKey, todo: Todo()),
//             ),
//           ),
//         ),
//       ));
//       await tester.pumpAndSettle();
//       await tester.tap(find.byKey(todosKey));
//       await tester.pump();
//       await tester
//           .pump(); // pump twice to get the screen to show, it won't settle though

//       expect(find.byType(TodoAddEditScreen), findsOneWidget);
//     });
//   });
// }
void main() {}
