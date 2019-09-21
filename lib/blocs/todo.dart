import 'package:autodo/blocs/userauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/maintenance/todocard.dart';
import 'package:autodo/blocs/firestore.dart';

class FirebaseTodoBLoC {
  final Firestore _db = Firestore.instance;
  MaintenanceTodoItem _past;

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot) {
    var name = snapshot.data['name'];
    var date;
    if (snapshot.data.containsKey('dueDate') && snapshot.data['dueDate'] != null)
      date = snapshot.data['dueDate'].toDate();
    var mileage = snapshot.data['dueMileage'];
    var item = MaintenanceTodoItem(
        ref: snapshot.documentID,
        name: name,
        dueDate: date,
        dueMileage: mileage);
    return MaintenanceTodoCard(item: item);
  }

  StreamBuilder buildList(BuildContext context) {
    if (FirestoreBLoC.isLoading()) return StreamBuilder();
    return StreamBuilder(
      stream: FirestoreBLoC.getUserDocument()
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
      DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
      DocumentReference ref = await userDoc
          .collection('todos')
          .add(item.toJSON());
      if (ref == null) {
        print("Error, push failed");
        return;
      }
      item.ref = ref.documentID;
      await transaction.set(ref, item.toJSON());
    });
  }

  void edit(MaintenanceTodoItem item) {
    _db.runTransaction((transaction) async {
      // Grab the item's existing identifier
      DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
      DocumentReference ref = userDoc
          .collection('todos')
          .document(item.ref);
      await transaction.update(ref, item.toJSON());
    });
  }

  void delete(MaintenanceTodoItem item) {
    _past = item;
    _db.runTransaction((transaction) async {
      // Grab the item's existing identifier
      DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
      DocumentReference ref = userDoc
          .collection('todos')
          .document(item.ref);
      await transaction.delete(ref);
    });
  }

  void undo() {
    if (_past != null) push(_past);
    _past = null;
  }

  bool isLoading() {
    return Auth().isLoading();
  }

  // Make the object a Singleton
  static final FirebaseTodoBLoC _bloc = FirebaseTodoBLoC._internal();
  factory FirebaseTodoBLoC() {
    return _bloc;
  }
  FirebaseTodoBLoC._internal();
}
