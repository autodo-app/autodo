import 'package:autodo/blocs/userauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/maintenance/todocard.dart';

class FirebaseTodoBLoC {
  final Firestore _db = Firestore.instance;

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot) {
    var name = snapshot.data['name'];
    var date = snapshot.data['dueDate'].toDate();
    var mileage = snapshot.data['dueMileage'];
    var item = MaintenanceTodoItem(
        ref: snapshot.documentID,
        name: name,
        dueDate: date,
        dueMileage: mileage);
    return MaintenanceTodoCard(item: item);
  }

  StreamBuilder buildList(BuildContext context) {
    return StreamBuilder(
      stream: _db
          .collection('users')
          .document(Auth().getCurrentUser())
          .collection('todos')
          .snapshots(),
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
    _db.runTransaction((transaction) async {
      // creates a new unique identifier for the item
      DocumentReference ref = await _db
          .collection('users')
          .document(Auth().getCurrentUser())
          .collection('todos')
          .add(item.toJSON());
      item.ref = ref.documentID;
      await transaction.set(ref, item.toJSON());
    });
  }

  void edit(MaintenanceTodoItem item) {
    _db.runTransaction((transaction) async {
      // Grab the item's existing identifier
      DocumentReference ref = _db
          .collection('users')
          .document(Auth().getCurrentUser())
          .collection('todos')
          .document(item.ref);
      await transaction.update(ref, item.toJSON());
    });
  }

  // Make the object a Singleton
  static final FirebaseTodoBLoC _bloc = FirebaseTodoBLoC._internal();
  factory FirebaseTodoBLoC() {
    return _bloc;
  }
  FirebaseTodoBLoC._internal() {}
}
