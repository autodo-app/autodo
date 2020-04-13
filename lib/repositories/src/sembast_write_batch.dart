import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import 'sembast_data_repository.dart';
import 'write_batch_wrapper.dart';

class SembastWriteBatch extends Equatable implements WriteBatchWrapper {
  SembastWriteBatch(
    this.repository, {
    transactionList,
    @required this.store,
    this.streamControllerUpdate,
  }) : transactionList = transactionList ?? [];

  final List<Function(DatabaseClient)> transactionList;

  final SembastDataRepository repository;

  final StoreRef store;

  final Function streamControllerUpdate;

  @override
  void updateData(id, data) => transactionList
      .add((txn) async => await store.record(id).update(txn, data));

  @override
  void setData(data) =>
      transactionList.add((txn) async => await store.add(txn, data));

  @override
  Future<void> commit() async {
    await SembastDataRepository.dbLock.acquire();
    try {
      await repository.db.transaction((transaction) async {
        // a .forEach loop didn't await properly here... not sure why
        for (var txn in transactionList) {
          await txn(transaction);
        }
      });
      if (streamControllerUpdate != null) await streamControllerUpdate();
    } finally {
      SembastDataRepository.dbLock.release();
    }
  }

  @override
  List<Object> get props => [store, repository.db.path];

  @override
  String toString() =>
      'SembastWriteBatch { store: $store, path: ${repository.db.path} }';
}
