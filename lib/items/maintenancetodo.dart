import 'package:flutter/material.dart';

class MaintenanceTodoItem {
  String name;
  DateTime dueDate;
  int dueMileage;

  MaintenanceTodoItem({@required this.name, this.dueDate, this.dueMileage});
}
