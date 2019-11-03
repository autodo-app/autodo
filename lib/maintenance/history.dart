import 'package:flutter/material.dart';
import 'package:autodo/blocs/todo.dart';

class MaintenanceHistory extends StatefulWidget {
  @override
  MaintenanceHistoryState createState() => MaintenanceHistoryState();
}

class MaintenanceHistoryState extends State<MaintenanceHistory> {
  @override
  Widget build(BuildContext context) => TodoBLoC().items();
}
