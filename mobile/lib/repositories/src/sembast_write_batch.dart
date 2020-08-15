// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:sembast/sembast.dart';

// import 'sembast_data_repository.dart';
// import 'write_batch_wrapper.dart';

// class SembastWriteBatch<T extends WriteBatchDocument> extends Equatable
//     implements WriteBatchWrapper<T> {
//   SembastWriteBatch(
//     this.repository, {
//     transactionList,
//     @required this.store,
//     this.streamControllerUpdate,
//   }) : transactionList = transactionList ?? [];

//   final List<Function(DatabaseClient)> transactionList;

//   final SembastDataRepository repository;

//   final StoreRef store;

//   final Function streamControllerUpdate;

//   @override
//   void updateData(String id, T data) => transactionList.add((txn) async =>
//       await store.record(int.parse(id)).put(txn, data.toDocument()));

//   @override
//   void setData(T data) => transactionList
//       .add((txn) async => await store.add(txn, data.toDocument()));

//   @override
//   Future<Map<WRITE_OPERATION, dynamic>> commit() async {
//     await SembastDataRepository.dbLock.acquire();
//     try {
//       await repository.db.transaction((transaction) async {
//         // a .forEach loop didn't await properly here... not sure why
//         for (var txn in transactionList) {
//           await txn(transaction);
//         }
//       });
//       if (streamControllerUpdate != null) await streamControllerUpdate();
//     } finally {
//       SembastDataRepository.dbLock.release();
//     }
//   }

//   @override
//   List<Object> get props => [store, repository.db.path];

//   @override
//   String toString() =>
//       'SembastWriteBatch { store: $store, path: ${repository.db.path} }';
// }
