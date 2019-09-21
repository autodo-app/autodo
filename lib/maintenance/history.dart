import 'package:autodo/items/maintenancetodo.dart';
import 'package:flutter/material.dart';
import 'package:autodo/blocs/todo.dart';

class MaintenanceHistory extends StatefulWidget {
  @override
  State<MaintenanceHistory> createState() {
    return MaintenanceHistoryState();
  }
}

class MaintenanceHistoryState extends State<MaintenanceHistory> {
  List<MaintenanceTodoItem> todos = [];

  FirebaseTodoBLoC fb = FirebaseTodoBLoC();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      child: fb.buildList(context),
    );
  }
}
