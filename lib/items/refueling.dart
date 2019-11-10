import 'package:autodo/blocs/refueling.dart';
import 'package:flutter/material.dart';

class RefuelingItem {
  String ref, carName;
  DateTime date;
  int odom;
  double cost, amount, mpg = double.infinity, costpergal = double.infinity;
  List<String> tags = [];

  RefuelingItem(
      {@required this.ref,
      @required this.odom,
      @required this.cost,
      @required this.amount,
      @required this.carName}) {
    if (this.cost != null && this.amount != null) {
      this.costpergal = this.cost / this.amount;
    } else {
      print('Error, refueling item created with null values');
    }
    RefuelingBLoC().calculateEfficiency(this)
      .then((diff) {
        if (diff != RefuelingBLoC.MAX_MPG)
          this.mpg = diff / this.amount;
      });
  }

  toJSON() {
    return {
      'odom': this.odom, 
      'cost': this.cost, 
      'amount': this.amount, 
      'tags': [this.carName]};
  }

  RefuelingItem.empty();
}
