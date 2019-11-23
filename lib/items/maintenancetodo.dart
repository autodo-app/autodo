import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceTodoItem {
  String name, ref, repeatingType;
  DateTime dueDate, completeDate;
  int dueMileage, notificationID;
  bool complete;
  bool estimatedDueDate; // true if the user set this value, false if generated
  List tags;

  MaintenanceTodoItem({
        this.ref, 
        @required this.name, 
        this.dueDate, 
        this.dueMileage, 
        this.repeatingType, 
        tags,
        this.estimatedDueDate = true, 
        this.complete = false}) {
    this.tags = tags ?? [];
  }

  MaintenanceTodoItem.empty() {
    this.tags = [];
  }

  MaintenanceTodoItem.fromMap(Map<String, dynamic> map, {this.ref})
      : assert(map['name'] != null),
        name = map['name'] {
    if (map['dueDate'] != null) {
      dueDate = map['dueDate'].toDate();
    }
    if (map['dueMileage'] != null) {
      dueMileage = map['dueMileage'];
    }
    if (map['complete'] != null) {
      complete = map['complete'];
    }
    if (map['completeDate'] != null) {
      completeDate = map['completeDate'];
    }
    if (map['repeatingType'] != null) {
      repeatingType = map['repeatingType'];
    }
    if (map['tags'] != null) {
      tags = map['tags'];
    } else {
      tags = [];
    }
    this.estimatedDueDate = map['estimatedDueDate'] ?? true;
  }

  MaintenanceTodoItem.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, ref: snapshot.documentID);

  Map<String, dynamic> toJSON() {
    return {
      'name': this.name,
      'dueDate': this.dueDate,
      'completeDate': this.completeDate,
      'dueMileage': this.dueMileage,
      'complete': this.complete,
      'repeatingType': this.repeatingType,
      'estimatedDueDate': this.estimatedDueDate,
      'tags': this.tags
    };
  }
}
