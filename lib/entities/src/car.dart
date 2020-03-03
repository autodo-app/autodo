import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

import 'package:autodo/models/models.dart';

class CarEntity extends Equatable {
  const CarEntity(
      this.id,
      this.name,
      this.mileage,
      numRefuelings,
      averageEfficiency,
      distanceRate,
      this.lastMileageUpdate,
      this.distanceRateHistory)
      : numRefuelings = numRefuelings ?? 0,
        averageEfficiency = averageEfficiency ?? 0.0,
        distanceRate = distanceRate ?? 0.0;

  factory CarEntity.fromRecord(RecordSnapshot snap) {
    return CarEntity(
        (snap.key is String) ? snap.key : '${snap.key}',
        snap.value['name'] as String,
        snap.value['mileage'] as double,
        snap.value['numRefuelings'] as int,
        snap.value['averageEfficiency'] as double,
        snap.value['distanceRate'] as double,
        (snap.value['lastMileageUpdate'] == null)
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                snap.value['lastMileageUpdate'] as int),
        snap.value['distanceRateHistory']
            ?.map((p) => DistanceRatePoint(
                  (p['date'] == null)
                      ? null
                      : DateTime.fromMillisecondsSinceEpoch(p['date']),
                  p['distanceRate'],
                ))
            ?.toList()
            ?.cast<DistanceRatePoint>());
  }

  final String id, name;

  final double mileage;

  final int numRefuelings;

  final double averageEfficiency, distanceRate;

  final DateTime lastMileageUpdate;

  final List<DistanceRatePoint> distanceRateHistory;

  @override
  List<Object> get props => [
        id,
        name,
        mileage,
        numRefuelings,
        averageEfficiency,
        distanceRate,
        lastMileageUpdate,
        distanceRateHistory
      ];

  @override
  String toString() {
    return 'CarEntity { id: $id, name: $name, mileage: $mileage, numRefuelings: $numRefuelings, averageEfficiency: $averageEfficiency, distanceRate: $distanceRate, lastMileageUpdate: $lastMileageUpdate, distanceRateHistory: $distanceRateHistory }';
  }

  static CarEntity fromSnapshot(DocumentSnapshot snap) {
    return CarEntity(
        snap.documentID,
        snap.data['name'] as String,
        (snap.data['mileage'] as num).toDouble(),
        snap.data['numRefuelings'] as int,
        snap.data['averageEfficiency'] as double,
        snap.data['distanceRate'] as double,
        (snap.data['lastMileageUpdate'] == null)
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                snap.data['lastMileageUpdate'] as int),
        snap.data['distanceRateHistory']
            ?.map((p) => DistanceRatePoint(
                  (p['date'] == null)
                      ? null
                      : DateTime.fromMillisecondsSinceEpoch(p['date']),
                  p['distanceRate'],
                ))
            ?.toList()
            ?.cast<DistanceRatePoint>());
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
          ?.toList()
    };
  }
}
