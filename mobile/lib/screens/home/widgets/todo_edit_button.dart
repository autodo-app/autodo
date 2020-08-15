import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../add_edit/barrel.dart';

class TodoEditButton extends StatelessWidget {
  const TodoEditButton({Key key, @required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) => ButtonTheme.fromButtonThemeData(
        data: ButtonThemeData(
          minWidth: 0,
        ),
        child: FlatButton(
          key: ValueKey('__todo_card_edit_${todo.name}'),
          child: Icon(
            Icons.edit,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoAddEditScreen(
                    isEditing: true,
                    onSave: (name, dueDate, dueMileage, carId,
                        mileageRepeatInterval, dateRepeatInterval) {
                      final out = todo.copyWith(
                          name: name,
                          dueDate: dueDate,
                          dueMileage: dueMileage,
                          carId: carId,
                          mileageRepeatInterval: mileageRepeatInterval,
                          dateRepeatInterval: dateRepeatInterval);
                      BlocProvider.of<DataBloc>(context).add(UpdateTodo(out));
                    },
                    todo: todo,
                  ),
                ));
          },
        ),
      );
}
