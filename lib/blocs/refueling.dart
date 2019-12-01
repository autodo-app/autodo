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
  // don't know why anyone would enter this many, but preventing overflow here
  static const int MAX_NUM_REFUELINGS = 0xffff;

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
        ref: snap.documentID,
        odom: odom,
        cost: cost,
        amount: amount,
        carName: carName);
    return RefuelingCard(item: item);
  }

  StreamBuilder items() {
    return buildList('refuelings');
  }

  Future<void> push(RefuelingItem item) async {
    var prev = await findLatestRefueling(item);
    var dist = (prev == null) ? 0 : item.odom - prev.odom;
    if (item.efficiency == double.infinity) {
      // efficiency has not yet been calculated
      item.efficiency = dist / item.amount;
    }

    Car car = await CarsBLoC().getCarByName(item.carName);
    if (car.numRefuelings < MAX_NUM_REFUELINGS) car.numRefuelings++;
    car.updateMileage(item.odom, item.date);
    car.updateEfficiency(item.efficiency);
    car.updateDistanceRate((prev == null) ? null : prev.date, item.date, dist);
    CarsBLoC().edit(car);

    await pushItem('refuelings', item);
  }

  void edit(RefuelingItem item) async {
    // TODO: pull this into its own async function since it doesn't affect our
    // ability to update a refueling
    var prev = await findLatestRefueling(item);
    var dist = (prev == null) ? 0 : item.odom - prev.odom;
    item.efficiency = dist / item.amount;

    Car car = await CarsBLoC().getCarByName(item.carName);
    car.updateMileage(item.odom, item.date);
    car.updateEfficiency(item.efficiency);
    car.updateDistanceRate((prev == null) ? null : prev.date, item.date, dist);
    CarsBLoC().edit(car);

    editItem('refuelings', item);
  }

  void delete(RefuelingItem item) async {
    var prev = await findLatestRefueling(item);
    Car car = await CarsBLoC().getCarByName(item.carName);
    car.updateMileage(prev.odom, prev.date, override: true);
    // TODO: figure out how to undo the efficiency and distance rate calcs
    CarsBLoC().edit(car);

    deleteItem('refuelings', item);
  }

  void undo() {
    undoItem('refuelings');
  }

  Future<RefuelingItem> findLatestRefueling(RefuelingItem item) async {
    var car = (item.carName != null) ? item.carName : '';
    var doc = FirestoreBLoC().getUserDocument();
    var refuelings = await doc.collection('refuelings').getDocuments();

    int smallestDiff = MAX_MPG;
    RefuelingItem out;
    for (var r in refuelings.documents) {
      if (r.data['tags'] != null && r.data['tags'][0] == car) {
        var mileage = r.data['odom'];
        var diff = item.odom - mileage;
        if (diff <= 0) continue; // only looking for past refuelings
        if (diff < smallestDiff) {
          smallestDiff = diff;
          out = RefuelingItem.fromJSON(r.data, r.documentID);
        }
      }
    }
    return out;
  }

  Future<HSV> hsv(RefuelingItem item) async {
    if (item.efficiency == double.infinity) return HSV(1.0, 1.0, 1.0);
    var car = await CarsBLoC().getCarByName(item.carName);
    var avgEff = car.averageEfficiency;
    // range is 0 to 120
    var diff = (item.efficiency == null || item.efficiency == double.infinity)
        ? 0
        : item.efficiency - avgEff;
    dynamic hue = (diff * HUE_RANGE) / EFF_VAR;
    hue = clamp(hue, 0, HUE_RANGE * 2);
    return HSV(hue.toDouble(), 1.0, 1.0);
  }

  Future<List<RefuelingItem>> getAllRefuelings() async {
    var doc = FirestoreBLoC().getUserDocument();
    var refuelings = await doc.collection('refuelings').getDocuments();
    List<RefuelingItem> out = [];
    for (var r in refuelings.documents) {
      out.add(RefuelingItem.fromJSON(r.data, r.documentID));
    }
    // put them in order according to date
    out.sort((a, b) =>
        (a.date.isAfter(b.date)) ? 1 : (a.date.isBefore(b.date)) ? -1 : 0);
    return out;
  }

  // Make the object a Singleton
  static final RefuelingBLoC _bloc = RefuelingBLoC._internal();
  factory RefuelingBLoC() => _bloc;
  RefuelingBLoC._internal();
}
