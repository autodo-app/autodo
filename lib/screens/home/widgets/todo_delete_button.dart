import 'package:flutter/material.dart';

import '../../../models/models.dart';

class TodoDeleteButton extends StatelessWidget {
  const TodoDeleteButton({Key key, @required this.todo, this.onDelete}) : super(key: key);

  final Todo todo;
  final VoidCallback onDelete;

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
      onPressed: onDelete,
    ),
  );
}
