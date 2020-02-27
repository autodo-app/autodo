import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class RefuelingEntity extends Equatable {
  final String id;
  final String carName;
  final int mileage;
  final DateTime date;
  final double amount, cost, efficiency;
  final Color carColor, efficiencyColor;

  const RefuelingEntity(
      this.id,
      this.carName,
      this.mileage,
      this.date,
      this.amount,
      this.cost,
      this.carColor,
      this.efficiency,
      this.efficiencyColor);

  @override
  List<Object> get props => [
        id,
        carName,
        mileage,
        date,
        amount,
        cost,
        carColor,
        efficiency,
        efficiencyColor
      ];

  @override
  String toString() {
    return 'RefuelingEntity { id: $id, name: $carName, carColor: $carColor, mileage: $mileage, date: $date, amount: $amount, cost: $cost, efficiency: $efficiency, efficiencyColor: $efficiencyColor }';
  }

  static RefuelingEntity fromSnapshot(DocumentSnapshot snap) {
    return RefuelingEntity(
      snap.documentID,
      snap.data['carName'],
      snap.data['mileage'],
      (snap.data['date'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.data['date']),
      snap.data['amount'] as double,
      snap.data['cost'] as double,
      (snap.data['carColor'] == null)
          ? null
          : Color(snap.data['carColor'] as int),
      snap.data['efficiency'] as double,
      (snap.data['efficiencyColor'] == null)
          ? null
          : Color(snap.data['efficiencyColor'] as int),
    );
  }

  factory RefuelingEntity.fromRecord(RecordSnapshot snap) {
    return RefuelingEntity(
      (snap.key is String) ? snap.key : '${snap.key}',
      snap.value['carName'],
      snap.value['mileage'],
      (snap.value['date'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.value['date']),
      snap.value['amount'] as double,
      snap.value['cost'] as double,
      (snap.value['carColor'] == null)
          ? null
          : Color(snap.value['carColor'] as int),
      snap.value['efficiency'] as double,
      (snap.value['efficiencyColor'] == null)
          ? null
          : Color(snap.value['efficiencyColor'] as int),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'carName': carName,
      'mileage': mileage,
      'date': date?.millisecondsSinceEpoch,
      'amount': amount,
      'cost': cost,
      'carColor': carColor?.value,
      'efficiency': efficiency,
      'efficiencyColor': efficiencyColor?.value
    };
  }
}
