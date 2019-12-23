import 'package:autodo/screens/home/widgets/todo_delete_button.dart';
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
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TodoDeleteButton(  
                key: todosKey,
                todo: Todo(name: 'test')
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(todosKey), findsOneWidget);
    });
    testWidgets('press', (WidgetTester tester) async {
      Key todosKey = Key('todos');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TodoDeleteButton(  
                key: todosKey,
                todo: Todo(name: 'test')
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(todosKey));
      await tester.pump();

      verify(todosBloc.add(DeleteTodo(Todo(name: 'test')))).called(1);
    });
    testWidgets('undo', (WidgetTester tester) async {
      Key todosKey = Key('todos');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TodoDeleteButton(  
                key: todosKey,
                todo: Todo(name: 'test')
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(todosKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Undo'));
      await tester.pump();
      verify(todosBloc.add(AddTodo(Todo(name: 'test')))).called(1);
    });
  });
}