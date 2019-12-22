import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/screens/home/views/todos.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/widgets/widgets.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

void main() {
  group('TodosScreen', () {
    TodosBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
    });

    testWidgets('renders loading', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoading());
      Key todosKey = Key('todos');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
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
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('renders simple todo list', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded([Todo(name: '')], VisibilityFilter.all));
      Key todosKey = Key('todos');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
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
    testWidgets('renders due date and due mileage', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded([Todo(name: '', dueDate: DateTime.fromMillisecondsSinceEpoch(0), dueMileage: 0)], VisibilityFilter.all));
      Key todosKey = Key('todos');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
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
  });
}