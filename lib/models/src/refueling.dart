import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../repositories/src/write_batch_wrapper.dart';

@immutable
class Refueling extends Equatable implements WriteBatchDocument {
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

  factory Refueling.fromMap(String id, Map<String, dynamic> value) {
    return Refueling(
      id: id,
      carName: value['carName'],
      mileage: value['mileage'],
      date: (value['date'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(value['date']),
      amount: value['amount'] as double,
      cost: value['cost'] as double,
      carColor:
          (value['carColor'] == null) ? null : Color(value['carColor'] as int),
      efficiency: value['efficiency'] as double,
      efficiencyColor: (value['efficiencyColor'] == null)
          ? null
          : Color(value['efficiencyColor'] as int),
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

  @override
  Map<String, String> toDocument() {
    return {
      'carName': carName,
      'mileage': mileage.toString(),
      'date': date?.millisecondsSinceEpoch.toString(),
      'amount': amount.toString(),
      'cost': cost.toString(),
      'carColor': carColor?.value.toString(),
      'efficiency': efficiency.toString(),
      'efficiencyColor': efficiencyColor?.value.toString()
    };
  }
}
