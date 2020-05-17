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
import 'package:json_intl/json_intl.dart';
import 'package:mockito/mockito.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

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
      pref = PrefServiceCache();
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
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({
            null: [Todo(name: '', completed: true)]
          }, VisibilityFilter.all));
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
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({
            null: [
              Todo(
                  name: '',
                  dueDate: DateTime.fromMillisecondsSinceEpoch(0),
                  dueMileage: 0,
                  completed: true)
            ]
          }, VisibilityFilter.all));
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
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({
            TodoDueState.UPCOMING: [todo],
          }, VisibilityFilter.all));
      when(todosBloc.state).thenReturn(TodosLoaded(todos: [todo]));
      when(todosBloc.add(any)).thenAnswer((_) {
        updated = true;
      });
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
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({
            TodoDueState.UPCOMING: [todo]
          }, VisibilityFilter.all));
      when(todosBloc.state).thenReturn(TodosLoaded(todos: [todo]));
      when(todosBloc.add(any)).thenAnswer((_) {
        deleted = true;
      });
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
    testWidgets('All headers', (WidgetTester tester) async {
      final upcoming = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.UPCOMING,
          completed: false,
          carName: 'car');
      final pastDue = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.PAST_DUE,
          completed: false,
          carName: 'car');
      final dueSoon = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.DUE_SOON,
          completed: false,
          carName: 'car');
      final complete = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.COMPLETE,
          completed: false,
          carName: 'car');
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({
            TodoDueState.UPCOMING: [upcoming],
            TodoDueState.PAST_DUE: [pastDue],
            TodoDueState.DUE_SOON: [dueSoon],
            TodoDueState.COMPLETE: [complete],
          }, VisibilityFilter.all));
      when(todosBloc.state).thenReturn(
          TodosLoaded(todos: [upcoming, pastDue, dueSoon, complete]));
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
      expect(find.byType(TodoListCard), findsNWidgets(4));
      expect(find.byIcon(Icons.priority_high), findsOneWidget); // alert
    });
    testWidgets('Due Soon warning', (WidgetTester tester) async {
      final upcoming = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.UPCOMING,
          completed: false,
          carName: 'car');
      final dueSoon = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.DUE_SOON,
          completed: false,
          carName: 'car');
      final complete = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.COMPLETE,
          completed: false,
          carName: 'car');
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({
            TodoDueState.UPCOMING: [upcoming],
            TodoDueState.DUE_SOON: [dueSoon],
            TodoDueState.COMPLETE: [complete],
          }, VisibilityFilter.all));
      when(todosBloc.state)
          .thenReturn(TodosLoaded(todos: [upcoming, dueSoon, complete]));
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
      expect(find.byType(TodoListCard), findsNWidgets(3));
      expect(find.byIcon(Icons.notifications),
          findsOneWidget); // alert for due soon
    });
    testWidgets('expanded toggle', (WidgetTester tester) async {
      final todo = Todo(
          name: '',
          dueDate: DateTime.fromMillisecondsSinceEpoch(0),
          dueMileage: 0,
          dueState: TodoDueState.UPCOMING,
          completed: false,
          carName: 'car');
      final todoList = List.filled(5, todo);
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded({
            TodoDueState.UPCOMING: todoList,
          }, VisibilityFilter.all));
      when(todosBloc.state).thenReturn(TodosLoaded(todos: todoList));
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
              localizationsDelegates: [const JsonIntlDelegate()],
              supportedLocales: [const Locale('en')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TodoListCard), findsNWidgets(4));

      // expand
      expect(find.text('Show More'), findsOneWidget);
      await tester.tap(find.widgetWithText(FlatButton, 'Show More'));
      await tester.pump();
      await tester.pumpAndSettle();
      // There's a bug with taps getting sent through to FlatButtons so we'll
      // manually call the onPressed function to make things happen
      FlatButton button =
          find.widgetWithText(FlatButton, 'Show More').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle();
      expect(find.byType(TodoListCard), findsNWidgets(5));

      // collapse
      await tester.ensureVisible(find.widgetWithText(FlatButton, 'Show Less'));
      await tester.tap(find.text('Show Less'));
      await tester.pumpAndSettle();
      button =
          find.widgetWithText(FlatButton, 'Show Less').evaluate().first.widget;
      button.onPressed();
      await tester.pumpAndSettle();
      expect(find.byType(TodoListCard), findsNWidgets(4));
    });
  });
}
