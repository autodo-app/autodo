import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/home/views/todos.dart';
import 'package:autodo/screens/home/widgets/todo_card.dart';
import 'package:autodo/units/units.dart';
import 'package:autodo/screens/home/widgets/barrel.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState>
    implements CarsBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

void main() {
  group('TodosScreen', () {
    TodosBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;
    CarsBloc carsBloc;
    BasePrefService pref;

    setUp(() async {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
      carsBloc = MockCarsBloc();
      pref = JustCachePrefService();
      await pref.setDefaultValues({
        'length_unit': DistanceUnit.imperial.index,
        'volume_unit': VolumeUnit.us.index,
        'currency': 'USD',
      });
    });

    testWidgets('renders loading', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded(todos: []));
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoading());
      final todosKey = Key('todos');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TodosScreen(key: todosKey),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(todosKey), findsOneWidget);
      // expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('renders simple todo list', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded(todos: []));
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded(
          {null: [Todo(name: '', completed: true)]}, VisibilityFilter.all));
      final todosKey = Key('todos');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<CarsBloc>.value(value: carsBloc),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TodosScreen(key: todosKey),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(todosKey), findsOneWidget);
    });
    testWidgets('renders due date and due mileage',
        (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded(todos: []));
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({null: [
            Todo(
                name: '',
                dueDate: DateTime.fromMillisecondsSinceEpoch(0),
                dueMileage: 0,
                completed: true)
          ]}, VisibilityFilter.all));
      final todosKey = Key('todos');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TodosBloc>.value(
                value: todosBloc,
              ),
              BlocProvider<CarsBloc>.value(value: carsBloc),
              BlocProvider<FilteredTodosBloc>.value(
                value: filteredTodosBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: TodosScreen(key: todosKey),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(todosKey), findsOneWidget);
    });
    testWidgets('check', (WidgetTester tester) async {
      var updated = false;
      final todo = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.UPCOMING,
          completed: false,
          carName: 'car');
      when(filteredTodosBloc.state)
          .thenAnswer((_) => FilteredTodosLoaded({TodoDueState.UPCOMING: [todo]}, VisibilityFilter.all));
      when(todosBloc.state).thenReturn(TodosLoaded(todos: [todo]));
      when(todosBloc.add(any)).thenAnswer((_) {updated = true;});
      when(carsBloc.state).thenReturn(CarsLoaded([Car(name: 'car')]));
      final todosKey = Key('todos');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TodosBloc>.value(
                value: todosBloc,
              ),
              BlocProvider<CarsBloc>.value(value: carsBloc),
              BlocProvider<FilteredTodosBloc>.value(
                value: filteredTodosBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: TodosScreen(key: todosKey),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TodoListCard), findsOneWidget);
      await tester.tap(find.byType(RoundedCheckbox));
      await tester.pump();
      expect(updated, true);
      // TODO: check that the todo matches the expected state
    });
    testWidgets('dismiss', (WidgetTester tester) async {
      var deleted = false;
      final todo = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.UPCOMING,
          completed: false,
          carName: 'car');
      when(filteredTodosBloc.state)
          .thenAnswer((_) => FilteredTodosLoaded({TodoDueState.UPCOMING: [todo]}, VisibilityFilter.all));
      when(todosBloc.state).thenReturn(TodosLoaded(todos: [todo]));
      when(todosBloc.add(any)).thenAnswer((_) {deleted = true;});
      when(carsBloc.state).thenReturn(CarsLoaded([Car(name: 'car')]));
      final todosKey = Key('todos');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TodosBloc>.value(
                value: todosBloc,
              ),
              BlocProvider<CarsBloc>.value(value: carsBloc),
              BlocProvider<FilteredTodosBloc>.value(
                value: filteredTodosBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: TodosScreen(key: todosKey),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.fling(find.byType(TodoListCard), Offset(-300, 0), 10000.0);
      await tester.pumpAndSettle();
      expect(deleted, true);
    });
  });
}
