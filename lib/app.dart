import 'package:flutter/material.dart';
import 'package:autodo/state.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/screens/screens.dart';

class AutodoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AutodoAppState();
  }
}

class AutodoAppState extends State<AutodoApp> {
  static AutodoState autodoState;

  @override
  void initState() {
    super.initState();

    autodoState = AutodoState();

    // Eventually put the code for loading an old session's data
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'auToDo',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
              autodoState: autodoState,
              addMaintenanceTodo: addMaintenanceTodo,
              // removeMaintenanceTodo: removeMaintenanceTodo,
              //   // updateMaintenanceTodo: updateMaintenanceTodo,
              //   // appstate, callbacks, etc.
            ),
        '/createTodo': (context) =>
            // CreateTodoScreen(addMaintenanceTodo: addMaintenanceTodo),
            CreateTodoScreen(),
      },
    );
  }

  void addMaintenanceTodo(MaintenanceTodoItem todo) {
    setState(() {
      autodoState.todos.add(todo);
    });
  }

  void removeMaintenanceTodo(MaintenanceTodoItem todo) {
    setState(() {
      autodoState.todos.remove(todo);
    });
  }

  void updateMaintenanceTodo(MaintenanceTodoItem todo,
      {String name, DateTime dueDate, int dueMileage}) {
    setState(() {
      todo.name = name ?? todo.name;
      todo.dueDate = dueDate ?? todo.dueDate;
      todo.dueMileage = dueMileage ?? todo.dueMileage;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);

    // save todos to repo
  }
}
