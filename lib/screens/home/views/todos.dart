import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';

class TodoListHeader extends StatelessWidget {
  const TodoListHeader(this.dueState);

  final TodoDueState dueState;

  @override
  Widget build(BuildContext context) {
    String headerText;
    if (dueState == TodoDueState.PAST_DUE) {
      headerText = JsonIntl.of(context).get(IntlKeys.pastDue);
    } else if (dueState == TodoDueState.DUE_SOON) {
      headerText = JsonIntl.of(context).get(IntlKeys.dueSoon);
    } else if (dueState == TodoDueState.UPCOMING) {
      headerText = JsonIntl.of(context).get(IntlKeys.upcoming);
    } else if (dueState == TodoDueState.COMPLETE) {
      headerText = JsonIntl.of(context).get(IntlKeys.completed);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
          child: Text(headerText),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Divider(),
        ),
      ],
    );
  }
}

class TodosPanel extends StatefulWidget {
  const TodosPanel({this.todos, this.cars});

  final Map<TodoDueState, List<Todo>> todos;
  final List<Car> cars;

  @override
  TodosPanelState createState() => TodosPanelState(todos);
}

class TodosPanelState extends State<TodosPanel> {
  TodosPanelState(this.todos);

  Map<TodoDueState, List<Todo>> todos;

  void deleteTodo(context, todo) {
    BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
    Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
      context: context,
      todo: todo,
      onUndo: () => BlocProvider.of<TodosBloc>(context).add(AddTodo(todo)),
    ));
    // removing the todo from our local list for a quicker response than waiting
    // on the Bloc to rebuild
    setState(() {
      todos.remove(todo);
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      color: Theme.of(context).cardColor,
    ),
    child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.search), // TODO: make this do something
            Icon(Icons.more_vert), // TODO: make this do something
            SizedBox(width: 10,), // padding
          ],
        ),
        // Header above, actual ToDos below
        if (todos[TodoDueState.PAST_DUE]?.isNotEmpty ?? false)
          TodoListHeader(TodoDueState.PAST_DUE),
        if (todos[TodoDueState.PAST_DUE]?.isNotEmpty ?? false)
          ...List.generate(
            todos[TodoDueState.PAST_DUE].length,
            (index) => TodoListCard(
              todo: todos[TodoDueState.PAST_DUE][index],
              car: widget.cars.firstWhere((c) => c.name == todos[TodoDueState.PAST_DUE][index].carName),
              onDelete: () { deleteTodo(context, todos[TodoDueState.PAST_DUE][index]); })),
        if (todos[TodoDueState.DUE_SOON]?.isNotEmpty ?? false)
          TodoListHeader(TodoDueState.DUE_SOON),
        if (todos[TodoDueState.DUE_SOON]?.isNotEmpty ?? false)
          ...List.generate(
            todos[TodoDueState.DUE_SOON].length,
            (index) => TodoListCard(
              todo: todos[TodoDueState.DUE_SOON][index],
              car: widget.cars.firstWhere((c) => c.name == todos[TodoDueState.DUE_SOON][index].carName),
              onDelete: () { deleteTodo(context, todos[TodoDueState.DUE_SOON][index]); })),
        if (todos[TodoDueState.UPCOMING]?.isNotEmpty ?? false)
          TodoListHeader(TodoDueState.UPCOMING),
        if (todos[TodoDueState.UPCOMING]?.isNotEmpty ?? false)
          ...List.generate(
            todos[TodoDueState.UPCOMING].length,
            (index) => TodoListCard(
              todo: todos[TodoDueState.UPCOMING][index],
              car: widget.cars.firstWhere((c) => c.name == todos[TodoDueState.UPCOMING][index].carName),
              onDelete: () { deleteTodo(context, todos[TodoDueState.UPCOMING][index]); })),
        if (todos[TodoDueState.COMPLETE]?.isNotEmpty ?? false)
          TodoListHeader(TodoDueState.COMPLETE),
        if (todos[TodoDueState.COMPLETE]?.isNotEmpty ?? false)
          ...List.generate(
            todos[TodoDueState.COMPLETE].length,
            (index) => TodoListCard(
              todo: todos[TodoDueState.COMPLETE][index],
              car: widget.cars.firstWhere((c) => c.name == todos[TodoDueState.COMPLETE][index].carName),
              onDelete: () { deleteTodo(context, todos[TodoDueState.COMPLETE][index]); })),
      ],
    )
  );
}

class TodoAlert extends StatelessWidget {
  const TodoAlert(this.todos);

  final Map<TodoDueState, List<Todo>> todos;

  @override
  Widget build(BuildContext context) {
    if (todos[TodoDueState.PAST_DUE]?.isNotEmpty ?? false) {
      return Flexible(
        fit: FlexFit.loose,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.priority_high,
              color: Colors.red),
            Text('1 late ToDo')
          ],
        ), // use JsonIntl here eventually
      );
    } else if (todos[TodoDueState.DUE_SOON]?.isNotEmpty ?? false) {
      return Flexible(
        fit: FlexFit.loose,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications,
              color: Colors.red),
            Text('1 late ToDo')
          ],
        ), // // use JsonIntl here eventually
      );
    }
    return Container();
  }
}

class TodosScreen extends StatelessWidget {
  static final grad1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [mainColors[300], mainColors[400]]);

  static final grad2 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [mainColors[700], mainColors[900]]);

  final BoxDecoration upcomingDecoration = BoxDecoration(
      gradient: LinearGradient.lerp(grad1, grad2, 0.5));

  @override
  Widget build(BuildContext context) => BlocBuilder<CarsBloc, CarsState>(
    builder: (context, carsState) => BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (context, todosState) {
        if (!(todosState is FilteredTodosLoaded) || !(carsState is CarsLoaded)) {
          return Container();
        }

        return Container(
          decoration: upcomingDecoration,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 130.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(fit: FlexFit.loose, child: Text('ToDos')),
                      TodoAlert((todosState as FilteredTodosLoaded).filteredTodos),
                    ]
                  ),
                  titlePadding: EdgeInsets.all(15),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: TodosPanel(
                  todos: (todosState as FilteredTodosLoaded).filteredTodos,
                  cars: (carsState as CarsLoaded).cars
                ),
              ),
            ],
          )
        );
      }
    )
  );
}