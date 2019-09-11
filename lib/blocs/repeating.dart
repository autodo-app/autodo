import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autodo/refueling/refuelingcard.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/userauth.dart';

const Map<String, dynamic> defaults = {
  "oil": 3500,
  "tireRotation": 7500,
  "engineFilter": 45000,
  "wiperBlades": 30000,
  "alignmentCheck": 40000,
  "cabinFilter": 45000,
  "tires": 50000,
  "brakes": 60000,
  "sparkPlugs": 60000,
  "frontStruts": 75000,
  "rearStruts": 75000,
  "battery": 75000,
  "serpentineBelt": 150000,
  "transmissionFluid": 100000,
  "coolantChange": 100000
};

class RepeatingBLoC {
  final Firestore _db = Firestore.instance;
  Map<String, dynamic> repeats = defaults;

  void init() async {
    DocumentSnapshot snap = await _db
        .collection('users')
        .document(Auth().getCurrentUser())
        .collection('repeats')
        .document('default')
        .get();
    if (snap.data != null) {
      repeats = snap.data;
    } else {
      push('default', repeats);
    }
  }

  int getInterval(String key) {
    return repeats[key];
  }

  void push(String carName, Map<String, dynamic> repeats) {}
}
