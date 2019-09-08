import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autodo/refueling/refuelingcard.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/userauth.dart';

class FirebaseRefuelingBLoC {
  final Firestore _db = Firestore.instance;

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot) {
    var odom = snapshot.data['odom'].toInt();
    var cost = snapshot.data['cost'].toDouble();
    var amount = snapshot.data['amount'].toDouble();
    var item = RefuelingItem(
        ref: snapshot.documentID, odom: odom, cost: cost, amount: amount);
    return RefuelingCard(item: item);
  }

  StreamBuilder buildList(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(Auth().getCurrentUser())
          .collection('refuelings')
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

  void push(RefuelingItem item) {
    _db.runTransaction((transaction) async {
      // creates a new unique identifier for the item
      DocumentReference ref = await _db
          .collection('users')
          .document(Auth().getCurrentUser())
          .collection('refuelings')
          .add(item.toJSON());
      item.ref = ref.documentID;
      await transaction.set(ref, item.toJSON());
    });
  }

  void edit(RefuelingItem item) {
    _db.runTransaction((transaction) async {
      // Grab the item's existing identifier
      DocumentReference ref = _db
          .collection('users')
          .document(Auth().getCurrentUser())
          .collection('refuelings')
          .document(item.ref);
      await transaction.update(ref, item.toJSON());
    });
  }

  // Make the object a Singleton
  static final FirebaseRefuelingBLoC _bloc = FirebaseRefuelingBLoC._internal();
  factory FirebaseRefuelingBLoC() {
    return _bloc;
  }
  FirebaseRefuelingBLoC._internal();
}
