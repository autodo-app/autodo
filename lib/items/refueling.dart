import 'package:flutter/material.dart';

class RefuelingItem {
  DateTime date;
  int odom;
  double cost, amount, mpg = double.infinity, costpergal = double.infinity;
  List<String> tags = [];

  RefuelingItem({@required this.odom, this.cost, this.amount}) {
    if (this.cost != null && this.amount != null) {
      this.costpergal = this.cost / this.amount;
    } else {
      print('Error, refueling item created with null values');
    }
  }

  void addPrevOdom(int prevOdom) {
    this.mpg = (this.odom - prevOdom) / this.amount;
  }

  RefuelingItem.empty();
}
