import 'package:autodo/blocs/cars.dart';
import 'package:flutter/material.dart';
import 'package:autodo/refueling/refuelingcard.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';
import 'package:autodo/util.dart';

class RefuelingBLoC extends BLoC {
  static const int MAX_MPG = 0xffff;
  static const int HUE_RANGE = 60; // range of usable hues is 0-120, or +- 60
  static const double EFF_VAR = 5.0;
  static const double HUE_MAX = 360.0;

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

  Future<HSV> hsv(RefuelingItem item) async {
    if (item.efficiency == double.infinity)
      return HSV(1.0, 1.0, 1.0); 
    var car = await CarsBLoC().getCarByName(item.carName);
    var avgEff = car.averageEfficiency;
    // range is 0 to 120
    var diff = item.efficiency - avgEff;
    dynamic hue = (diff * HUE_RANGE) / EFF_VAR;
    hue = clamp(hue, 0, HUE_RANGE * 2);
    return HSV(hue.toDouble(), 1.0, 1.0);
  }

  // Make the object a Singleton
  static final RefuelingBLoC _bloc = RefuelingBLoC._internal();
  factory RefuelingBLoC() => _bloc;
  RefuelingBLoC._internal();
}
