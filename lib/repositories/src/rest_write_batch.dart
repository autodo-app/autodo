import 'package:equatable/equatable.dart';

import 'write_batch_wrapper.dart';

class RestWriteBatch<T extends WriteBatchDocument> extends Equatable
    implements WriteBatchWrapper<T> {
  @override
  void updateData(String id, T data) {}

  @override
  void setData(T data) {}

  @override
  Future<void> commit() async {
    // await SembastDataRepository.dbLock.acquire();
    // try {
    //   await repository.db.transaction((transaction) async {
    //     // a .forEach loop didn't await properly here... not sure why
    //     for (var txn in transactionList) {
    //       await txn(transaction);
    //     }
    //   });
    //   if (streamControllerUpdate != null) await streamControllerUpdate();
    // } finally {
    //   SembastDataRepository.dbLock.release();
    // }
  }

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'RestWriteBatch';
}