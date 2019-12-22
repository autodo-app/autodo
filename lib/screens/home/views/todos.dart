import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/screens/details/barrel.dart';
import 'package:autodo/screens/add_edit/barrel.dart';

const int DUE_SOON_INTERVAL = 100;

class _TodoTitle extends StatelessWidget {
  final Todo todo;

  _TodoTitle({Key key, @required this.todo}) : super(key: key);

  preface() {
    if (todo.dueState == TodoDueState.PAST_DUE) {
      return AutodoLocalizations.pastDue;
    } else if (todo.dueState == TodoDueState.DUE_SOON) {
      return AutodoLocalizations.dueSoon;
    } else {
      return AutodoLocalizations.upcoming;
    }
  }

  @override 
  build(context) => RichText(  
    text: TextSpan(
      children: [ 
        TextSpan(
          text: preface(),
          style: Theme.of(context).primaryTextTheme.subtitle
        ),
        TextSpan(  
          text: todo.name,
          style: Theme.of(context).primaryTextTheme.title
        )
      ]
    )
  );
}

class _TodoCheckbox extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool> onCheckboxChanged;

  _TodoCheckbox({  
    Key key,
    @required this.todo,
    @required this.onCheckboxChanged,
  }) : super(key: key);

  @override 
  build(context) => Transform.scale(  
    scale: 1.5,
    child: Container(  
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Checkbox(  
        value: todo.completed,
        onChanged: onCheckboxChanged,
        checkColor: Theme.of(context).primaryColor,
        activeColor: Colors.white,
      )
    )
  );
}

class _TodoDueDate extends StatelessWidget {
  final Todo todo;

  _TodoDueDate({Key key, @required this.todo}) : super(key: key);

  @override 
  build(context) => Row(  
    children: <Widget>[ 
      Icon(Icons.alarm, size: 30),
      Text(  
        AutodoLocalizations.dueOn + ' ' + AutodoLocalizations.dateFormat(todo.dueDate),
        style: Theme.of(context).primaryTextTheme.body1
      ),
    ],
  );
}

class _TodoDueMileage extends StatelessWidget {
  final Todo todo;
  final commaRegex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  _TodoDueMileage({Key key, @required this.todo}) : super(key: key);
  
  mileageString() {
    if (todo.dueMileage != null) {
      return todo.dueMileage.toString()
          .replaceAllMapped(commaRegex, (Match m) => "${m[1]},");
    } else {
      return "";
    }
  }

  @override 
  build(context) => Row(  
    children: <Widget>[  
      Icon(Icons.pin_drop, size: 30),
      Padding(padding: EdgeInsets.all(5)),
      RichText(  
        text: TextSpan( 
          children: [
            TextSpan( 
              text: AutodoLocalizations.dueAt + ' ',
              style: Theme.of(context).primaryTextTheme.body1
            ),
            TextSpan(  
              text: mileageString(),
              style: Theme.of(context).primaryTextTheme.subtitle
            ),
            TextSpan(
              text: ' ' + AutodoLocalizations.distanceUnits,
              style: Theme.of(context).primaryTextTheme.body1, 
            )
          ]
        )
      )
    ],
  );
}

class _TodoLastCompleted extends StatelessWidget {
  final Todo todo;

  _TodoLastCompleted({Key key, @required this.todo}) : super(key: key);

  @override 
  build(context) => Row(  
    children: <Widget>[
      Icon(
        (todo.completed) ? Icons.alarm : Icons.new_releases, 
        size: 30
      ),
      Padding(padding: EdgeInsets.all(5)),
      Text(  
        AutodoLocalizations.firstTimeDoingTask, // TODO adjust this for past completed
        style: Theme.of(context).primaryTextTheme.body1,
      ),
    ],
  );
}

class _TodoDueInfo extends StatelessWidget {
  final Todo todo;

  _TodoDueInfo({Key key, @required this.todo}) : super(key: key);

  @override
  build(context) => Container(  
    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
    child: Column(  
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _TodoDueDate(todo: todo),
        Padding(padding: EdgeInsets.all(5)),
        _TodoDueMileage(todo: todo),
        Padding(padding: EdgeInsets.all(5)),
        _TodoLastCompleted(todo: todo),
      ],
    ),
  );
}

class _TodoBody extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool> onCheckboxChanged;

  _TodoBody({
    Key key,
    @required this.todo,
    @required this.onCheckboxChanged
  }) : super(key: key);

  @override 
  build(context) => Container(  
    padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
    child: Row(  
      children: <Widget>[
        _TodoCheckbox(todo: todo, onCheckboxChanged: onCheckboxChanged),
        Container(  
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: VerticalDivider(  
            color: Colors.white.withAlpha(230)
          )
        ),
        _TodoDueInfo(todo: todo),
      ],
    ),
  );
}

class _TodoDeleteButton extends StatelessWidget {
  final Todo todo;

  _TodoDeleteButton({Key key, @required this.todo}) : super(key: key);

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
        Scaffold.of(context).showSnackBar(
          DeleteTodoSnackBar(
            todo: todo,
            onUndo: () => BlocProvider.of<TodosBloc>(context)
              .add(AddTodo(todo)),
          )
        );
      },
    ),
  );
}

