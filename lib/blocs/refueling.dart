import 'package:autodo/blocs/cars.dart';
import 'package:flutter/material.dart';
import 'package:autodo/refueling/refuelingcard.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';

class RefuelingBLoC extends BLoC {
  static const int MAX_MPG = 0xffff;

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
    return buildList('refuelings');
  }

  Future<void> push(RefuelingItem item) async {
    if (item.efficiency == double.infinity) {
      // efficiency has not yet been calculated
      var dist = await calcDistFromLatestRefueling(item);
      item.efficiency = dist / item.amount;
    }
    await CarsBLoC().updateMileage(item.carName, item.odom);
    await CarsBLoC().updateEfficiency(item.carName, item.efficiency);
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

  Future<int> calcDistFromLatestRefueling(RefuelingItem item) async {
    var car = (item.carName != null) ? item.carName : '';
    var doc = FirestoreBLoC().getUserDocument();
    var refuelings = await doc.collection('refuelings').getDocuments();
    
    int smallestDiff = MAX_MPG;
    for (var r in refuelings.documents) {
      if (r.data['tags'] != null && r.data['tags'][0] == car) {
        var mileage = r.data['odom'];
        var diff = item.odom - mileage;
        if (diff <= 0) continue; // only looking for past refuelings
        if (diff < smallestDiff) {
          smallestDiff = diff;
        }
      } 
    }
    return smallestDiff;
  }

  // Make the object a Singleton
  static final RefuelingBLoC _bloc = RefuelingBLoC._internal();
  factory RefuelingBLoC() {
    return _bloc;
  }
  RefuelingBLoC._internal();
}
