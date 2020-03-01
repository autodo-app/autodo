import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:autodo/util.dart';

import 'package:autodo/entities/entities.dart';
import 'distanceratepoint.dart';

@immutable
class Car extends Equatable {
  Car({
    this.id,
    this.name,
    this.mileage,
    this.numRefuelings = 0,
    this.averageEfficiency = 0.0,
    this.distanceRate = 0.0,
    lastMileageUpdate,
    distanceRateHistory,
  })  : lastMileageUpdate = lastMileageUpdate ??
            roundToDay(DateTime.fromMillisecondsSinceEpoch(0)),
        distanceRateHistory = distanceRateHistory ?? [];

  final String id, name;

  final double mileage;

  final int numRefuelings;

  final double averageEfficiency, distanceRate;

  final DateTime lastMileageUpdate;

  final List<DistanceRatePoint> distanceRateHistory;

  Car copyWith(
      {String id,
      String name,
      double mileage,
      int numRefuelings,
      double averageEfficiency,
      double distanceRate,
      DateTime lastMileageUpdate,
      List<DistanceRatePoint> distanceRateHistory}) {
    return Car(
        id: id ?? this.id,
        name: name ?? this.name,
        mileage: mileage ?? this.mileage,
        numRefuelings: numRefuelings ?? this.numRefuelings,
        averageEfficiency: averageEfficiency ?? this.averageEfficiency,
        distanceRate: distanceRate ?? this.distanceRate,
        lastMileageUpdate: lastMileageUpdate ?? this.lastMileageUpdate,
        distanceRateHistory: distanceRateHistory ?? this.distanceRateHistory);
  }

  @override
  List<Object> get props => [
        id,
        name,
        mileage,
        numRefuelings,
        averageEfficiency,
        distanceRate,
        lastMileageUpdate?.toUtc(),
        distanceRateHistory
      ];

  @override
  String toString() {
    return 'Car { id: $id, name: $name, mileage: $mileage, numRefuelings: $numRefuelings, averageEfficiency: $averageEfficiency, distanceRate: $distanceRate, lastMileageUpdate: $lastMileageUpdate, distanceRateHistory: $distanceRateHistory }';
  }

  CarEntity toEntity() {
    return CarEntity(id, name, mileage, numRefuelings, averageEfficiency,
        distanceRate, lastMileageUpdate, distanceRateHistory);
  }

  static Car fromEntity(CarEntity entity) {
    return Car(
        id: entity.id,
        name: entity.name,
        mileage: entity.mileage,
        numRefuelings: entity.numRefuelings,
        averageEfficiency: entity.averageEfficiency,
        distanceRate: entity.distanceRate,
        lastMileageUpdate: entity.lastMileageUpdate,
        distanceRateHistory: entity.distanceRateHistory);
  }
}
