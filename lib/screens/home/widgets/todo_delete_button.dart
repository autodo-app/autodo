import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/models/models.dart';

class TodoDeleteButton extends StatelessWidget {
  final Todo todo;

  TodoDeleteButton({Key key, @required this.todo}) : super(key: key);

  @override
  build(context) => ButtonTheme.fromButtonThemeData(
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
              todo: todo,
              onUndo: () =>
                  BlocProvider.of<TodosBloc>(context).add(AddTodo(todo)),
            ));
          },
        ),
      );
}
