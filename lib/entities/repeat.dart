import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RepeatEntity extends Equatable {
  final String id, name;
  final int mileageInterval;
  final Duration dateInterval;
  final List<String> cars; 

  const RepeatEntity(this.id, this.name, this.mileageInterval, this.dateInterval, this.cars);

  // Map<String, Object> toJson() {
  //   return {
  //     "id": id,
  //     "name": name,
  //     "mileageInterval": mileageInterval,
  //     "dateInterval": dateInterval,
  //     "cars": cars
  //   };
  // }

  @override
  List<Object> get props => [id, name, mileageInterval, dateInterval, cars];

  @override
  String toString() {
    return 'RepeatEntity { id: $id, name: $name, mileageInterval: $mileageInterval, dateInterval: $dateInterval, cars: $cars}';
  }

  // static RepeatEntity fromJson(Map<String, Object> json) {
  //   return RepeatEntity(
  //     json["id"] as String,
  //     json["name"] as String,
  //     json["mileageInterval"] as int,
  //     Duration(days: json["dateInterval"] as int),
  //     json["cars"] as List<String>
  //   );
  // }

  static RepeatEntity fromSnapshot(DocumentSnapshot snap) {
    return RepeatEntity(
      snap.documentID,
      snap.data["name"] as String,
      snap.data["mileageInterval"] as int,
      (snap.data['dateInterval'] == null) ? null :
        Duration(days: snap.data["dateInterval"] as int),
      snap.data["cars"] as List<String>
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "mileageInterval": mileageInterval,
      "dateInterval": dateInterval?.inDays,
      "cars": cars
    };
  }
}