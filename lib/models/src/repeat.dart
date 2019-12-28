import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:autodo/entities/entities.dart';

@immutable
class Repeat extends Equatable {
  final String id, name;
  final int mileageInterval;
  final Duration dateInterval;
  final List<String> cars;

  Repeat(
      {this.id, this.name, this.mileageInterval, this.dateInterval, this.cars});

  Repeat copyWith({
    String id,
    String name,
    int mileageInterval,
    Duration dateInterval,
    List<String> cars,
  }) {
    return Repeat(
        id: id ?? this.id,
        name: name ?? this.name,
        mileageInterval: mileageInterval ?? this.mileageInterval,
        dateInterval: dateInterval ?? this.dateInterval,
        cars: cars ?? this.cars);
  }

  @override
  List<Object> get props => [id, name, mileageInterval, dateInterval, cars];

  @override
  String toString() {
    return 'Repeat { id: $id, name: $name, mileageInterval: $mileageInterval, dateInterval: $dateInterval, cars: $cars}';
  }

  RepeatEntity toEntity() {
    return RepeatEntity(id, name, mileageInterval, dateInterval, cars);
  }

  static Repeat fromEntity(RepeatEntity entity) {
    return Repeat(
      id: entity.id,
      name: entity.name,
      mileageInterval: entity.mileageInterval,
      dateInterval: entity.dateInterval,
      cars: entity.cars,
    );
  }
}
