import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'odom_snapshot.dart';

@immutable
class Refueling extends Equatable {
  const Refueling({
    @required this.odomSnapshot,
    @required this.amount,
    @required this.cost,
    this.id,
  });

  factory Refueling.fromMap(String id, Map<String, dynamic> value) {
    return Refueling(
      id: id,
      odomSnapshot: OdomSnapshot.fromMap(
          value['odomSnapshot']['id'], value['odomSnapshot']),
      amount: value['amount'] as double,
      cost: value['cost'] as double,
    );
  }

  /// The UID for the Refueling object on the server.
  final String id;

  /// The contents of the odometer reading when this Refueling occurred.
  final OdomSnapshot odomSnapshot;

  /// The amount of gasoline added to the tank in the Refueling.
  final double amount;

  /// The price of the gasoline purchased in the Refueling.
  final double cost;

  String get carId => odomSnapshot?.car;

  Refueling copyWith({
    String id,
    OdomSnapshot odomSnapshot,
    double amount,
    double cost,
  }) {
    return Refueling(
      id: id ?? this.id,
      odomSnapshot: odomSnapshot ?? this.odomSnapshot,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost,
    );
  }

  @override
  List<Object> get props => [id, odomSnapshot, amount, cost];

  @override
  String toString() {
    return '$runtimeType { id: $id, odomSnapshot: $odomSnapshot, amount : $amount, cost: $cost }';
  }

  Map<String, dynamic> toDocument() {
    return {
      'odomSnapshot': odomSnapshot.toDocument(),
      'amount': amount.toString(),
      'cost': cost.toString(),
    };
  }
}
