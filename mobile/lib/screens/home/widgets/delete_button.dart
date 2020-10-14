import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key key, this.onDelete}) : super(key: key);

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => ButtonTheme.fromButtonThemeData(
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
