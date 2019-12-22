import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/screens/home/screen.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/localization.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockFilteredTodosBloc
    extends MockBloc<FilteredTodosLoaded, FilteredTodosState>
    implements FilteredTodosBloc {}

class MockTabBloc extends MockBloc<TabEvent, AppTab> implements TabBloc {}

void main() {
  group('HomeScreen', () {
    TodosBloc todosBloc;
    FilteredTodosBloc filteredTodosBloc;
    TabBloc tabBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      filteredTodosBloc = MockFilteredTodosBloc();
      tabBloc = MockTabBloc();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(tabBloc.state).thenAnswer((_) => AppTab.todos);
      Key scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<TabBloc>.value(
              value: tabBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(key: scaffoldKey),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(scaffoldKey), findsOneWidget);
      expect(find.text(AutodoLocalizations.appTitle), findsOneWidget);
    });

    testWidgets('tab switch', (WidgetTester tester) async {
      when(todosBloc.state).thenAnswer((_) => TodosLoaded([]));
      when(tabBloc.state).thenAnswer((_) => AppTab.todos);  
      when(tabBloc.add(UpdateTab(AppTab.todos))).thenAnswer((_) => null);
      Key scaffoldKey = Key('scaffold');
      Key todosTabKey = Key('tab');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(
              value: todosBloc,
            ),
            BlocProvider<FilteredTodosBloc>.value(
              value: filteredTodosBloc,
            ),
            BlocProvider<TabBloc>.value(
              value: tabBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(key: scaffoldKey, todosTabKey: todosTabKey),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(todosTabKey));
      await tester.pump();
      verify(tabBloc.add(UpdateTab(AppTab.todos))).called(1);
    });
  });
}