import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WriteBatchWrapper extends Equatable {
  final CollectionReference _collection;
  final WriteBatch _batch;

  WriteBatchWrapper({@required firestoreInstance, @required collection})
      : this._batch = firestoreInstance?.batch() ?? Firestore.instance.batch(),
        assert(collection != null),
        this._collection = collection;

  updateData(String id, dynamic data) =>
      _batch.updateData(_collection.document(id), data);

  setData(dynamic data) => _batch.setData(_collection.document(), data);

  commit() {
    try {
      _batch.commit();
    } on PlatformException catch (e) {
      print(e);
      if (e.code == "Error performing commit" &&
          e.message ==
              "PERMISSION_DENIED: Missing or insufficient permissions.") return;
    }
  }

  @override
  List<Object> get props => [_collection.path];
}
