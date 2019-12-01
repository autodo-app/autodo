import 'package:autodo/blocs/subcomponents/firestore.dart';
import 'package:autodo/blocs/filtering.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/util.dart';

class BLoC {
  var _past;

  Widget buildItem(dynamic item, int index) => Container();

  List sortItems(List items) => items;

  StreamBuilder buildList(String collection) {
    return StreamBuilder(
        stream: FirestoreBLoC()
            .getUserDocument()
            .collection(collection)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error getting data from database'));
          } else if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.documents.length == 0) {
            return Center(child: Text('No items recorded yet.'));
          }

          var filteredData = [];
          snapshot.data.documents.forEach((item) {
            if (!item.data.containsKey('tags') || item.data['tags'] == null) {
              filteredData.add(item);
              return;
            }

            item.data['tags'].forEach((tag) {
              if (!FilteringBLoC().containsKey(tag) ||
                  FilteringBLoC().value(tag) == true) filteredData.add(item);
            });
          });

          filteredData = sortItems(filteredData);

          return ListView.builder(
              itemCount: filteredData.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredData.length) {
                  // allows the bottom item to be scrolled up above the FAB
                  return Container(
                      height: clamp(MediaQuery.of(context).size.height - 400,
                          80.0, double.infinity));
                }
                return buildItem(filteredData[index], index);
              });
        });
  }

  Future<void> pushItem(String collection, dynamic item) async {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    DocumentReference ref =
        await userDoc.collection(collection).add(item.toJSON());
    item.ref = ref.documentID;
  }

  void editItem(String collection, dynamic item) {
    if (item.ref == null) {
      print('Cannot update an item without a reference key');
      return;
    }
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    DocumentReference ref = userDoc.collection(collection).document(item.ref);
    ref.updateData(item.toJSON());
  }

  void deleteItem(String collection, dynamic item) {
    _past = item;
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    DocumentReference ref = userDoc.collection(collection).document(item.ref);
    ref.delete();
  }

  dynamic undoItem(String collection) {
    if (_past != null) pushItem(collection, _past);
    var out = _past;
    _past = null;
    return out;
  }
}
