void main() {}
// import 'dart:io';

// import 'package:autodo/repositories/src/sembast_data_repository.dart';
// import 'package:autodo/repositories/src/sembast_write_batch.dart';
// import 'package:autodo/repositories/src/write_batch_wrapper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:sembast/sembast.dart';

// class MockCollection extends Mock implements CollectionReference {}

// class MockFirestore extends Mock implements Firestore {}

// class MockBatch extends Mock implements WriteBatch {}

// class Wrapper implements WriteBatchDocument {
//   Wrapper(this.map);

//   final Map<String, Object> map;

//   @override
//   Map<String, Object> toDocument() => map;
// }

// void main() {
//   group('SembastWriteBatch', () {
//     // final semaphore = LocalSemaphore(255);
//     final firestore = MockFirestore();
//     final batch = MockBatch();
//     when(firestore.batch()).thenAnswer((_) => batch);
//     final collection = MockCollection();
//     when(collection.path).thenAnswer((_) => '');
//     SembastDataRepository db;

//     setUp(() async {
//       db = await SembastDataRepository.open(
//           dbPath: './test.db', pathProvider: () => Directory('.'));
//     });

//     tearDown(() async {
//       await SembastDataRepository.deleteDb('./test.db');
//     });

//     test('update', () async {
//       final wrapper = SembastWriteBatch(db, store: StoreRef.main());
//       wrapper.updateData('', Wrapper({'test': ''}));
//     });
//     test('set', () async {
//       final wrapper = SembastWriteBatch(db, store: StoreRef.main());
//       wrapper.setData(Wrapper({'test': ''}));
//     });
//     test('commit', () async {
//       final wrapper = SembastWriteBatch(db, store: StoreRef.main());
//       wrapper.setData(Wrapper({'test': ''}));
//       await wrapper.commit();
//     });
//     test('props', () async {
//       expect(SembastWriteBatch(db, store: StoreRef.main()).props,
//           [StoreRef.main(), db.db.path]);
//     });
//   });
// }
