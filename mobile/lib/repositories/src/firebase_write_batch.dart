import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'write_batch_wrapper.dart';

class FirebaseWriteBatch<T extends WriteBatchDocument> extends Equatable
    implements WriteBatchWrapper<T> {
  FirebaseWriteBatch({@required firestoreInstance, @required collection})
      : _batch = firestoreInstance?.batch() ?? Firestore.instance.batch(),
        assert(collection != null),
        _collection = collection;

  final CollectionReference _collection;

  final WriteBatch _batch;

  @override
  void updateData(String id, T data) =>
      _batch.updateData(_collection.document(id), data.toDocument());

  @override
  void setData(T data) =>
      _batch.setData(_collection.document(), data.toDocument());

  @override
  Future<Map<WRITE_OPERATION, dynamic>> commit() async {
    try {
      await _batch.commit();
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'Error performing commit' &&
          e.message ==
              'PERMISSION_DENIED: Missing or insufficient permissions.')
        return {};
    }
    return {};
  }

  @override
  List<Object> get props => [_collection.path];
}
