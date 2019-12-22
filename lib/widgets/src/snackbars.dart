import 'package:flutter/material.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/localization.dart';

class DeleteTodoSnackBar extends SnackBar {
  DeleteTodoSnackBar({
    Key key,
    @required Todo todo,
    @required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            AutodoLocalizations.todoDeleted(todo.name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: AutodoLocalizations.undo,
            onPressed: onUndo,
          ),
        );
}

class DeleteRefuelingSnackBar extends SnackBar {
  DeleteRefuelingSnackBar({
    Key key,
    @required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            AutodoLocalizations.refuelingDeleted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: AutodoLocalizations.undo,
            onPressed: onUndo,
          ),
        );
}