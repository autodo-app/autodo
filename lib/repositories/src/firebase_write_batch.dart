import 'package:autodo/repositories/src/write_batch_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirebaseWriteBatch extends Equatable implements WriteBatchWrapper {
  final CollectionReference _collection;
  final WriteBatch _batch;

  FirebaseWriteBatch({@required firestoreInstance, @required collection})
      : this._batch = firestoreInstance?.batch() ?? Firestore.instance.batch(),
        assert(collection != null),
        this._collection = collection;

  @override
  updateData(String id, dynamic data) =>
      _batch.updateData(_collection.document(id), data);

  @override
  setData(dynamic data) => _batch.setData(_collection.document(), data);

  @override
  Future<void> commit() async {
    try {
      await _batch.commit();
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
