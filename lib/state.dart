import './maintenancetodo.dart';

class CarState {
  List<MaintenanceTodo> todos;

  CarState({this.todos = const []});

  void completeTodo(index) {
    todos.remove(index);
  }
}
