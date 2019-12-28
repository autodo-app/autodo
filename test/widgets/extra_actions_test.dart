import 'package:autodo/localization.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/models/models.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  group('ExtraActions', () {
    TodosBloc todosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
    });

    testWidgets('renders an empty Container if state is not TodosLoaded',
        (WidgetTester tester) async {
      when(todosBloc.state).thenReturn(TodosLoading());
      final key = Key('test');
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [ExtraActions(key: key)],
              ),
              body: Container(),
            ),
          ),
        ),
      );
      expect(find.byKey((key)), findsOneWidget);
    });

    testWidgets(
        'renders PopupMenuButton with mark all done if state is TodosLoaded with incomplete todos',
        (WidgetTester tester) async {
      when(todosBloc.state)
          .thenReturn(TodosLoaded([Todo(name: 'test', completed: false)]));
      final actions = Key('actions');
      final toggleAll = Key('toggleAll');
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
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
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(actions));
      await tester.pump();
      expect(find.byKey(toggleAll), findsOneWidget);
      expect(find.text(AutodoLocalizations.markAllComplete), findsOneWidget);
    });

    testWidgets(
        'renders PopupMenuButton with mark all incomplete if state is TodosLoaded with complete todos',
        (WidgetTester tester) async {
      when(todosBloc.state)
          .thenReturn(TodosLoaded([Todo(name: 'test', completed: true)]));
      final actions = Key('actions');
      final toggleAll = Key('toggleAll');
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
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
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(actions));
      await tester.pump();
      expect(find.byKey(toggleAll), findsOneWidget);
      expect(find.text(AutodoLocalizations.markAllIncomplete), findsOneWidget);
    });
    testWidgets('tapping toggle all adds ToggleAll',
        (WidgetTester tester) async {
      when(todosBloc.state).thenReturn(TodosLoaded([
        Todo(name: 'test', completed: false),
        Todo(name: 'test2', completed: true),
      ]));
      when(todosBloc.add(ToggleAll())).thenReturn(null);
      final actions = Key('actions');
      final toggleAll = Key('toggleAll');
      await tester.pumpWidget(
        BlocProvider.value(
          value: todosBloc,
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
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(actions));
      await tester.pump();
      expect(find.byKey(toggleAll), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(toggleAll));
      verify(todosBloc.add(ToggleAll())).called(1);
    });
  });
}
