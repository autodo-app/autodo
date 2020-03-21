import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

@immutable
class Refueling extends Equatable {
  const Refueling({
    @required this.carName,
    @required this.mileage,
    @required this.date,
    @required this.amount,
    @required this.cost,
    this.id,
    this.carColor,
    this.efficiency,
    this.efficiencyColor,
  })  : assert(date != null),
        assert(mileage != null),
        assert(cost != null),
        assert(amount != null),
        assert(carName != null);

  factory Refueling.fromRecord(RecordSnapshot snap) {
    return Refueling(
      id: (snap.key is String) ? snap.key : '${snap.key}',
      carName: snap.value['carName'],
      mileage: snap.value['mileage'],
      date: (snap.value['date'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.value['date']),
      amount: snap.value['amount'] as double,
      cost: snap.value['cost'] as double,
      carColor: (snap.value['carColor'] == null)
          ? null
          : Color(snap.value['carColor'] as int),
      efficiency: snap.value['efficiency'] as double,
      efficiencyColor: (snap.value['efficiencyColor'] == null)
          ? null
          : Color(snap.value['efficiencyColor'] as int),
    );
  }

  factory Refueling.fromSnapshot(DocumentSnapshot snap) {
    return Refueling(
      id: snap.documentID,
      carName: snap.data['carName'],
      mileage: snap.data['mileage'].toDouble(),
      date: (snap.data['date'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(snap.data['date']),
      amount: snap.data['amount'] as double,
      cost: snap.data['cost'] as double,
      carColor: (snap.data['carColor'] == null)
          ? null
          : Color(snap.data['carColor'] as int),
      efficiency: snap.data['efficiency'] as double,
      efficiencyColor: (snap.data['efficiencyColor'] == null)
          ? null
          : Color(snap.data['efficiencyColor'] as int),
    );
  }

  final String id;

  final String carName;

  final double mileage;

  final DateTime date;

  final double amount;

  final double cost;

  final double efficiency;

  final Color carColor;

  final Color efficiencyColor;

  Refueling copyWith(
      {String id,
      String carName,
      double mileage,
      DateTime date,
      double amount,
      double cost,
      Color carColor,
      double efficiency,
      Color efficiencyColor}) {
    return Refueling(
      carName: carName ?? this.carName,
      id: id ?? this.id,
      mileage: mileage ?? this.mileage,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost,
      carColor: carColor ?? this.carColor,
      efficiency: efficiency ?? this.efficiency,
      efficiencyColor: efficiencyColor ?? this.efficiencyColor,
    );
  }

  @override
  List<Object> get props => [
        carName,
        id,
        mileage,
        date?.toUtc(),
        amount,
        cost,
        carColor?.value,
        efficiency,
        efficiencyColor?.value
      ];

  @override
  String toString() {
    return '$runtimeType { carName: $carName, carColor: $carColor, id: $id, mileage: $mileage, date: ${date?.toUtc()}, amount: $amount, cost: $cost, efficiency: $efficiency, efficiencyColor: $efficiencyColor }';
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
