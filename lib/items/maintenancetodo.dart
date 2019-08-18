import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceTodoItem {
  String name;
  DateTime dueDate;
  int dueMileage;
  bool complete = false;
  List<String> tags = ['Example Tag'];
  DocumentReference reference;

  MaintenanceTodoItem({@required this.name, this.dueDate, this.dueMileage});

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
    tags = map['tags'];
  }

  MaintenanceTodoItem.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'dueDate': this.dueDate,
      'dueMileage': this.dueMileage,
      'complete': this.complete,
      'tags': this.tags
    };
  }
}
