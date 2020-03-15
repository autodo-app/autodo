import 'package:equatable/equatable.dart';
import 'package:semaphore/semaphore.dart';
import 'package:sembast/sembast.dart';
import 'package:flutter/material.dart';

import 'write_batch_wrapper.dart';

class SembastWriteBatch extends Equatable implements WriteBatchWrapper {
  SembastWriteBatch({
    transactionList,
    @required this.store,
    @required this.dbFactory,
    @required this.dbPath,
    this.mutex,
    this.streamControllerUpdate,
  }) : transactionList = transactionList ?? [];

  final List<Function(DatabaseClient)> transactionList;

  final StoreRef store;

  final DatabaseFactory dbFactory;

  final String dbPath;

  final Function streamControllerUpdate;

  final Semaphore mutex;

  @override
  void updateData(id, data) =>
      transactionList.add((txn) async => await store.record(id).put(txn, data));

  @override
  void setData(data) => transactionList.add((txn) async => await store.add(txn, data));

  @override
  Future<void> commit() async {
    await mutex.acquire();
    try {
      final db = await dbFactory.openDatabase(dbPath);
      await db.transaction((transaction) => transactionList.forEach((txn) async => await txn(transaction)));
      await db.close();
      if (streamControllerUpdate != null) await streamControllerUpdate();
    } finally {
      mutex.release();
    }
  }

  @override
  List<Object> get props => [store, dbPath];

  @override
  String toString() => 'SembastWriteBatch { store: $store, path: $dbPath }';
}
