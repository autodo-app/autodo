import 'package:flutter/material.dart';

class RefuelingItem {
  String name;
  DateTime dueDate;
  int dueMileage;

  RefuelingItem({@required this.name, this.dueDate, this.dueMileage});

  RefuelingItem.empty();
}
