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
    this.semaphore,
    this.streamControllerUpdate,
  }) : transactionList = transactionList ?? [];

  final List<Function(DatabaseClient)> transactionList;

  final StoreRef store;

  final DatabaseFactory dbFactory;

  final String dbPath;

  final Function streamControllerUpdate;

  final Semaphore semaphore;

  @override
  void updateData(id, data) =>
      transactionList.add((txn) async => await store.record(id).put(txn, data));

  @override
  void setData(data) => transactionList.add((txn) async => await store.add(txn, data));

  @override
  Future<void> commit() async {
    await semaphore?.acquire();
    try {
      final db = await dbFactory.openDatabase(dbPath);
      await db.transaction((transaction) async {
        // a .forEach loop didn't await properly here... not sure why
        for (var txn in transactionList) {
          await txn(transaction);
        }
      });
      await db.close();
      if (streamControllerUpdate != null) await streamControllerUpdate();
    } finally {
      semaphore?.release();
    }
  }

  @override
  List<Object> get props => [store, dbPath];

  @override
  String toString() => 'SembastWriteBatch { store: $store, path: $dbPath }';
}
