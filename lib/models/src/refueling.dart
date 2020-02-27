import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:autodo/entities/entities.dart';

@immutable
class Refueling extends Equatable {
  final String id;
  final String carName;
  final int mileage;
  final DateTime date;
  final double amount, cost, efficiency;
  final Color carColor, efficiencyColor;

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

  Refueling copyWith(
      {String id,
      String carName,
      int mileage,
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
        carColor,
        efficiency,
        efficiencyColor?.value
      ];

  @override
  String toString() {
    return 'Refueling { carName: $carName, carColor: $carColor, id: $id, mileage: $mileage, date: ${date?.toUtc()}, amount: $amount, cost: $cost, efficiency: $efficiency, efficiencyColor: $efficiencyColor}';
  }

  RefuelingEntity toEntity() {
    return RefuelingEntity(id, carName, mileage, date, amount, cost, carColor,
        efficiency, efficiencyColor);
  }

  static Refueling fromEntity(RefuelingEntity entity) {
    return Refueling(
      carName: entity.carName,
      id: entity.id,
      mileage: entity.mileage,
      date: entity.date,
      amount: entity.amount,
      cost: entity.cost,
      carColor: entity.carColor,
      efficiency: entity.efficiency,
      efficiencyColor: entity.efficiencyColor,
    );
  }
}
