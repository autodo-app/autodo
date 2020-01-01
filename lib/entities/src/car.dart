import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:autodo/models/models.dart';

class CarEntity extends Equatable {
  final String id, name;
  final int mileage, numRefuelings;
  final double averageEfficiency, distanceRate;
  final DateTime lastMileageUpdate;
  final List<DistanceRatePoint> distanceRateHistory;

  const CarEntity(
      this.id,
      this.name,
      this.mileage,
      numRefuelings,
      averageEfficiency,
      distanceRate,
      this.lastMileageUpdate,
      this.distanceRateHistory)
      : this.numRefuelings = numRefuelings ?? 0,
        this.averageEfficiency = averageEfficiency ?? 0.0,
        this.distanceRate = distanceRate ?? 0.0;

  // Map<String, Object> toJson() {
  //   return {
  //     "id": id,
  //     "name": name,
  //     "mileage": mileage,
  //     "numRefuelings": numRefuelings,
  //     "averageEfficiency": averageEfficiency,
  //     "distanceRate": distanceRate,
  //     "lastMileageUpdate": lastMileageUpdate,
  //     "distanceRateHistory": distanceRateHistory
  //   };
  // }

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

  // static CarEntity fromJson(Map<String, Object> json) {
  //   return CarEntity(
  //     json["id"] as String,
  //     json["name"] as String,
  //     json["mileage"] as int,
  //     json["numRefuelings"] as int,
  //     json["averageEfficiency"] as double,
  //     json["distanceRate"] as double,
  //     DateTime.fromMillisecondsSinceEpoch(json["lastMileageUpdate"] as int),
  //     json["distanceRateHistory"] as List<DistanceRatePoint>
  //   );
  // }

  static CarEntity fromSnapshot(DocumentSnapshot snap) {
    return CarEntity(
        snap.documentID,
        snap.data["name"] as String,
        snap.data["mileage"] as int,
        snap.data["numRefuelings"] as int,
        snap.data["averageEfficiency"] as double,
        snap.data["distanceRate"] as double,
        (snap.data['lastMileageUpdate'] == null)
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                snap.data["lastMileageUpdate"] as int),
        snap.data["distanceRateHistory"]?.map((p) => 
          DistanceRatePoint(
            (p['date'] == null) ? 
              DateTime.fromMillisecondsSinceEpoch(p['date']) :
              null,
            p['distanceRate'],
          )
        )?.toList()
      );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "mileage": mileage,
      "numRefuelings": numRefuelings,
      "averageEfficiency": averageEfficiency,
      "distanceRate": distanceRate,
      "lastMileageUpdate": lastMileageUpdate?.millisecondsSinceEpoch,
      "distanceRateHistory": distanceRateHistory?.map((p) => 
        Map<String, dynamic>()..addAll({
          'date': p.date.millisecondsSinceEpoch,
          'distanceRate': p.distanceRate
        })
      )?.toList()
    };
  }
}
