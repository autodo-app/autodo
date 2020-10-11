import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';
import 'constants.dart';

const TODOS_SECTION_LIMIT = 5;

class _TodoListHeader extends StatelessWidget {
  const _TodoListHeader(this.dueState);

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
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(headerText,
              style: Theme.of(context).primaryTextTheme.subtitle2),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Divider(),
        ),
      ],
    );
  }
}

class _TodoListSection extends StatefulWidget {
  const _TodoListSection(
      {this.dueState, this.todos, this.cars, this.deleteTodo});

  final TodoDueState dueState;
  final List<Todo> todos;
  final List<Car> cars;
  final Function(BuildContext, Todo) deleteTodo;

  @override
  _TodoListSectionState createState() => _TodoListSectionState();
}

class _TodoListSectionState extends State<_TodoListSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.todos?.isEmpty ?? true) {
      return Container();
    }

    int listLength;
    if (expanded) {
      listLength = widget.todos.length + 1;
    } else {
      // Limit the list length to TODOS_SECTION_LIMIT
      listLength = widget.todos.length < TODOS_SECTION_LIMIT
          ? widget.todos.length
          : TODOS_SECTION_LIMIT;
    }
    return Column(
      children: [
        _TodoListHeader(widget.dueState),
        ...List.generate(
          listLength,
          (index) {
            if (!expanded && index == (TODOS_SECTION_LIMIT - 1)) {
              return Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  child: Text(JsonIntl.of(context).get(IntlKeys.showMore),
                      style: Theme.of(context).primaryTextTheme.overline),
                  onPressed: () {
                    setState(() {
                      expanded = true;
                    });
                  },
                ),
              ); // more button
            } else if (expanded && index == (listLength - 1)) {
              return Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  child: Text(
                    JsonIntl.of(context).get(IntlKeys.showLess),
                    style: Theme.of(context).primaryTextTheme.overline,
                  ),
                  onPressed: () {
                    setState(() {
                      expanded = false;
                    });
                  },
                ),
              ); // more button
            }
            return TodoListCard(
                todo: widget.todos[index],
                car: widget.cars
                    .firstWhere((c) => c.id == widget.todos[index].carId),
                onDelete: () {
                  widget.deleteTodo(context, widget.todos[index]);
                });
          },
        ),
      ],
    );
  }
}

class _TodosPanel extends StatefulWidget {
  const _TodosPanel(
      {@required this.todos, @required this.cars, @required this.onDeleteTodo});

  final Map<TodoDueState, List<Todo>> todos;
  final List<Car> cars;
  final Function(BuildContext, Todo) onDeleteTodo;

  @override
  _TodosPanelState createState() => _TodosPanelState(todos);
}

class _TodosPanelState extends State<_TodosPanel> {
  _TodosPanelState(this.todos);

  Map<TodoDueState, List<Todo>> todos;

  void _deleteTodo(BuildContext context, Todo todo) {
    widget.onDeleteTodo(context, todo);
    // removing the todo from our local list for a quicker response than waiting
    // on the Bloc to rebuild
    setState(() {
      todos[todo.dueState].remove(todo);
    });
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
      constraints: BoxConstraints(
          // not sure why 24 works, assuming it's from some padding somewhere
          minHeight: MediaQuery.of(context).size.height -
              HEADER_HEIGHT -
              kBottomNavigationBarHeight -
              24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonTheme.fromButtonThemeData(
                data: ButtonThemeData(
                  minWidth: 0,
                ),
                child: FlatButton(
                  child: Icon(Icons.search),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                            title: Text(JsonIntl.of(context)
                                .get(IntlKeys.toBeImplemented))));
                  },
                ),
              ),
              ExtraActions(),
              SizedBox(
                width: 10,
              ), // padding
            ],
          ),
          // Header above, actual ToDos below
          _TodoListSection(
            todos: todos[TodoDueState.PAST_DUE],
            cars: widget.cars,
            dueState: TodoDueState.PAST_DUE,
            deleteTodo: _deleteTodo,
          ),
          _TodoListSection(
            todos: todos[TodoDueState.DUE_SOON],
            cars: widget.cars,
            dueState: TodoDueState.DUE_SOON,
            deleteTodo: _deleteTodo,
          ),
          _TodoListSection(
            todos: todos[TodoDueState.UPCOMING],
            cars: widget.cars,
            dueState: TodoDueState.UPCOMING,
            deleteTodo: _deleteTodo,
          ),
          _TodoListSection(
            todos: todos[TodoDueState.COMPLETE],
            cars: widget.cars,
            dueState: TodoDueState.COMPLETE,
            deleteTodo: _deleteTodo,
          ),
        ],
      ));
}

class _TodoAlert extends StatelessWidget {
  const _TodoAlert(this.todos);

  final Map<TodoDueState, List<Todo>> todos;

  @override
  Widget build(BuildContext context) {
    if (todos[TodoDueState.PAST_DUE]?.isNotEmpty ?? false) {
      return Flexible(
        fit: FlexFit.loose,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.priority_high, color: alertRed),
            Text(
              JsonIntl.of(context).count(
                todos[TodoDueState.PAST_DUE].length,
                IntlKeys.lateTodo,
              ),
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(color: alertRed),
            )
          ],
        ),
      );
    } else if (todos[TodoDueState.DUE_SOON]?.isNotEmpty ?? false) {
      return Flexible(
        fit: FlexFit.loose,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, color: warningOrange),
            Text(
              JsonIntl.of(context).count(
                todos[TodoDueState.DUE_SOON].length,
                IntlKeys.dueSoonTodo,
              ),
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(color: warningOrange),
            )
          ],
        ),
      );
    }
    return Container();
  }
}

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) => Container(
          decoration: headerDecoration,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: HEADER_HEIGHT,
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        JsonIntl.of(context).get(IntlKeys.todos),
                        style: Theme.of(context).accentTextTheme.headline1,
                      ),
                    ),
                    _TodoAlert(vm.filteredTodos),
                  ]),
                  titlePadding: EdgeInsets.all(15),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: _TodosPanel(
                  todos: vm.filteredTodos,
                  cars: vm.cars,
                  onDeleteTodo: vm.onDeleteTodo,
                ),
              ),
            ],
          ),
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel(
      {@required this.filteredTodos,
      @required this.cars,
      @required this.onDeleteTodo});

  // TODO: filter the todos
  final Map<TodoDueState, List<Todo>> filteredTodos;
  final List<Car> cars;
  final Function(BuildContext, Todo) onDeleteTodo;

  static _ViewModel fromStore(Store<AppState> store) {
    if (store.state.dataState.status == DataStatus.IDLE) {
      store.dispatch(fetchData());
    }
    return _ViewModel(
        cars: store.state.dataState.cars,
        // todos: store.state.dataState.todos,
        filteredTodos: {}, // TODO
        onDeleteTodo: (context, todo) {
          store.dispatch(deleteTodo(todo));
          Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
            context: context,
            todo: todo,
            onUndo: () => store.dispatch(createTodo(todo)),
          ));
        });
  }

  @override
  List get props => [];
}
