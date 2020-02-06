import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/screens/home/widgets/todo_card.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

void main() {
  group('TodosCard', () {
    TodosBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
    });

    testWidgets('renders', (WidgetTester tester) async {
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
              body: TodoCard(
                key: todosKey,
                todo: Todo(name: 'test', completed: false),
                onCheckboxChanged: (_) {},
                onDismissed: (_) {},
                onTap: () {},
                emphasized: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(todosKey), findsOneWidget);
    });
    testWidgets('past due', (WidgetTester tester) async {
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
              body: TodoCard(
                key: todosKey,
                todo: Todo(
                    name: 'test',
                    dueState: TodoDueState.PAST_DUE,
                    completed: false),
                onCheckboxChanged: (_) {},
                onDismissed: (_) {},
                onTap: () {},
                emphasized: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(todosKey), findsOneWidget);
    });
    testWidgets('due soon', (WidgetTester tester) async {
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
              body: TodoCard(
                key: todosKey,
                todo: Todo(
                    name: 'test',
                    dueState: TodoDueState.DUE_SOON,
                    completed: false),
                onCheckboxChanged: (_) {},
                onDismissed: (_) {},
                onTap: () {},
                emphasized: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(todosKey), findsOneWidget);
    });
    testWidgets('check', (WidgetTester tester) async {
      Key todosKey = Key('todos');
      bool checkboxChanged = false;
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
              body: TodoCard(
                key: todosKey,
                todo: Todo(name: 'test', completed: false),
                onCheckboxChanged: (_) {
                  checkboxChanged = true;
                },
                onDismissed: (_) {},
                onTap: () {},
                emphasized: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(checkboxChanged, true);
    });
    testWidgets('dismiss', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded(
          [Todo(name: '', completed: false)], VisibilityFilter.all));
      Key todosKey = Key('todos');
      bool dismissed = false;
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
              body: TodoCard(
                key: todosKey,
                todo: Todo(name: 'test', completed: false),
                onCheckboxChanged: (_) {},
                onDismissed: (_) {
                  dismissed = true;
                },
                onTap: () {},
                emphasized: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.fling(find.byKey(todosKey), Offset(-300, 0), 10000.0);
      await tester.pumpAndSettle();
      expect(dismissed, true);
    });
    testWidgets('tap', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoaded(
          [Todo(name: '', completed: false)], VisibilityFilter.all));
      Key todosKey = Key('todos');
      bool tapped = false;
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
              body: TodoCard(
                key: todosKey,
                todo: Todo(name: 'test', completed: false),
                onCheckboxChanged: (_) {},
                onDismissed: (_) {},
                onTap: () {
                  tapped = true;
                },
                emphasized: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(todosKey));
      await tester.pump();
      expect(tapped, true);
    });
  });
}
