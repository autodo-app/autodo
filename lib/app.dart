import 'package:flutter/material.dart';
import 'package:autodo/state.dart';
import 'package:autodo/maintenancetodo.dart';
import 'package:autodo/screens/homescreen.dart';

class VanillaApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VanillaAppState();
  }
}

class VanillaAppState extends State<VanillaApp> {
  static CarState carState;

  @override
  void initState() {
    super.initState();

    // Eventually put the code for loading an old session's data
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      // theme: Theme(),
      home: HomeScreen(
        carState: carState,
        // addMaintenanceTodo: addMaintenanceTodo,
        // removeMaintenanceTodo: removeMaintenanceTodo,
        // updateMaintenanceTodo: updateMaintenanceTodo,
        // appstate, callbacks, etc.
      ),
      // routes: {
      //   // '/maintenance': Widget.build(),
      //   // '/fuel': context,
      // },
    );
  }

  void addMaintenanceTodo(MaintenanceTodo todo) {
    setState(() {
      carState.todos.add(todo);
    });
  }

  void removeMaintenanceTodo(MaintenanceTodo todo) {
    setState(() {
      carState.todos.remove(todo);
    });
  }

  void updateMaintenanceTodo(MaintenanceTodo todo,
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
