import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../add_edit/barrel.dart';

class TodoEditButton extends StatelessWidget {
  const TodoEditButton({Key key, @required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) => StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) =>
            ButtonTheme.fromButtonThemeData(
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
                      cars: vm.cars,
                      onSave: (name, dueDate, dueMileage, carId,
                              mileageRepeatInterval, dateRepeatInterval) =>
                          vm.onUpdateTodo(todo, name, dueDate, dueMileage,
                              carId, mileageRepeatInterval, dateRepeatInterval),
                      todo: todo,
                    ),
                  ));
            },
          ),
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel({@required this.cars, @required this.onUpdateTodo});

  final List<Car> cars;
  final Function(Todo, String, DateTime, double, String, double, RepeatInterval)
      onUpdateTodo;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
      cars: store.state.dataState.cars,
      onUpdateTodo: (todo, name, dueDate, dueMileage, carId,
          mileageRepeatInterval, dateRepeatInterval) {
        store.dispatch(updateTodo(todo.copyWith(
          name: name,
          dueDate: dueDate,
          dueMileage: dueMileage,
          carId: carId,
          mileageRepeatInterval: mileageRepeatInterval,
          dateRepeatInterval: dateRepeatInterval,
        )));
      });

  @override
  List get props => [onUpdateTodo];
}
