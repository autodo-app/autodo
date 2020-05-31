import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../repositories/src/write_batch_wrapper.dart';
import 'odom_snapshot.dart';

@immutable
class Refueling extends Equatable implements WriteBatchDocument {
  const Refueling({
    @required this.odomSnapshot,
    @required this.amount,
    @required this.cost,
    this.id,
    this.efficiency,
    this.efficiencyColor,
  })  : assert(odomSnapshot != null),
        assert(cost != null),
        assert(amount != null);

  factory Refueling.fromMap(String id, Map<String, dynamic> value) {
    return Refueling(
      id: id,
      odomSnapshot: OdomSnapshot.fromMap(
          value['odomSnapshot']['id'], value['odomSnapshot']),
      amount: value['amount'] as double,
      cost: value['cost'] as double,
      efficiency: value['efficiency'] as double,
      efficiencyColor: (value['efficiencyColor'] == null)
          ? null
          : Color(value['efficiencyColor'] as int),
    );
  }

  final String id;

  final OdomSnapshot odomSnapshot;

  final double amount;

  final double cost;

  final double efficiency;

  final Color efficiencyColor;

  Refueling copyWith(
      {String id,
      OdomSnapshot odomSnapshot,
      double amount,
      double cost,
      double efficiency,
      Color efficiencyColor}) {
    return Refueling(
      id: id ?? this.id,
      odomSnapshot: odomSnapshot ?? this.odomSnapshot,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost,
      efficiency: efficiency ?? this.efficiency,
      efficiencyColor: efficiencyColor ?? this.efficiencyColor,
    );
  }

  @override
  List<Object> get props =>
      [id, odomSnapshot, amount, cost, efficiency, efficiencyColor?.value];

  @override
  String toString() {
    return '$runtimeType { id: $id, odomSnapshot: $odomSnapshot, amount : $amount, cost: $cost, efficiency: $efficiency, efficiencyColor: $efficiencyColor }';
  }

  @override
  Map<String, String> toDocument() {
    return {
      'odomSnapshot': odomSnapshot.id.toString(),
      'amount': amount.toString(),
      'cost': cost.toString(),
      'efficiency': efficiency.toString(),
      'efficiencyColor': efficiencyColor?.value.toString()
    };
  }
}
