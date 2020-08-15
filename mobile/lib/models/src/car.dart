import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../repositories/src/write_batch_wrapper.dart';
import 'distanceratepoint.dart';
import 'odom_snapshot.dart';

@immutable
class Car extends Equatable implements WriteBatchDocument {
  const Car({
    this.id,
    @required this.name,
    @required this.odomSnapshot,
    this.numRefuelings = 0,
    this.averageEfficiency = 0.0,
    this.distanceRate = 0.0,
    this.distanceRateHistory = const <DistanceRatePoint>[],
    this.make,
    this.model,
    this.year,
    this.plate,
    this.vin,
    this.imageName,
    this.tagColor = Colors.blue,
  })  : assert(name != null),
        assert(odomSnapshot != null);

  factory Car.fromMap(String id, Map<String, dynamic> value) {
    return Car(
      id: id,
      name: value['name'] as String,
      odomSnapshot: OdomSnapshot.fromMap(
          value['odomSnapshot']['id'], value['odomSnapshot']),
      numRefuelings: value['numRefuelings'] as int,
      averageEfficiency: value['averageEfficiency'] as double,
      distanceRate: value['distanceRate'] as double,
      distanceRateHistory: value['distanceRateHistory']
          ?.map((p) => DistanceRatePoint(
                (p['date'] == null)
                    ? null
                    : DateTime.fromMillisecondsSinceEpoch(p['date']),
                p['distanceRate'],
              ))
          ?.toList()
          ?.cast<DistanceRatePoint>(),
      make: value['make'] as String,
      model: value['model'] as String,
      year: value['year'] as int,
      plate: value['plate'] as String,
      vin: value['vin'] as String,
      imageName: value['imageName'] as String,
      tagColor: Color(value['color'] as int),
    );
  }

  final String id;

  final String name;

  final OdomSnapshot odomSnapshot;

  final int numRefuelings;

  final double averageEfficiency;

  final double distanceRate;

  final List<DistanceRatePoint> distanceRateHistory;

  /// The file name for the car's stored image. In theory, this could be generated
  /// consistently from the car's name, i.e. a car named "car1" would always have
  /// an image named "car1.jpg". This would require converting all photos to one
  /// file type though, and would not easily allow for specifying that the user
  /// has not uploaded a photo of the car.
  /// In the current implementation, a null value for this field indicates that
  /// the user has not uploaded a photo of the given car.
  final String imageName;

  final String make;

  final String model;

  final int year;

  final String plate;

  final String vin;

  final Color tagColor;

  Car copyWith({
    String id,
    String name,
    OdomSnapshot odomSnapshot,
    int numRefuelings,
    double averageEfficiency,
    double distanceRate,
    List<DistanceRatePoint> distanceRateHistory,
    String make,
    String model,
    int year,
    String plate,
    String vin,
    String imageName,
    Color tagColor,
  }) {
    return Car(
        id: id ?? this.id,
        name: name ?? this.name,
        odomSnapshot: odomSnapshot ?? this.odomSnapshot,
        numRefuelings: numRefuelings ?? this.numRefuelings,
        averageEfficiency: averageEfficiency ?? this.averageEfficiency,
        distanceRate: distanceRate ?? this.distanceRate,
        distanceRateHistory: distanceRateHistory ?? this.distanceRateHistory,
        make: make ?? this.make,
        model: model ?? this.model,
        year: year ?? this.year,
        plate: plate ?? this.plate,
        vin: vin ?? this.vin,
        imageName: imageName ?? this.imageName,
        tagColor: tagColor ?? this.tagColor);
  }

  @override
  List<Object> get props => [
        id,
        name,
        odomSnapshot,
        numRefuelings,
        averageEfficiency,
        distanceRate,
        ...distanceRateHistory,
        make,
        model,
        year,
        plate,
        vin,
        imageName,
        tagColor.value,
      ];

  @override
  String toString() {
    return '$runtimeType { id: $id, name: $name, odomSnapshot: $odomSnapshot, numRefuelings: $numRefuelings, averageEfficiency: $averageEfficiency, distanceRate: $distanceRate, distanceRateHistory: $distanceRateHistory, make: $make, model: $model, year: $year, plate: $plate, vin: $vin, imageName: $imageName, tagColor: $tagColor }';
  }

  @override
  Map<String, String> toDocument() {
    return {
      'name': name,
      'odomSnapshot': odomSnapshot.id,
      'numRefuelings': numRefuelings.toString(),
      'averageEfficiency': averageEfficiency.toString(),
      'distanceRate': distanceRate.toString(),
      'distanceRateHistory': distanceRateHistory
          ?.map((p) => <String, String>{}..addAll({
              'date': p.date.millisecondsSinceEpoch.toString(),
              'distanceRate': p.distanceRate.toString()
            }))
          ?.toList()
          .toString(),
      'make': make,
      'model': model,
      'year': year.toString(),
      'plate': plate,
      'vin': vin,
      'imageName': imageName,
      'color': tagColor.value.toString(),
    };
  }
}
