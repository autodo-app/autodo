import 'package:autodo/blocs/refueling.dart';
import 'package:flutter/material.dart';

class RefuelingItem {
  String ref, carName;
  DateTime date;
  int odom;
  double cost, amount, efficiency = double.infinity, costpergal = double.infinity;
  List<String> tags = [];

  RefuelingItem(
      {@required this.ref,
      @required this.odom,
      @required this.cost,
      @required this.amount,
      @required this.carName,
      this.efficiency,
      this.costpergal}) {
    if (this.cost != null && this.amount != null) {
      this.costpergal = this.cost / this.amount;
    } else {
      print('Error, refueling item created with null values');
    }
    if (this.efficiency == null) {
      RefuelingBLoC().findLatestRefueling(this)
      .then((prev) {
        if (prev == null) return;
        var dist = this.odom - prev.odom;
        if (dist != RefuelingBLoC.MAX_MPG)
          this.efficiency = dist / this.amount;
      });
    }
  }

  factory RefuelingItem.fromJSON(Map<String, dynamic> json, String ref) {
    var out = RefuelingItem(
      ref: ref, 
      odom: json['odom'] ?? 0,
      cost: json['cost'] ?? 0,
      amount: json['amount'] ?? 0,
      carName: json['carName'] ?? "",
      efficiency: json['efficiency'] ?? 0.0,
      costpergal: json['costpergal'] ?? 0.0,
    );
    out.date = (json['date'] == null) ? null : DateTime.fromMillisecondsSinceEpoch(json['date']);
    return out;
  }

  toJSON() {
    return {
      'odom': this.odom, 
      'cost': this.cost, 
      'amount': this.amount, 
      'date': this.date.millisecondsSinceEpoch,
      'efficiency': this.efficiency,
      'costpergal': this.costpergal,
      'tags': [this.carName]
    };
  }

  RefuelingItem.empty();
}
