import 'package:flutter/material.dart';

class RefuelingItem {
  DateTime date;
  int odom;
  double cost, amount;

  RefuelingItem({@required this.odom, this.cost, this.amount});

  RefuelingItem.empty();
}
