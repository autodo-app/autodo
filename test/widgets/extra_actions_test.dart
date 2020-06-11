import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/generated/localization.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataBloc extends MockBloc<DataEvent, DataState>
    implements DataBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosEvent, FilteredTodosState>
    implements FilteredTodosBloc {}

void main() {
  group('ExtraActions', () {
    DataBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;

    setUp(() {
      todosBloc = MockDataBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
    });

    testWidgets('renders an empty Container if state is not TodosLoaded',
        (WidgetTester tester) async {
      when(todosBloc.state).thenReturn(DataLoading());
      when(filteredTodosBloc.state).thenAnswer((_) => FilteredTodosLoading());
      final key = Key('test');
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<DataBloc>.value(value: todosBloc),
          BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc)
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [ExtraActions(key: key)],
            ),
            body: Container(),
          ),
        ),
      ));
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets(
        'renders PopupMenuButton with mark all done if state is TodosLoaded with incomplete todos',
        (WidgetTester tester) async {
      final todosList = [
        Todo(name: 'test', completed: false, dueState: TodoDueState.DUE_SOON)
      ];
      final todos = {TodoDueState.DUE_SOON: todosList};
      when(todosBloc.state).thenReturn(DataLoaded(todos: todosList));
      final actions = Key('actions');
      final toggleAll = Key('toggleAll');
      when(filteredTodosBloc.state)
          .thenAnswer((_) => FilteredTodosLoaded(todos, VisibilityFilter.all));
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<DataBloc>.value(value: todosBloc),
          BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc)
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [
                ExtraActions(
                  key: actions,
                  toggleAllKey: toggleAll,
                )
              ],
            ),
            body: Container(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(actions));
      await tester.pump();
      expect(find.byKey(toggleAll), findsOneWidget);
      expect(find.text(IntlKeys.markAllComplete), findsOneWidget);
    });

    testWidgets(
        'renders PopupMenuButton with mark all incomplete if state is TodosLoaded with complete todos',
        (WidgetTester tester) async {
      final todosList = [Todo(name: 'test', completed: true)];
      final todosMap = {TodoDueState.DUE_SOON: todosList};
      when(todosBloc.state).thenReturn(DataLoaded(todos: todosList));
      final actions = Key('actions');
      final toggleAll = Key('toggleAll');
      when(filteredTodosBloc.state).thenAnswer(
          (_) => FilteredTodosLoaded(todosMap, VisibilityFilter.all));
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<DataBloc>.value(value: todosBloc),
          BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc)
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [
                ExtraActions(
                  key: actions,
                  toggleAllKey: toggleAll,
                )
              ],
            ),
            body: Container(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(actions));
      await tester.pump();
      expect(find.byKey(toggleAll), findsOneWidget);
      expect(find.text(IntlKeys.markAllIncomplete), findsOneWidget);
    });
    testWidgets('tapping toggle all adds ToggleAll',
        (WidgetTester tester) async {
      final todosList = [
        Todo(name: 'test', completed: false, dueState: TodoDueState.DUE_SOON),
        Todo(name: 'test2', completed: true, dueState: TodoDueState.DUE_SOON),
      ];
      final todosMap = {TodoDueState.DUE_SOON: todosList};
      when(todosBloc.state).thenReturn(DataLoaded(todos: todosList));
      when(todosBloc.add(ToggleAllTodosComplete())).thenReturn(null);
      final actions = Key('actions');
      final toggleAll = Key('toggleAll');
      when(filteredTodosBloc.state).thenAnswer(
          (_) => FilteredTodosLoaded(todosMap, VisibilityFilter.all));
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<DataBloc>.value(value: todosBloc),
          BlocProvider<FilteredTodosBloc>.value(value: filteredTodosBloc)
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [
                ExtraActions(
                  key: actions,
                  toggleAllKey: toggleAll,
                )
              ],
            ),
            body: Container(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(actions));
      await tester.pump();
      expect(find.byKey(toggleAll), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(toggleAll));
      verify(todosBloc.add(ToggleAllTodosComplete())).called(1);
    });
  });
}
