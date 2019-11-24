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
      } else {
        // consider the dates since all todo items should have dates as a result
        // of the distance rate translation function
        return aDate.compareTo(bDate);
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

  Future<void> updateDueDates(Car car) async {
    WriteBatch batch = Firestore.instance.batch();
    QuerySnapshot snap = await FirestoreBLoC().getUserDocument()
        .collection('todos')
        .getDocuments();
    for (var todo in snap.documents) {
      if (!todo.data['tags'].contains(car.name) || 
          todo.data['estimatedDueDate'] == null || 
          !todo.data['estimatedDueDate'])
        continue;
      MaintenanceTodoItem item = MaintenanceTodoItem.fromMap(todo.data);

      var distanceToTodo = todo.data['dueMileage'] - car.mileage;
      int daysToTodo = (distanceToTodo / car.distanceRate).round();
      Duration timeToTodo = Duration(days: daysToTodo);
      item.dueDate = car.lastMileageUpdate.add(timeToTodo);
      print('${car.distanceRate} + ${item.dueDate}');
      scheduleNotification(item);
      var ref = FirestoreBLoC().getUserDocument()
        .collection('todos')
        .document(todo.documentID); 
      batch.updateData(ref, item.toJSON());
    }
    await batch.commit();
  }

  // Make the object a Singleton
  static final TodoBLoC _bloc = TodoBLoC._internal();
  factory TodoBLoC() {
    return _bloc;
  }
  TodoBLoC._internal();
}
