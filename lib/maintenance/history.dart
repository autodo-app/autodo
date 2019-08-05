import 'package:autodo/items/maintenancetodo.dart';
import 'package:flutter/material.dart';
import 'package:autodo/blocs/todo.dart';
import './todocard.dart';

import 'dart:async';

class MaintenanceHistory extends StatefulWidget {
  @override
  State<MaintenanceHistory> createState() {
    return MaintenanceHistoryState();
  }
}

class MaintenanceHistoryState extends State<MaintenanceHistory> {
  List<MaintenanceTodoItem> todos = [];
  StreamSubscription<MaintenanceTodoItem> subscription;

  @override
  void initState() {
    subscription = todoBLoC.stream.listen((value) {
      setState(() {
        todos.add(value);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  FirebaseTodoBLoC fb = FirebaseTodoBLoC();

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: ListView.builder(
      //     itemCount: todos.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       final todo = todos[index];

      //       return MaintenanceTodoCard(item: todo);
      //     }),
      child: fb.buildList(context),
    );
  }
}
