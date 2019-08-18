import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autodo/refueling/refuelingcard.dart';
import 'package:autodo/items/items.dart';

class FirebaseRefuelingBLoC {
  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot) {
    var odom = snapshot.data['odom'].toInt();
    var cost = snapshot.data['cost'].toDouble();
    var amount = snapshot.data['amount'].toDouble();
    var item = RefuelingItem(odom: odom, cost: cost, amount: amount);
    return RefuelingCard(item: item);
  }

  StreamBuilder buildList(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('refuelings').snapshots(),
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
    Firestore.instance.runTransaction((transaction) async {
      // DocumentSnapshot freshSnap = await transaction.get(item.reference);

      // creates a new unique identifier for the item
      DocumentReference ref = Firestore.instance
          .collection('refuelings')
          .document(item.odom.toString() +
              item.cost.toString() +
              item.amount.toString());
      await transaction.set(
          ref, {'odom': item.odom, 'cost': item.cost, 'amount': item.amount});
    });
  }

  // Make the object a Singleton
  static final FirebaseRefuelingBLoC _bloc = FirebaseRefuelingBLoC._internal();
  factory FirebaseRefuelingBLoC() {
    return _bloc;
  }
  FirebaseRefuelingBLoC._internal() {}
}

class RefuelingBLoC {
  StreamController<RefuelingItem> ctrl;

  Function(RefuelingItem) get push => ctrl.sink.add;

  Stream<RefuelingItem> get stream => ctrl.stream;

  // Make the object a Singleton
  static final RefuelingBLoC _bloc = new RefuelingBLoC._internal();
  factory RefuelingBLoC() {
    return _bloc;
  }
  RefuelingBLoC._internal() {
    ctrl = StreamController<RefuelingItem>.broadcast();
  }

  dispose() {
    ctrl.close();
  }
}

RefuelingBLoC refuelingBLoC = RefuelingBLoC();
