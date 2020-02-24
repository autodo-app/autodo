import 'package:flutter/material.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/localization.dart';
import 'package:json_intl/json_intl.dart';

class DeleteTodoSnackBar extends SnackBar {
  DeleteTodoSnackBar({
    Key key,
    @required Todo todo,
    @required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            JsonIntl.of(context).get(IntlKeys.todoDeleted, {'name': todo.name}),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: JsonIntl.of(context).get(IntlKeys.undo),
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
            JsonIntl.of(context).get(IntlKeys.refuelingDeleted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: JsonIntl.of(context).get(IntlKeys.undo),
            onPressed: onUndo,
          ),
        );
}

class DeleteRepeatSnackBar extends SnackBar {
  DeleteRepeatSnackBar({
    Key key,
    @required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            JsonIntl.of(context).get(IntlKeys.repeatDeleted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: JsonIntl.of(context).get(IntlKeys.undo),
            onPressed: onUndo,
          ),
        );
}
