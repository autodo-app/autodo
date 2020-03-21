import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

@immutable
class Repeat extends Equatable {
  const Repeat({
    this.id,
    this.name,
    this.mileageInterval,
    this.dateInterval,
    this.cars,
  });

  factory Repeat.fromSnapshot(DocumentSnapshot snap) {
    return Repeat(
        id: snap.documentID,
        name: snap.data['name'] as String,
        mileageInterval: (snap.data['mileageInterval'] as num)?.toDouble(),
        dateInterval: (snap.data['dateInterval'] == null)
            ? null
            : Duration(days: snap.data['dateInterval'] as int),
        cars: (snap.data['cars'] as List<dynamic>)?.cast<String>());
  }

  factory Repeat.fromRecord(RecordSnapshot snap) {
    return Repeat(
        id: (snap.key is String) ? snap.key : '${snap.key}',
        name: snap.value['name'] as String,
        mileageInterval: snap.value['mileageInterval'] as double,
        dateInterval: (snap.value['dateInterval'] == null)
            ? null
            : Duration(days: snap.value['dateInterval'] as int),
        cars: (snap.value['cars'] as List<dynamic>)?.cast<String>());
  }

  final String id, name;

  final double mileageInterval;

  final Duration dateInterval;

  final List<String> cars;

  Repeat copyWith({
    String id,
    String name,
    double mileageInterval,
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
    return '$runtimeType { id: $id, name: $name, mileageInterval: $mileageInterval, dateInterval: $dateInterval, cars: $cars }';
  }

  Repeat toEntity() {
    return this;
  }

  static Repeat fromEntity(Repeat entity) {
    return entity;
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'mileageInterval': mileageInterval,
      'dateInterval': dateInterval?.inDays,
      'cars': cars
    };
  }
}
