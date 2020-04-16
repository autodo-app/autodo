import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';

class TodoDeleteButton extends StatelessWidget {
  const TodoDeleteButton({Key key, @required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) => ButtonTheme.fromButtonThemeData(
        key: ValueKey('__todo_delete_button_${todo.name}'),
        data: ButtonThemeData(
          minWidth: 0,
        ),
        child: FlatButton(
          child: Icon(
            Icons.delete,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          onPressed: () {
            BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
            Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
              context: context,
              todo: todo,
              onUndo: () =>
                  BlocProvider.of<TodosBloc>(context).add(AddTodo(todo)),
            ));
          },
        ),
      );
}
