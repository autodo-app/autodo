import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RefuelingEntity extends Equatable {
  final String id;
  final String carName;
  final int mileage;
  final DateTime date;
  final double amount, cost, efficiency;
  final Color carColor;

  const RefuelingEntity(this.id, this.carName, this.mileage, this.date, this.amount, this.cost, this.carColor, this.efficiency);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "carName": carName,
      "mileage": mileage,
      "date": date.millisecondsSinceEpoch,
      "amount": amount,
      "cost": cost,
      "carColor": carColor.value,
      "efficiency": efficiency
    };
  }

  @override
  List<Object> get props => [id, carName, mileage, date, amount, cost, carColor, efficiency];

  @override
  String toString() {
    return 'RefuelingEntity { id: $id, name: $carName, carColor: $carColor, mileage: $mileage, date: $date, amount: $amount, cost: $cost, efficiency: $efficiency}';
  }

  static RefuelingEntity fromJson(Map<String, Object> json) {
    return RefuelingEntity(
      json["id"] as String,
      json["carName"] as String,
      json["mileage"] as int,
      DateTime.fromMillisecondsSinceEpoch(json["date"] as int),
      json["amount"] as double,
      json["cost"] as double,
      Color(json["carColor"] as int),
      json["efficiency"] as double,
    );
  }

  static RefuelingEntity fromSnapshot(DocumentSnapshot snap) {
    return RefuelingEntity(
      snap.documentID,
      snap.data['carName'],
      snap.data['mileage'],
      DateTime.fromMillisecondsSinceEpoch(snap.data['date']),
      snap.data["amount"] as double,
      snap.data["cost"] as double,
      Color(snap.data["carColor"] as int),
      snap.data["efficiency"] as double,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "carName": carName,
      "mileage": mileage,
      "date": date.millisecondsSinceEpoch,
      "amount": amount,
      "cost": cost,
      "carColor": carColor.value,
      "efficiency": efficiency
    };
  }
}