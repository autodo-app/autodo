import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../integ_test_keys.dart';
import '../../../models/models.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key key}) : super(key: key);

  void onDismissed(
      DismissDirection direction, BuildContext context, Todo todo) {
    BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
    Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
      context: context,
      todo: todo,
      onUndo: () => BlocProvider.of<TodosBloc>(context).add(AddTodo(todo)),
    ));
  }

  Future<void> onTap(BuildContext context, Todo todo) async {
    // final removedTodo = await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => DetailsScreen(id: todo.id),
    //   ),
    // );
  }

  void onCheckboxChanged(BuildContext context, Todo todo) {
    BlocProvider.of<TodosBloc>(context).add(
      UpdateTodo(todo.copyWith(completed: !todo.completed)),
    );
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
          builder: (context, state) {
        if (state is FilteredTodosLoading) {
          return LoadingIndicator();
        } else if (state is FilteredTodosLoaded) {
          final todos = state.filteredTodos;
          return ListView.builder(
            key: IntegrationTestKeys.todosScreenScroller,
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TodoCard(
                    key: UniqueKey(),
                    todo: todo,
                    onDismissed: (direction) =>
                        onDismissed(direction, context, todo),
                    onTap: () => onTap(context, todo),
                    onCheckboxChanged: (_) => onCheckboxChanged(context, todo),
                    emphasized: index == 0,
                  ));
            },
          );
        } else {
          return Container();
        }
      });
}

class TodoListCard extends StatelessWidget {
  const TodoListCard(this.todo);

  final Todo todo;

  // @override
  // Widget build(BuildContext context) => ListTile(
  //   leading: Transform.scale(
  //     scale: 1.5,
  //     child: Checkbox(
  //     value: false,
  //     onChanged: (_) {},
  //   ),),
  //   title: Text(todo.name),
  //   subtitle: Text('Due at ${todo.dueMileage} mi'),
  //   trailing: IntrinsicWidth(
  //     child: Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       CarTag(
  //         text: '2015 Sonic'
  //       ),
  //       Expanded(
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Expanded(child: Icon(Icons.edit)),
  //             Expanded(child: Icon(Icons.delete)),
  //           ],
  //         )
  //       )
  //     ],
  //   ),)
  // );
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 15, 15, 15),
          child: SizedBox(
            height: 28,
            width: 28,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.white
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              // child: Container(),
            )
          )
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(todo.name, style: TextStyle(fontSize: 24)),
              SizedBox(height: 10,),
              Text('Due at ${todo.dueMileage} mi', style: TextStyle(fontSize: 16))
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CarTag(text: '2015 Sonic',),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit),
                  Icon(Icons.delete),
                ]
              )
            ],
          ),
        ),
      ],
    )
  );
}

class TodoListCardWithHeader extends StatelessWidget {
  const TodoListCardWithHeader({this.todo, this.dueState});

  final Todo todo;
  final TodoDueState dueState;

  @override
  Widget build(BuildContext context) {
    String headerText;
    if (dueState == TodoDueState.PAST_DUE) {
      headerText = 'Past Due';
    } else if (dueState == TodoDueState.DUE_SOON) {
      headerText = 'Due Soon';
    } else if (dueState == TodoDueState.UPCOMING) {
      headerText = 'Upcoming';
    } else if (dueState == TodoDueState.COMPLETE) {
      headerText = 'Completed';
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
        TodoListCard(todo),
      ],
    );
  }
}

class TodosPanel extends StatelessWidget {
  const TodosPanel({this.todos, this.cars});

  final List<Todo> todos;
  final List<Car> cars;

  @override
  Widget build(BuildContext context) => Container(
    height: 10000,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      color: Theme.of(context).cardColor,
    ),
    child: ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final curTodo = todos[index];
        final curDueState = TodosBloc.calcDueState(cars.firstWhere((c) => c.name == curTodo.carName), curTodo);
        if (index == 0) {
          // the first ToDo always needs a label
          return TodoListCardWithHeader(
            todo: curTodo,
            dueState: curDueState,
          );
        }
        final prevTodo = todos[index - 1];
        final prevDueState = TodosBloc.calcDueState(cars.firstWhere((c) => c.name == prevTodo.carName), prevTodo);
        if (curDueState != prevDueState) {
          return TodoListCardWithHeader(
            todo: curTodo,
            dueState: curDueState,
          );
        }

        return TodoListCard(curTodo);
      },
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
    builder: (context, carsState) => BlocBuilder<TodosBloc, TodosState>(
      builder: (context, todosState) {
        if (!(todosState is TodosLoaded) || !(carsState is CarsLoaded)) {
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
                  todos: (todosState as TodosLoaded).todos,
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