class _TodoEditButton extends StatelessWidget {
  final Todo todo;

  _TodoEditButton({Key key, @required this.todo}) : super (key: key);

  @override 
  build(context) => ButtonTheme.fromButtonThemeData(
    data: ButtonThemeData(
      minWidth: 0,
    ),
    child: FlatButton(
      child: Icon(
        Icons.edit,
        color: Theme.of(context).primaryIconTheme.color,
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoAddEditScreen(
            isEditing: true,
            onSave: (dueDate, dueMileage, repeatName, carNames) {
              for (var car in carNames) {
                if (car == todo.carName) {
                  // update existing
                  var out = todo.copyWith(dueDate: dueDate, dueMileage: dueMileage, repeatName: repeatName);
                  BlocProvider.of<TodosBloc>(context).add(UpdateTodo(out));
                } else {
                  var out = Todo(  
                    dueDate: dueDate,
                    dueMileage: dueMileage,
                    repeatName: repeatName,
                    carName: car,
                  );
                  BlocProvider.of<TodosBloc>(context).add(AddTodo(out));
                }
              }
            },
            todo: todo,
          ),
        ),
      ),
    ),
  );
}

class _TodoFooter extends StatelessWidget {
  final Todo todo;

  _TodoFooter({Key key, @required this.todo}) : super(key: key);

  @override 
  build(context) => Row(  
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _TodoEditButton(todo: todo),
        _TodoDeleteButton(todo: todo),
      ],
    )
    ],
  );
}

class _TodoCard extends StatelessWidget {
  final Todo todo;
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final bool emphasized;

  static final grad1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [mainColors[300], mainColors[400]]);
  static final grad2 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [mainColors[700], mainColors[900]]);
  final BoxDecoration upcomingDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      gradient: LinearGradient.lerp(grad1, grad2, 0.5));

  static final grad3 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.yellow.shade700, Colors.yellow.shade800]);
  static final grad4 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.yellow.shade800, Colors.orange.shade300]);
  final BoxDecoration duesoonDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      gradient: LinearGradient.lerp(grad3, grad4, 0.5));

  static final grad5 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.red.shade300, Colors.red.shade600]);
  static final grad6 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.orange.shade800, Colors.red.shade500]);
  final BoxDecoration pastdueDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      gradient: LinearGradient.lerp(grad5, grad6, 0.4));

  _TodoCard({
    Key key,
    @required this.todo, 
    @required this.onDismissed, 
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.emphasized,
  }) : super(key: key);

  emphasizedDecoration(todo) {
    if (todo.dueState == TodoDueState.PAST_DUE) {
      return pastdueDecoration;
    } else if (todo.dueState == TodoDueState.DUE_SOON) {
      return duesoonDecoration;
    } else {
      return upcomingDecoration;
    }
  }

  @override 
  build(context) => Dismissible( 
    key: Key("__dismissable__"), // todo: should this be global?
    onDismissed: onDismissed,
    child: Card(  
      elevation: (emphasized) ? 16 : 4,
      color: (emphasized) ? Colors.transparent : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(  
        decoration: (emphasized) ? emphasizedDecoration(todo) : BoxDecoration(),
        child: Column(  
          children: <Widget>[
            _TodoTitle(todo: todo),
            _TodoBody(todo: todo, onCheckboxChanged: onCheckboxChanged),
            _TodoFooter(todo: todo),
          ],
        )
      ),
    ),
  );
}

class TodosScreen extends StatelessWidget {
  TodosScreen({Key key}) : super(key: key);

  onDismissed(direction, context, todo) {
    BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
    Scaffold.of(context).showSnackBar(
      DeleteTodoSnackBar(
        todo: todo,
        onUndo: () => BlocProvider.of<TodosBloc>(context)
          .add(AddTodo(todo)),
      )
    );
  }

  onTap(context, todo) async {
    final removedTodo = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailsScreen(id: todo.id),
      ),
    );
    if (removedTodo != null) {
      Scaffold.of(context).showSnackBar(
        DeleteTodoSnackBar(
          todo: todo,
          onUndo: () => BlocProvider.of<TodosBloc>(context)
              .add(AddTodo(todo)),
        )
      );
    }
  }

  onCheckboxChanged(context, todo) {
    BlocProvider.of<TodosBloc>(context).add(
      UpdateTodo(todo.copyWith(complete: !todo.complete)),
    );
  }

  @override 
  build(context) => BlocBuilder<FilteredTodosBloc, FilteredTodosState>(  
    builder: (context, state) {
      if (state is FilteredTodosLoading) {
        return LoadingIndicator();
      } else if (state is FilteredTodosLoaded) {
        final todos = state.filteredTodos;
        return ListView.builder(  
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Padding( 
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: _TodoCard(
                todo: todo,
                onDismissed: (direction) => 
                    onDismissed(direction, context, todo),
                onTap: () => onTap(context, todo),
                onCheckboxChanged: (_) => onCheckboxChanged(context, todo),
                emphasized: index == 0, 
              )
            );
          },
        );
      } else {
        return Container();
      }
    }
  );
}