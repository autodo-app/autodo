import 'package:flutter/material.dart';

class Car {
  String name;
  double mileage;
  Color color;
  String ref;

  factory Car.fromJSON(Map input, String ref) {
    var out = Car(name: input['name'], mileage: input['mileage'], ref: ref);
    if (input['color'] != null)
      out.color = Color(input['color']);
    return out;
  }

  Car({@required this.name, @required this.mileage, this.color, this.ref});

  Car.empty();
  
  Map<String, dynamic> toJSON() {
    return {};
  }

  
}