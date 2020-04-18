import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../integ_test_keys.dart';
import '../../../models/models.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key key}) : super(key: key);

  void onDismissed(
      DismissDirection direction, BuildContext context, Todo todo) {
    BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
    Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
      context: context,
      todo: todo,
      onUndo: () => BlocProvider.of<TodosBloc>(context).add(AddTodo(todo)),
    ));
  }

  Future<void> onTap(BuildContext context, Todo todo) async {
    // final removedTodo = await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => DetailsScreen(id: todo.id),
    //   ),
    // );
  }

  void onCheckboxChanged(BuildContext context, Todo todo) {
    BlocProvider.of<TodosBloc>(context).add(
      UpdateTodo(todo.copyWith(completed: !todo.completed)),
    );
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
          builder: (context, state) {
        if (state is FilteredTodosLoading) {
          return LoadingIndicator();
        } else if (state is FilteredTodosLoaded) {
          final todos = state.filteredTodos;
          return ListView.builder(
            key: IntegrationTestKeys.todosScreenScroller,
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TodoCard(
                    key: UniqueKey(),
                    todo: todo,
                    onDismissed: (direction) =>
                        onDismissed(direction, context, todo),
                    onTap: () => onTap(context, todo),
                    onCheckboxChanged: (_) => onCheckboxChanged(context, todo),
                    emphasized: index == 0,
                  ));
            },
          );
        } else {
          return Container();
        }
      });
}

class TodosPanel extends StatelessWidget {
  const TodosPanel(this.todos);

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) => Container(
    height: 1000,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      color: Theme.of(context).cardColor,
    ),
  );
}

class TodosScreen2 extends StatelessWidget {
  static final grad1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [mainColors[300], mainColors[400]]);

  static final grad2 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [mainColors[700], mainColors[900]]);

  final BoxDecoration upcomingDecoration = BoxDecoration(
      gradient: LinearGradient.lerp(grad1, grad2, 0.5));

  @override
  Widget build(BuildContext context) => BlocBuilder<TodosBloc, TodosState>(
    builder: (context, state) {
      if (!(state is TodosLoaded)) {
        return Container();
      }

      return Container(
        decoration: upcomingDecoration,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 130.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(fit: FlexFit.loose, child: Text('ToDos')),
                    Flexible(fit: FlexFit.loose, child: Text('1 late ToDo'))
                  ]
                ),
                titlePadding: EdgeInsets.all(15),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(child: TodosPanel((state as TodosLoaded).todos)),
          ],
        )
      );
    }
  );
}