import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:flutter/material.dart';

import 'write_batch_wrapper.dart';

class SembastWriteBatch extends Equatable implements WriteBatchWrapper {
  final List<Function(DatabaseClient)> transactionList;
  final StoreRef store;
  final DatabaseFactory dbFactory;
  final String dbPath;
  final Function streamControllerUpdate;

  SembastWriteBatch({
    transactionList,
    @required this.store,
    @required this.dbFactory,
    @required this.dbPath,
    this.streamControllerUpdate,
  }) : this.transactionList = transactionList ?? [];

  @override
  updateData(id, data) =>
      transactionList.add((txn) => store.record(id).put(txn, data));

  @override
  setData(data) => transactionList.add((txn) => store.add(txn, data));

  @override
  Future<void> commit() async {
    var db = await dbFactory.openDatabase(dbPath);
    print('opened');
    await db.transaction((txn) async {
      print('list: ${transactionList}');
      for (var t in transactionList) {
        await t(txn);
      }
    });
    if (streamControllerUpdate != null) streamControllerUpdate();
    db.close();
  }

  @override
  List<Object> get props => [store, dbPath];

  @override
  toString() => "SembastWriteBatch { store: $store, path: $dbPath }";
}
