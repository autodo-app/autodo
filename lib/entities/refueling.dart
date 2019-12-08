import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RefuelingEntity extends Equatable {
  final String id;
  final String name;
  final int mileage;
  final DateTime date;
  final double amount, cost;

  const RefuelingEntity(this.id, this.name, this.mileage, this.date, this.amount, this.cost);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "name": name,
      "mileage": mileage,
      "date": date.millisecondsSinceEpoch,
      "amount": amount,
      "cost": cost
    };
  }

  @override
  List<Object> get props => [id, name, mileage, date, amount, cost];

  @override
  String toString() {
    return 'RefuelingEntity { id: $id, name: $name, mileage: $mileage, date: $date, amount: $amount, cost: $cost}';
  }

  static RefuelingEntity fromJson(Map<String, Object> json) {
    return RefuelingEntity(
      json["id"] as String,
      json["name"] as String,
      json["mileage"] as int,
      DateTime.fromMillisecondsSinceEpoch(json["date"] as int),
      json["amount"] as double,
      json["cost"] as double,
    );
  }

  static RefuelingEntity fromSnapshot(DocumentSnapshot snap) {
    return RefuelingEntity(
      snap.documentID,
      snap.data['name'],
      snap.data['mileage'],
      DateTime.fromMillisecondsSinceEpoch(snap.data['date']),
      snap.data["amount"] as double,
      snap.data["cost"] as double,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "mileage": mileage,
      "date": date.millisecondsSinceEpoch,
      "amount": amount,
      "cost": cost
    };
  }
}