import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../util.dart';
import 'distanceratepoint.dart';

@immutable
class Car extends Equatable {
  factory Car({
    String id,
    String name,
    double mileage,
    int numRefuelings,
    double averageEfficiency,
    double distanceRate,
    DateTime lastMileageUpdate,
    List<DistanceRatePoint> distanceRateHistory,
    String make,
    String model,
    int year,
    String plate,
    String vin,
    String imageName,
  }) =>
      Car._(
        id: id ?? '',
        name: name ?? '',
        mileage: mileage ?? 0,
        numRefuelings: numRefuelings ?? 0,
        averageEfficiency: averageEfficiency ?? 0,
        distanceRate: distanceRate ?? 0,
        lastMileageUpdate: lastMileageUpdate ??
            roundToDay(DateTime.fromMillisecondsSinceEpoch(0)),
        distanceRateHistory: distanceRateHistory ?? const <DistanceRatePoint>[],
        make: make ?? '',
        model: model ?? '',
        year: year ?? 0,
        plate: plate ?? '',
        vin: vin ?? '',
        imageName: imageName ?? '',
      );

  factory Car.fromMap(String id, Map<String, dynamic> value) {
    return Car(
      id: id,
      name: value['name'] as String,
      mileage: value['mileage'] as double,
      numRefuelings: value['numRefuelings'] as int,
      averageEfficiency: value['averageEfficiency'] as double,
      distanceRate: value['distanceRate'] as double,
      lastMileageUpdate: (value['lastMileageUpdate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              value['lastMileageUpdate'] as int),
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
    );
  }

  const Car._({
    @required this.id,
    @required this.name,
    @required this.mileage,
    @required this.numRefuelings,
    @required this.averageEfficiency,
    @required this.distanceRate,
    @required this.lastMileageUpdate,
    @required this.distanceRateHistory,
    @required this.make,
    @required this.model,
    @required this.year,
    @required this.plate,
    @required this.vin,
    @required this.imageName,
  })  : assert(id != null),
        assert(name != null),
        assert(mileage != null),
        assert(numRefuelings != null),
        assert(averageEfficiency != null),
        assert(distanceRate != null),
        assert(lastMileageUpdate != null),
        assert(distanceRateHistory != null),
        assert(make != null),
        assert(model != null),
        assert(year != null),
        assert(plate != null),
        assert(vin != null),
        assert(imageName != null);

  final String id;

  final String name;

  final double mileage;

  final int numRefuelings;

  final double averageEfficiency;

  final double distanceRate;

  final DateTime lastMileageUpdate;

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

  Car copyWith(
      {String id,
      String name,
      double mileage,
      int numRefuelings,
      double averageEfficiency,
      double distanceRate,
      DateTime lastMileageUpdate,
      List<DistanceRatePoint> distanceRateHistory,
      String make,
      String model,
      int year,
      String plate,
      String vin,
      String imageName}) {
    return Car(
        id: id ?? this.id,
        name: name ?? this.name,
        mileage: mileage ?? this.mileage,
        numRefuelings: numRefuelings ?? this.numRefuelings,
        averageEfficiency: averageEfficiency ?? this.averageEfficiency,
        distanceRate: distanceRate ?? this.distanceRate,
        lastMileageUpdate: lastMileageUpdate ?? this.lastMileageUpdate,
        distanceRateHistory: distanceRateHistory ?? this.distanceRateHistory,
        make: make ?? this.make,
        model: model ?? this.model,
        year: year ?? this.year,
        plate: plate ?? this.plate,
        vin: vin ?? this.vin,
        imageName: imageName ?? this.imageName);
  }

  @override
  List<Object> get props => [
        id,
        name,
        mileage,
        numRefuelings,
        averageEfficiency,
        distanceRate,
        lastMileageUpdate?.toUtc()?.toIso8601String(),
        ...distanceRateHistory,
        make,
        model,
        year,
        plate,
        vin,
        imageName,
      ];

  @override
  String toString() {
    return '$runtimeType { id: $id, name: $name, mileage: $mileage, numRefuelings: $numRefuelings, averageEfficiency: $averageEfficiency, distanceRate: $distanceRate, lastMileageUpdate: ${lastMileageUpdate?.toUtc()?.toIso8601String()}, distanceRateHistory: $distanceRateHistory, make: $make, model: $model, year: $year, plate: $plate, vin: $vin, imageName: $imageName }';
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'mileage': mileage,
      'numRefuelings': numRefuelings,
      'averageEfficiency': averageEfficiency,
      'distanceRate': distanceRate,
      'lastMileageUpdate': lastMileageUpdate?.millisecondsSinceEpoch,
      'distanceRateHistory': distanceRateHistory
          ?.map((p) => <String, dynamic>{}..addAll({
              'date': p.date.millisecondsSinceEpoch,
              'distanceRate': p.distanceRate
            }))
          ?.toList(),
      'make': make,
      'model': model,
      'year': year,
      'plate': plate,
      'vin': vin,
      'imageName': imageName,
    };
  }
}
