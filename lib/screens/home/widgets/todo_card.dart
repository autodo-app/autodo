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


// TODO: figure out how to handle ToDos with due dates
class _TodoDueDate extends StatelessWidget {
  const _TodoDueDate({Key key, @required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Icon(Icons.alarm, size: 30),
          Text(
              // Todo: Improve this translation
              '${JsonIntl.of(context).get(IntlKeys.dueOn)} ${DateFormat.yMMMd().format(todo.dueDate)}',
              style: Theme.of(context).primaryTextTheme.bodyText2),
        ],
      );
}

class TodoListCard extends StatelessWidget {
  const TodoListCard({this.todo, this.car});

  final Todo todo;
  final Car car;

  @override
  Widget build(BuildContext context) => Dismissible(
    key: ValueKey('__${todo.id}_dismissible_key__'),
    onDismissed: (_) {
      BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
      Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
        context: context,
        todo: todo,
        onUndo: () => BlocProvider.of<TodosBloc>(context).add(AddTodo(todo)),
      ));
      // somehow force this card to be removed?
      // that may need to be handled by the parent
    },
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
          Text('Delete ToDo'),
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
                RichText(
                  text: TextSpan(children: [
                  // Todo: Improve this translation
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
                ]))
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
                    TodoDeleteButton(todo: todo), // also need to remove the card with this?
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