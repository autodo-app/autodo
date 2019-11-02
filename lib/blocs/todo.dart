import 'package:autodo/blocs/filtering.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/maintenance/todocard.dart';
import 'package:autodo/blocs/firestore.dart';
import 'package:autodo/blocs/notifications.dart';

class FirebaseTodoBLoC {
  MaintenanceTodoItem _past;

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot, bool first) {
    var name = (first) ? 'Upcoming: ' : ''; // TODO: move this logic to the card
    name += snapshot.data['name'];
    var date;
    if (snapshot.data.containsKey('dueDate') && snapshot.data['dueDate'] != null)
      date = snapshot.data['dueDate'].toDate();
    var mileage = snapshot.data['dueMileage'];
    var item = MaintenanceTodoItem(
      ref: snapshot.documentID,
      name: name,
      dueDate: date,
      dueMileage: mileage,
      repeatingType: snapshot.data['repeatingType'],
      tags: snapshot.data['tags']
    );
    return MaintenanceTodoCard(item: item, emphasized: first);
  }

  List _sortItems(List items) {
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

  StreamBuilder buildList(BuildContext context) {
    if (FirestoreBLoC.isLoading()) return StreamBuilder(
      builder: (context, snapshot) {
        return Text('Loading...');
      }
    );
    Widget upcomingDivider = Container( 
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Divider()
    );
    return StreamBuilder(
      stream: FirestoreBLoC.getUserDocument()
          .collection('todos')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        var data = _sortItems(snapshot.data.documents);
        print('filtering');
        var filteredData = [];
        data.forEach((item) {
          item.data['tags'].forEach((tag) {
            if (!FilteringBLoC().containsKey(tag) || FilteringBLoC().value(tag) == true)
              filteredData.add(item);
          });          
        });
        return ListView.separated(
          itemCount: filteredData.length,
          separatorBuilder: (context, index) => (index == 0) ? upcomingDivider : Container(),
          itemBuilder: (context, index) =>
              _buildItem(context, filteredData[index], index == 0),
        );
      },
    );
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
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = await userDoc
        .collection('todos')
        .add(item.toJSON());
    if (ref == null) {
      print("Error, push failed");
      return;
    }
    item.ref = ref.documentID;
    ref.setData(item.toJSON());
  }

  Future<void> edit(MaintenanceTodoItem item) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = userDoc
      .collection('todos')
      .document(item.ref);
    ref.updateData(item.toJSON());
  }

  Future<void> delete(MaintenanceTodoItem item) async {
    _past = item;
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = userDoc
      .collection('todos')
      .document(item.ref);
    ref.delete();
  }

  void undo() {
    if (_past != null) push(_past);
    _past = null;
  }

  bool isLoading() {
    return Auth().isLoading();
  }

  Future<WriteBatch> addUpdate(WriteBatch batch, MaintenanceTodoItem item) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = userDoc
        .collection('todos')
        .document(item.ref);
    batch.setData(ref, item.toJSON());
    return batch;
  }

  // Make the object a Singleton
  static final FirebaseTodoBLoC _bloc = FirebaseTodoBLoC._internal();
  factory FirebaseTodoBLoC() {
    return _bloc;
  }
  FirebaseTodoBLoC._internal();
}
