import 'package:flutter/material.dart';
import 'package:autodo/state.dart';
import './todocard.dart';

class MaintenanceHistory extends StatefulWidget {
  final AutodoState autodoState;

  MaintenanceHistory({@required this.autodoState});

  @override
  State<MaintenanceHistory> createState() {
    return MaintenanceHistoryState();
  }
}

class MaintenanceHistoryState extends State<MaintenanceHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.autodoState.todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = widget.autodoState.todos[index];

            return MaintenanceTodoCard(item: todo);
          }),
    );
  }
}
