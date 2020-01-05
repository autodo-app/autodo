import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:autodo/repositories/src/sembast_write_batch.dart';

class MockCollection extends Mock implements CollectionReference {}

class MockFirestore extends Mock implements Firestore {}

class MockBatch extends Mock implements WriteBatch {}

void main() {
  group('FirebaseWriteBatch', () {
    final firestore = MockFirestore();
    final batch = MockBatch();
    when(firestore.batch()).thenAnswer((_) => batch);
    final collection = MockCollection();
    when(collection.path).thenAnswer((_) => '');

    test('update', () async {
      final wrapper = SembastWriteBatch(
        store: StoreRef.main(),
        database: await databaseFactoryIo.openDatabase('test.db'),
      );
      wrapper.updateData('', {'test': ''});
    });
    test('set', () async {
      final wrapper = SembastWriteBatch(
        store: StoreRef.main(),
        database: await databaseFactoryIo.openDatabase('test.db'),
      );
      wrapper.setData({'test': ''});
    });
    test('commit', () async {
      final wrapper = SembastWriteBatch(
        store: StoreRef.main(),
        database: await databaseFactoryIo.openDatabase('test.db'),
      );
      wrapper.setData({'test': ''});
      wrapper.commit();
    });
    test('props', () async {
      final db = await databaseFactoryIo.openDatabase('test.db');
      expect(
          SembastWriteBatch(
            store: StoreRef.main(),
            database: db,
          )
              .props,
          [StoreRef.main(), db]);
    });
  });
}