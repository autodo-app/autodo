import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../entities/barrel.dart';

@immutable
class Refueling extends Equatable{
  final String id;
  final String carName;
  final int mileage;
  final DateTime date;
  final double amount, cost;

  Refueling({
    this.carName,
    this.id,
    this.mileage,
    this.date,
    this.amount,
    this.cost
  });

  Refueling copyWith({
    String id, 
    String carName, 
    int mileage, 
    DateTime date, 
    double amount,
    double cost 
  }) {
    return Refueling(
      carName: carName ?? this.carName,
      id: id ?? this.id,
      mileage: mileage ?? this.mileage,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost
    );
  }

  @override 
  List<Object> get props => [carName, id, mileage, date, amount, cost];

  @override
  String toString() {
    return 'Refueling { task: $carName, id: $id, mileage: $mileage, date: $date, amount: $amount, cost: $cost }';
  }

  RefuelingEntity toEntity() {
    return RefuelingEntity(id, carName, mileage, date, amount, cost);
  }

  static Refueling fromEntity(RefuelingEntity entity) {
    return Refueling(
      carName: entity.carName,
      id: entity.id,
      mileage: entity.mileage,
      date: entity.date,
      amount: entity.amount,
      cost: entity.cost
    );
  }
}