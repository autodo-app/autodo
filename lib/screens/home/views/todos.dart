import 'package:autodo/screens/home/views/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';



class TodoListCardWithHeader extends StatelessWidget {
  const TodoListCardWithHeader({this.todo, this.car, this.dueState, this.onDelete});

  final Todo todo;
  final Car car;
  final TodoDueState dueState;
  final VoidCallback onDelete;

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
        TodoListCard(todo: todo, car: car, onDelete: onDelete),
      ],
    );
  }
}

class TodosPanel extends StatefulWidget {
  const TodosPanel({this.todos, this.cars});

  final List<Todo> todos;
  final List<Car> cars;

  @override
  TodosPanelState createState() => TodosPanelState(todos);
}

class TodosPanelState extends State<TodosPanel> {
  TodosPanelState(this.todos);

  List<Todo> todos;

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
            Icon(Icons.search),
            Icon(Icons.more_vert),
            SizedBox(width: 10,), // padding
          ],
        ),
        // Header above, actual ToDos below
        ...List.generate(
          todos.length,
          (index) {
            final curTodo = todos[index];
            final curCar = widget.cars.firstWhere((c) => c.name == curTodo.carName);
            final curDueState = TodosBloc.calcDueState(curCar, curTodo);
            if (index == 0) {
              // the first ToDo always needs a label
              return TodoListCardWithHeader(
                todo: curTodo,
                car: curCar,
                dueState: curDueState,
                onDelete: () {
                  deleteTodo(context, curTodo);
                },
              );
            }
            final prevTodo = todos[index - 1];
            final prevDueState = TodosBloc.calcDueState(widget.cars.firstWhere((c) => c.name == prevTodo.carName), prevTodo);
            if (curDueState != prevDueState) {
              return TodoListCardWithHeader(
                todo: curTodo,
                car: curCar,
                dueState: curDueState,
                onDelete: () {
                  deleteTodo(context, curTodo);
                },
              );
            }

            return TodoListCard(
              todo: curTodo,
              car: curCar,
              onDelete: () {
                deleteTodo(context, curTodo);
              },
            );
          },
        )
      ],
    )
  );
}

class TodosScreen2 extends StatelessWidget {
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
                      Flexible(fit: FlexFit.loose, child: Text('1 late ToDo'))
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