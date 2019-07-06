import 'package:autodo/items/items.dart';

class AutodoState {
  List<MaintenanceTodoItem> todos = [];

  AutodoState() {
    this.todos.add(
        MaintenanceTodoItem(name: 'Test 1', dueDate: DateTime(1900, 01, 01)));
    this.todos.add(MaintenanceTodoItem(name: 'Test 2', dueMileage: 20000));
  }

  void completeTodo(index) {
    todos.remove(index);
  }

  void addTodo(MaintenanceTodoItem item) {
    this.todos.add(item);
  }
}
