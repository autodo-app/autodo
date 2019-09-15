import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceTodoItem {
  String name, ref;
  DateTime dueDate, completeDate;
  int dueMileage;
  bool complete = false;
  List<String> tags = ['Example Tag'];
  DocumentReference reference;

  MaintenanceTodoItem(
      {@required this.ref, @required this.name, this.dueDate, this.dueMileage});

  MaintenanceTodoItem.empty();

  MaintenanceTodoItem.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'] {
    if (map['dueDate'] != null) {
      dueDate = map['dueDate'];
    }
    if (map['dueMileage'] != null) {
      dueDate = map['dueMileage'];
    }
    if (map['complete'] != null) {
      complete = map['complete'];
    }
    if (map['completeDate'] != null) {
      completeDate = map['completeDate'];
    }
    tags = map['tags'];
  }

  MaintenanceTodoItem.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJSON() {
    return {
      'name': this.name,
      'dueDate': this.dueDate,
      'completeDate': this.completeDate,
      'dueMileage': this.dueMileage,
      'complete': this.complete,
      'tags': this.tags
    };
  }
}
