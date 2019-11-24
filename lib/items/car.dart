import 'package:flutter/material.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/util.dart';
import './distanceratepoint.dart';

class Car {
  static const double EMA_GAIN = 0.9;
  static const double EMA_CUTOFF = 8;

  String name, ref;
  int mileage = 0, numRefuelings = 0; 
  Color color;
  double averageEfficiency, distanceRate;
  DateTime lastMileageUpdate;
  List<DistanceRatePoint> distanceRateHistory;

  factory Car.fromJSON(Map input, String ref) {
    var out = Car(name: input['name'], mileage: input['mileage'], ref: ref);
    out.numRefuelings = input['numRefuelings'] ?? 0;
    out.averageEfficiency = input['averageEfficiency'] ?? double.infinity;
    out.distanceRate = input['distanceRate'] ?? double.infinity;
    if (input['distanceRateHistory'] == null) {
      out.distanceRateHistory = [];
    } else {
      List<DistanceRatePoint> history = List<DistanceRatePoint>.from(
        input['distanceRateHistory']
        .map((val) => DistanceRatePoint(
          DateTime.fromMillisecondsSinceEpoch(val['date']), 
          val['distanceRate'])
        )
      );
      out.distanceRateHistory = history;
    }
    if (input['color'] != null)
      out.color = Color(input['color']);
    return out;
  }

  Car({
    @required this.name, 
    @required this.mileage, 
    this.color, 
    this.numRefuelings, 
    this.averageEfficiency, 
    this.distanceRate, 
    this.ref});

  Car.empty();
  
  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> distanceRateHistoryJSON = 
      (distanceRateHistory == null) ? [] : List.from(
      distanceRateHistory.map((val) => {
        'date': val.date.millisecondsSinceEpoch, 
        'distanceRate': val.distanceRate
      })
    );
    return {
      'name': name,
      'mileage': mileage,
      'numRefuelings': numRefuelings,
      'averageEfficiency': averageEfficiency,
      'distanceRate': distanceRate,
      'distanceRateHistory': distanceRateHistoryJSON,
      'color': (color == null) ? Colors.blue.value : color.value,
    };
  }

  void updateMileage(int newMileage, DateTime updateDate, {override = false}) {
    if (this.mileage > newMileage && !override) {
      // allow adding past refuelings, but we don't want to roll back the
      // mileage in that case. The override switch is available to force a 
      // rollback in the case of a deleted refueling.
      return; 
    }
      
    this.mileage = newMileage;
    this.lastMileageUpdate = roundToDay(updateDate);
  }

  double _efficiencyFilter(int numRefuelings, double prev, double cur) {
    if (numRefuelings > EMA_CUTOFF) {
      return EMA_GAIN * prev + (1 - EMA_GAIN) * cur;
    } else {
      double fac1 = (numRefuelings - 1) / numRefuelings;
      double fac2 = 1 / numRefuelings;
      return prev * fac1 + cur * fac2;
    }
  }

  void updateEfficiency(double eff) {
    if (this.numRefuelings == 1) {
      // first refueling for this car
      this.averageEfficiency = eff;
    } else {
      this.averageEfficiency = _efficiencyFilter(this.numRefuelings, this.averageEfficiency, eff);
    }
  } 

  double _distanceFilter(int numItems, double prev, double cur) {
    if (numItems == 1 || prev == double.infinity) {
      // no point in averaging only one value
      return cur;
    } else if (numItems > EMA_CUTOFF) {
      // Use the EMA when we have enough data to get 
      // good results from it
      return EMA_GAIN * prev + (1 - EMA_GAIN) * cur;
    } else {
      // simple moving average when we don't have much
      // data to work with
      numItems--; // we don't track distanceRate between first two refuelings
      double fac1 = (numItems - 1) / numItems;
      double fac2 = 1 / numItems;
      return prev * fac1 + cur * fac2;
    }
  }

  void updateDistanceRate(DateTime prev, DateTime cur, int distance) {
    if (prev == null || cur == null) return;

    var elapsedDuration = cur.difference(prev);
    var curDistRate = distance.toDouble() / elapsedDuration.inDays.toDouble();
    this.distanceRate = _distanceFilter(this.numRefuelings, this.distanceRate, curDistRate);
    this.distanceRateHistory.add(DistanceRatePoint(cur, this.distanceRate));
    TodoBLoC().updateDueDates(this);
  }
}