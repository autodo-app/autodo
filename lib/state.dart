import 'package:autodo/items/items.dart';

class AutodoState {
  List<MaintenanceTodoItem> todos;

  AutodoState({this.todos = const []});

  void completeTodo(index) {
    todos.remove(index);
  }
}
