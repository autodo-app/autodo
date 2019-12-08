import 'package:cloud_firestore/cloud_firestore.dart';

class WriteBatchWrapper {
  final CollectionReference _collection;
  final WriteBatch _batch = Firestore.instance.batch();

  WriteBatchWrapper(this._collection);

  updateData(String id, dynamic data) => 
      _batch.updateData(_collection.document(id), data);

  commit() => _batch.commit();
}