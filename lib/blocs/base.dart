import 'package:autodo/blocs/firestore.dart';
import 'package:autodo/blocs/filtering.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BLoC {
  var _past;

  Widget buildItem(dynamic item) => Container();

  List sortItems(List items) => items;

  StreamBuilder buildList(String collection, String filteringKey) {
    return StreamBuilder(  
      stream: FirestoreBLoC().getUserDocument()
        .collection(collection)
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center( 
            child: Text('Error getting data from database')
          );
        } else if (!snapshot.hasData) {
          return Center( 
            child: CircularProgressIndicator()
          );
        } else if (snapshot.data.documents.length == 0) {
          return Center( 
            child: Text('No items recorded yet.')
          );
        }

        var filteredData = [];
        snapshot.data.documents.forEach((item) {
          if (!FilteringBLoC().containsKey(item[filteringKey]) || 
              FilteringBLoC().value(item[filteringKey]) == true)
            filteredData.add(item);
        });

        filteredData = sortItems(filteredData);

        return ListView.builder(
          itemCount: filteredData.length,
          itemBuilder: (context, index) => buildItem(filteredData[index])
        );
      }
    );
  }

  Future<void> pushItem(String collection, dynamic item) async {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    DocumentReference ref = await userDoc
        .collection(collection)
        .add(item.toJSON());
    item.ref = ref.documentID;
  }

  void editItem(String collection, dynamic item) {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    DocumentReference ref = userDoc
        .collection(collection)
        .document(item.ref);
    ref.updateData(item.toJSON());
  }

  void deleteItem(String collection, dynamic item) {
    _past = item;
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    DocumentReference ref = userDoc
      .collection(collection)
      .document(item.ref);
    ref.delete();
  }

  void undoItem(String collection) {
    if (_past != null) pushItem(collection, _past);
    _past = null;
  }
}