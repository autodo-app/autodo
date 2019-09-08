import 'package:flutter/material.dart';

class RefuelingItem {
  String key, uuid;
  DateTime date;
  int odom;
  double cost, amount, mpg = double.infinity, costpergal = double.infinity;
  List<String> tags = [];

  RefuelingItem(
      {@required this.key,
      @required this.uuid,
      @required this.odom,
      @required this.cost,
      @required this.amount}) {
    if (this.cost != null && this.amount != null) {
      this.costpergal = this.cost / this.amount;
    } else {
      print('Error, refueling item created with null values');
    }
  }

  void addPrevOdom(int prevOdom) {
    this.mpg = (this.odom - prevOdom) / this.amount;
  }

  @override
  String toString() {
    return this.odom.toString() + this.cost.toString() + this.amount.toString();
  }

  toJSON() {
    return {'odom': this.odom, 'cost': this.cost, 'amount': this.amount};
  }

  RefuelingItem.empty();
}
