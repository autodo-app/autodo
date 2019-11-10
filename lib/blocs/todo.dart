import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/maintenance/todocard.dart';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';
import 'package:autodo/blocs/notifications.dart';

class TodoBLoC extends BLoC {
  @override
  Widget buildItem(dynamic snapshot, int index) {
    bool first = index == 0;
    var date;
    if (snapshot.data.containsKey('dueDate') && snapshot.data['dueDate'] != null)
      date = snapshot.data['dueDate'].toDate();
    var mileage = snapshot.data['dueMileage'];
    var item = MaintenanceTodoItem(
      ref: snapshot.documentID,
      name: snapshot.data['name'],
      dueDate: date,
      dueMileage: mileage,
      repeatingType: snapshot.data['repeatingType'],
      tags: snapshot.data['tags']
    );
    return MaintenanceTodoCard(item: item, emphasized: first);
  }

  @override
  List sortItems(List items) {
    return items..sort((a, b) {
      var aDate = a.data['dueDate'] ?? 0;
      var bDate = b.data['dueDate'] ?? 0;
      var aMileage = a.data['dueMileage'] ?? 0;
      var bMileage = b.data['dueMileage'] ?? 0;
       
      if (aDate == 0 && bDate == 0) {
        // both don't have a date, so only consider the mileages
        if (aMileage > bMileage) return 1;
        else if (aMileage < bMileage) return -1;
        else return 0;
      } else if (aMileage == 0 && bMileage == 0) {
        // both don't have a mileage, so only consider the dates
        if (aDate < bDate) return 1;
        else if (aDate > bDate) return -1;
        else return 0;
      } else {
        // there should be a function here to translate mileage to dates
        return 0;
      }
    });
  }

  StreamBuilder items() {
    return buildList('todos');
  }

  Future<void> scheduleNotification(MaintenanceTodoItem item) async {
    if (item.dueDate != null) {
      var id = await NotificationBLoC().scheduleNotification(
        datetime: item.dueDate,
        title: 'Maintenance ToDo Due Soon: ${item.name}',
        body: ''
      );
      item.notificationID = id;
    }
  }

  Future<void> push(MaintenanceTodoItem item) async {
    await scheduleNotification(item);
    pushItem('todos', item);
  }

  void edit(MaintenanceTodoItem item) {
    editItem('todos', item);
  }

  void delete(MaintenanceTodoItem item) {
    deleteItem('todos', item);
  }

  void undo() {
    undoItem('todos');
  }

  Future<WriteBatch> addUpdate(WriteBatch batch, MaintenanceTodoItem item) async {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    DocumentReference ref = userDoc
        .collection('todos')
        .document(item.ref);
    batch.setData(ref, item.toJSON());
    return batch;
  }

  // Make the object a Singleton
  static final TodoBLoC _bloc = TodoBLoC._internal();
  factory TodoBLoC() {
    return _bloc;
  }
  TodoBLoC._internal();
}
