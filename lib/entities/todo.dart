import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

class TodoEntity extends Equatable {
  final String id, name, carName, repeatName;
  final TodoDueState dueState;
  final int dueMileage, notificationID;
  final bool completed, estimatedDueDate;
  final DateTime completedDate, dueDate;

  const TodoEntity(
    this.id,
    this.name,
    this.carName,
    this.repeatName,
    this.dueState,
    this.dueMileage,
    this.notificationID,
    this.completed,
    this.estimatedDueDate,
    this.completedDate,
    this.dueDate
  );

  // Map<String, Object> toJson() {
  //   return {
  //     "id": id,
  //     "name": name,
  //     "carName": carName,
  //     "repeatName": repeatName,
  //     "dueState": dueState.index,
  //     "dueMileage": dueMileage,
  //     "notificationID": notificationID,
  //     "completed": completed,
  //     "estimatedDueDate": estimatedDueDate,
  //     "completedDate": completedDate.millisecondsSinceEpoch,
  //     "dueDate": completedDate.millisecondsSinceEpoch
  //   };
  // }

  @override
  List<Object> get props => [id, name, carName, repeatName, dueState, 
      dueMileage, notificationID, completed, estimatedDueDate, completedDate, 
      dueDate];


  @override
  String toString() {
    return 'TodoEntity { id: $id, name: $name, carName: $carName, repeatName: '
    '$repeatName, dueState: $dueState, dueMileage: $dueMileage, notificationID: '
    '$notificationID, completed: $completed, estimatedDueDate: $estimatedDueDate, '
    'completedDate: $completedDate, dueDate: $dueDate }';
  }

  // static TodoEntity fromJson(Map<String, Object> json) {
  //   return TodoEntity(
  //     json["id"] as String,
  //     json["name"] as String,
  //     json["carName"] as String,
  //     json["repeatName"] as String,
  //     TodoDueState.values[json["dueState"] as int],
  //     json["dueMileage"] as int,
  //     json["notificationID"] as int,
  //     json["completed"] as bool,
  //     json['estimatedDueDate'] as bool,
  //     DateTime.fromMillisecondsSinceEpoch(json["completedDate"] as int),
  //     DateTime.fromMillisecondsSinceEpoch(json["dueDate"] as int),
  //   );
  // }

  static TodoEntity fromSnapshot(DocumentSnapshot snap) {
    return TodoEntity(
      snap.documentID,
      snap.data["name"] as String,
      snap.data["carName"] as String,
      snap.data["repeatName"] as String,
      (snap.data["dueState"] == null) ? null : 
        TodoDueState.values[snap.data["dueState"]],
      snap.data["dueMileage"] as int,
      snap.data["notificationID"] as int,
      snap.data["completed"] as bool,
      snap.data['estimatedDueDate'] as bool,
      (snap.data["completedDate"] == null) ? null : 
        DateTime.fromMillisecondsSinceEpoch(snap.data["completedDate"]),
      (snap.data["dueDate"] == null) ? null : 
        DateTime.fromMillisecondsSinceEpoch(snap.data["dueDate"]),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "carName": carName,
      "repeatName": repeatName,
      "dueState": dueState?.index,
      "dueMileage": dueMileage,
      "notificationID": notificationID,
      "completed": completed,
      "estimatedDueDate": estimatedDueDate,
      "completedDate": completedDate?.millisecondsSinceEpoch,
      "dueDate": dueDate?.millisecondsSinceEpoch
    };
  }
}