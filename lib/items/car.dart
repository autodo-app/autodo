import 'package:flutter/material.dart';

class Car {
  String name, ref;
  int mileage, numRefuelings; 
  Color color;
  double averageEfficiency;

  factory Car.fromJSON(Map input, String ref) {
    var out = Car(name: input['name'], mileage: input['mileage'], ref: ref);
    out.numRefuelings = input['numRefuelings'] ?? 0;
    out.averageEfficiency = input['averageEfficiency'] ?? double.infinity;
    if (input['color'] != null)
      out.color = Color(input['color']);
    return out;
  }

  Car({@required this.name, @required this.mileage, this.color, this.numRefuelings, this.averageEfficiency, this.ref});

  Car.empty();
  
  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'mileage': mileage,
      'numRefuelings': numRefuelings,
      'averageEfficiency': averageEfficiency,
      'color': (color == null) ? Colors.blue.value : color.value,
    };
  }
}