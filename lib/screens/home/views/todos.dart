import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../integ_test_keys.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key key}) : super(key: key);

  void onDismissed(direction, context, todo) {
    BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
    Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
      context: context,
      todo: todo,
      onUndo: () => BlocProvider.of<TodosBloc>(context).add(AddTodo(todo)),
    ));
  }

  Future<void> onTap(context, todo) async {
    // final removedTodo = await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => DetailsScreen(id: todo.id),
    //   ),
    // );
  }

  void onCheckboxChanged(context, todo) {
    BlocProvider.of<TodosBloc>(context).add(
      UpdateTodo(todo.copyWith(completed: !todo.completed)),
    );
  }

  @override
  Widget build(context) => BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
          builder: (context, state) {
        if (state is FilteredTodosLoading) {
          return LoadingIndicator();
        } else if (state is FilteredTodosLoaded) {
          final todos = state.filteredTodos;
          print('num todos: ${todos.length}');
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
