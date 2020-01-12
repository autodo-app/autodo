import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:flutter/material.dart';

import 'write_batch_wrapper.dart';

class SembastWriteBatch extends Equatable implements WriteBatchWrapper {
  final List<Function(DatabaseClient)> transactionList;
  final StoreRef store;
  final Database database;
  final Function streamControllerUpdate;

  SembastWriteBatch({
    transactionList,
    @required this.store,
    @required this.database,
    this.streamControllerUpdate,
  }) : this.transactionList = transactionList ?? [];

  @override
  updateData(id, data) => transactionList.add((txn) =>
      store.update(txn, data, finder: Finder(filter: Filter.byKey(id))));

  @override
  setData(data) => transactionList.add((txn) => store.add(txn, data));

  @override
  Future<void> commit() async {
    await database.transaction((txn) async {
      for (var t in transactionList) {
        await t(txn);
      }
    });
    if (streamControllerUpdate != null) streamControllerUpdate();
  }

  @override
  List<Object> get props => [store, database];

  @override
  toString() => "SembastWriteBatch { store: $store, database: $database }";
}
