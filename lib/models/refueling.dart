import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../entities/barrel.dart';

@immutable
class Refueling extends Equatable{
  final String id;
  final String name;
  final int mileage;
  final DateTime date;
  final double amount, cost;

  Refueling({
    this.name,
    this.id,
    this.mileage,
    this.date,
    this.amount,
    this.cost
  });

  Refueling copyWith({String id, String name}) {
    return Refueling(
      name: name ?? this.name,
      id: id ?? this.id,
      mileage: mileage ?? this.mileage,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost
    );
  }

  @override 
  List<Object> get props => [name, id, mileage, date, amount, cost];

  @override
  String toString() {
    return 'Refueling { task: $name, id: $id, mileage: $mileage, date: $date, amount: $amount, cost: $cost }';
  }

  RefuelingEntity toEntity() {
    return RefuelingEntity(id, name, mileage, date, amount, cost);
  }

  static Refueling fromEntity(RefuelingEntity entity) {
    return Refueling(
      name: entity.name,
      id: entity.id,
      mileage: entity.mileage,
      date: entity.date,
      amount: entity.amount,
      cost: entity.cost
    );
  }
}