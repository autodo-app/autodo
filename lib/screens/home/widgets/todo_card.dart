import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../units/units.dart';
import '../../../widgets/widgets.dart';
import 'rounded_checkbox.dart';
import 'todo_delete_button.dart';
import 'todo_edit_button.dart';

class TodoListCard extends StatelessWidget {
  const TodoListCard({this.todo, this.car, this.onDelete});

  final Todo todo;
  final Car car;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Dismissible(
    key: ValueKey('__${todo.id}_dismissible_key__'),
    onDismissed: (_) { onDelete(); },
    dismissThresholds: {
      // must move halfway across the screen
      DismissDirection.horizontal: 0.5
    },
    direction: DismissDirection.endToStart,
    background: Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(JsonIntl.of(context).get(IntlKeys.deleteTodo)),
          SizedBox(width: 5),
          Icon(Icons.delete),
          SizedBox(width: 10),
        ],
      )
    ),
    child: Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 15, 15),
            child: RoundedCheckbox(
              initialValue: todo.completed,
              onTap: (completed) {
                BlocProvider.of<TodosBloc>(context).add(
                  UpdateTodo(
                    todo.copyWith(
                      completed: completed,
                      completedDate: completed ? DateTime.now() : null)));
              }
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todo.name, style: TextStyle(fontSize: 24)),
                SizedBox(height: 10,),
                if (todo.dueMileage != null && todo.dueDate == null)
                  RichText(
                    text: TextSpan(children: [
                    // TODO: Improve this translation
                    TextSpan(
                        text: '${JsonIntl.of(context).get(IntlKeys.dueAt)} ',
                        style: Theme.of(context).primaryTextTheme.bodyText2),
                    TextSpan(
                      text: Distance.of(context).format(todo.dueMileage),
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                      children: [TextSpan(text: ' ')],
                    ),
                    TextSpan(
                      text: Distance.of(context).unitString(context, short: true),
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                    )
                  ])),
                if (todo.dueDate != null && todo.dueMileage == null)
                  Text(
                    // Todo: Improve this translation
                    '${JsonIntl.of(context).get(IntlKeys.dueOn)} ${DateFormat.yMd().format(todo.dueDate)}',
                    style: Theme.of(context).primaryTextTheme.bodyText2),
                if (todo.dueDate != null && todo.dueMileage != null)
                  Text(
                    // Todo: Improve this translation
                    '${JsonIntl.of(context).get(IntlKeys.dueBy)} ${DateFormat.yMd().format(todo.dueDate)} ${JsonIntl.of(context).get(IntlKeys.or)} '
                    '${Distance.of(context).format(todo.dueMileage)} ${Distance.of(context).unitString(context, short: true)}',
                    style: Theme.of(context).primaryTextTheme.bodyText2),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: CarTag(car: car)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TodoEditButton(todo: todo),
                    TodoDeleteButton(todo: todo, onDelete: onDelete),
                  ]
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}