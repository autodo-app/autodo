import 'package:flutter/material.dart';
import 'package:autodo/blocs/todo.dart';

class MaintenanceHistory extends StatefulWidget {
  @override
  MaintenanceHistoryState createState() => MaintenanceHistoryState();
}

class MaintenanceHistoryState extends State<MaintenanceHistory> {
  FirebaseTodoBLoC fb = FirebaseTodoBLoC();
  @override
  Widget build(BuildContext context) {
    if (fb.isLoading()) {
      return Center(child: CircularProgressIndicator(),);
    } else {
      return Container(
        child: fb.buildList(context),
    );
    }
  }
}
