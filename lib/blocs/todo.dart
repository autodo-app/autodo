import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/maintenance/todocard.dart';

class FirebaseTodoBLoC {
  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot) {
    var name = snapshot.data['name'];
    var date = snapshot.data['dueDate'].toDate();
    var mileage = snapshot.data['dueMileage'];
    var item =
        MaintenanceTodoItem(name: name, dueDate: date, dueMileage: mileage);
    return MaintenanceTodoCard(item: item);
  }

  StreamBuilder buildList(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('todos').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildItem(context, snapshot.data.documents[index]),
        );
      },
    );
  }

  void push(MaintenanceTodoItem item) {
    Firestore.instance.runTransaction((transaction) async {
      // DocumentSnapshot freshSnap = await transaction.get(item.reference);

      // creates a new unique identifier for the item
      DocumentReference ref = Firestore.instance.collection('todos').document(
          item.name.toString() +
              item.dueDate.toString() +
              item.dueMileage.toString());
      await transaction.set(ref, {
        'name': item.name,
        'dueDate': item.dueDate,
        'dueMileage': item.dueMileage
      });
    });
  }

  void transact() {
    MaintenanceTodoItem item; // todo: replace this with an actual item
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(item.reference);
      await transaction.update(freshSnap.reference, {
        'name': freshSnap['name'] + 'suffix',
      });
    });
  }

  // Make the object a Singleton
  static final FirebaseTodoBLoC _bloc = FirebaseTodoBLoC._internal();
  factory FirebaseTodoBLoC() {
    return _bloc;
  }
  FirebaseTodoBLoC._internal() {}
}

class TodoBLoC {
  StreamController<MaintenanceTodoItem> ctrl;
  final DocumentReference postRef = Firestore.instance.document('todos');

  void push(MaintenanceTodoItem item) {
    ctrl.sink.add;
    // Firestore.instance.runTransaction((transaction) async {
    //   await transaction.set(item.reference, item.toMap());
    //   // final freshSnapshot = await transaction.get(item.reference);
    //   // final fresh = MaintenanceTodoItem.fromSnapshot(freshSnapshot);

    //   // await transaction.update(item.reference, {'votes': fresh.votes + 1});
    // });
  }

  pushNew(String name, int mileage, DateTime date) {
    var item =
        MaintenanceTodoItem(name: name, dueDate: date, dueMileage: mileage);
    push(item);
  }

  Stream<MaintenanceTodoItem> get stream => ctrl.stream;

  // Make the object a Singleton
  static final TodoBLoC _bloc = new TodoBLoC._internal();
  factory TodoBLoC() {
    return _bloc;
  }
  TodoBLoC._internal() {
    ctrl = StreamController<MaintenanceTodoItem>.broadcast();
  }

  dispose() {
    ctrl.close();
  }
}

TodoBLoC todoBLoC = TodoBLoC();
