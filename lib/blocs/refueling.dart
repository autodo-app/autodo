import 'package:flutter/material.dart';
import 'package:autodo/refueling/refuelingcard.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/base.dart';

class RefuelingBLoC extends BLoC {
  @override
  Widget buildItem(dynamic snap, int index) {
    var odom = snap.data['odom'].toInt();
    var cost;
    if (snap.data['cost'] != null)
      cost = snap.data['cost'].toDouble();
    else
      cost = 0.0;
    var amount = snap.data['amount'].toDouble();
    var carName = snap.data['tags'][0];
    var item = RefuelingItem(
        ref: snap.documentID, odom: odom, cost: cost, amount: amount, carName: carName);
    return RefuelingCard(item: item);
  }

  StreamBuilder items() {
    return buildList('refuelings', 'carName');
  }

  Future<void> push(RefuelingItem item) async {
    await pushItem('refuelings', item);
  }

  void edit(RefuelingItem item) {
    editItem('refuelings', item);
  }

  void delete(RefuelingItem item) {
    deleteItem('refuelings', item);
  }

  void undo() {
    undoItem('refuelings');
  }

  // Make the object a Singleton
  static final RefuelingBLoC _bloc = RefuelingBLoC._internal();
  factory RefuelingBLoC() {
    return _bloc;
  }
  RefuelingBLoC._internal();
}
