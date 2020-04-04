import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
        vin: vin ?? ''
      );

  factory Car.fromSnapshot(DocumentSnapshot snap) {
    return Car(
        id: snap.documentID,
        name: snap.data['name'] as String,
        mileage: (snap.data['mileage'] as num)?.toDouble(),
        numRefuelings: snap.data['numRefuelings'] as int,
        averageEfficiency: snap.data['averageEfficiency'] as double,
        distanceRate: snap.data['distanceRate'] as double,
        lastMileageUpdate: (snap.data['lastMileageUpdate'] == null)
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                snap.data['lastMileageUpdate'] as int),
        distanceRateHistory: snap.data['distanceRateHistory']
            ?.map((p) => DistanceRatePoint(
                  (p['date'] == null)
                      ? null
                      : DateTime.fromMillisecondsSinceEpoch(p['date']),
                  p['distanceRate'],
                ))
            ?.toList()
            ?.cast<DistanceRatePoint>(),
        make: snap.data['make'] as String,
        model: snap.data['model'] as String,
        year: snap.data['year'] as int,
        plate: snap.data['plate'] as String,
        vin: snap.data['vin'] as String
    );
  }

  factory Car.fromRecord(RecordSnapshot snap) {
    return Car(
        id: (snap.key is String) ? snap.key : '${snap.key}',
        name: snap.value['name'] as String,
        mileage: snap.value['mileage'] as double,
        numRefuelings: snap.value['numRefuelings'] as int,
        averageEfficiency: snap.value['averageEfficiency'] as double,
        distanceRate: snap.value['distanceRate'] as double,
        lastMileageUpdate: (snap.value['lastMileageUpdate'] == null)
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                snap.value['lastMileageUpdate'] as int),
        distanceRateHistory: snap.value['distanceRateHistory']
            ?.map((p) => DistanceRatePoint(
                  (p['date'] == null)
                      ? null
                      : DateTime.fromMillisecondsSinceEpoch(p['date']),
                  p['distanceRate'],
                ))
            ?.toList()
            ?.cast<DistanceRatePoint>(),
        make: snap.value['make'] as String,
        model: snap.value['model'] as String,
        year: snap.value['year'] as int,
        plate: snap.value['plate'] as String,
        vin: snap.value['vin'] as String
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
    @required this.vin
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
        assert(vin != null);

  final String id;

  final String name;

  final double mileage;

  final int numRefuelings;

  final double averageEfficiency;

  final double distanceRate;

  final DateTime lastMileageUpdate;

  final List<DistanceRatePoint> distanceRateHistory;

  final String imageName = 'sonic.jpg';

  final String make;

  final String model;

  final int year;

  final String plate;

  final String vin;

  Future<String> getImageDownloadUrl() async {
    final ref = await FirebaseStorage.instance.getReferenceFromUrl('gs://autodo-49f21.appspot.com/sonic.jpg');
    final url = await ref.getDownloadURL();
    return url;
  }

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
      String vin}) {
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
        vin: vin ?? this.vin);
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
        distanceRateHistory,
        make,
        model,
        year,
        plate,
        vin
      ];

  @override
  String toString() {
    return '$runtimeType { id: $id, name: $name, mileage: $mileage, numRefuelings: $numRefuelings, averageEfficiency: $averageEfficiency, distanceRate: $distanceRate, lastMileageUpdate: $lastMileageUpdate, distanceRateHistory: $distanceRateHistory }';
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
      'vin': vin
    };
  }
}
