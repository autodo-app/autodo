import 'package:flutter/material.dart';

class Car {
  static const double EMA_GAIN = 0.9;
  static const double EMA_CUTOFF = 8;

  String name, ref;
  int mileage, numRefuelings; 
  Color color;
  double averageEfficiency, distanceRate;

  factory Car.fromJSON(Map input, String ref) {
    var out = Car(name: input['name'], mileage: input['mileage'], ref: ref);
    out.numRefuelings = input['numRefuelings'] ?? 0;
    out.averageEfficiency = input['averageEfficiency'] ?? double.infinity;
    out.distanceRate = input['distanceRate'] ?? double.infinity;
    if (input['color'] != null)
      out.color = Color(input['color']);
    return out;
  }

  Car({@required this.name, @required this.mileage, this.color, this.numRefuelings, this.averageEfficiency, this.distanceRate, this.ref});

  Car.empty();
  
  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'mileage': mileage,
      'numRefuelings': numRefuelings,
      'averageEfficiency': averageEfficiency,
      'distanceRate': distanceRate,
      'color': (color == null) ? Colors.blue.value : color.value,
    };
  }

  void updateMileage(int mileage) {
    if (this.mileage > mileage)
      return; // allow adding past refuelings, but odometers don't go backwards
    this.mileage = mileage;
    // edit(car);
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
    // edit(car);
  } 

  double _distanceFilter(int numItems, double prev, double cur) {
    if (numItems == 1 || prev == double.infinity) {
      // no point in averaging only one value
      print('here');
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
  }
}