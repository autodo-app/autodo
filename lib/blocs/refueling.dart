import 'package:autodo/blocs/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autodo/refueling/refuelingcard.dart';
import 'package:autodo/items/items.dart';

class FirebaseRefuelingBLoC {
  RefuelingItem _past;

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot) {
    var odom = snapshot.data['odom'].toInt();
    var cost;
    if (snapshot.data['cost'] != null)
      cost = snapshot.data['cost'].toDouble();
    else
      cost = 0.0;
    var amount = snapshot.data['amount'].toDouble();
    var carName = snapshot.data['carName'];
    var item = RefuelingItem(
        ref: snapshot.documentID, odom: odom, cost: cost, amount: amount, carName: carName);
    return RefuelingCard(item: item);
  }

  StreamBuilder buildList(BuildContext context) {
    if (FirestoreBLoC.isLoading()) return StreamBuilder();
    return StreamBuilder(
      stream: FirestoreBLoC.getUserDocument()
          .collection('refuelings')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center( 
            child: Text('Error getting data from database.')
          );
        }
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.documents.length == 0) {
          return Center( 
            child: Text('No Refuelings recorded yet.')
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildItem(context, snapshot.data.documents[index]),
        );
      },
    );
  }

  Future<void> push(RefuelingItem item) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = await userDoc
        .collection('refuelings')
        .add(item.toJSON());
    item.ref = ref.documentID;
  }

  Future<void> edit(RefuelingItem item) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = userDoc
        .collection('refuelings')
        .document(item.ref);
    ref.updateData(item.toJSON());
  }

  Future<void> delete(RefuelingItem item) async {
    _past = item;
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = userDoc
      .collection('refuelings')
      .document(item.ref);
    ref.delete();
  }

  void undo() {
    if (_past != null) push(_past);
    _past = null;
  }

  // Make the object a Singleton
  static final FirebaseRefuelingBLoC _bloc = FirebaseRefuelingBLoC._internal();
  factory FirebaseRefuelingBLoC() {
    return _bloc;
  }
  FirebaseRefuelingBLoC._internal();
}
