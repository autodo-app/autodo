import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';

import 'package:autodo/repositories/src/firebase_write_batch.dart';

class MockCollection extends Mock implements CollectionReference {}

class MockFirestore extends Mock implements Firestore {}

class MockBatch extends Mock implements WriteBatch {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirebaseWriteBatch', () {
    final firestore = MockFirestore();
    final batch = MockBatch();
    when(firestore.batch()).thenAnswer((_) => batch);
    final collection = MockCollection();
    when(collection.path).thenAnswer((_) => '');

    test('Null collection', () {
      expect(
          () => FirebaseWriteBatch(
              firestoreInstance: firestore, collection: null),
          throwsAssertionError);
    });
    test('update', () {
      when(batch.updateData(collection.document(''), {'test': ''}))
          .thenAnswer((_) {});
      final wrapper = FirebaseWriteBatch(
          collection: collection, firestoreInstance: firestore);
      wrapper.updateData('', {'test': ''});
    });
    test('set', () {
      when(batch.setData(collection.document(), {'test': ''}))
          .thenAnswer((_) {});
      final wrapper = FirebaseWriteBatch(
          collection: collection, firestoreInstance: firestore);
      wrapper.setData({'test': ''});
    });
    test('commit', () {
      when(batch.commit()).thenAnswer((_) async {});
      final wrapper = FirebaseWriteBatch(
          collection: collection, firestoreInstance: firestore);
      wrapper.commit();
    });
    test('commit exception', () {
      when(batch.commit()).thenThrow(PlatformException(
          code: 'Error performing commit',
          message: 'PERMISSION_DENIED: Missing or insufficient permissions.'));
      final wrapper = FirebaseWriteBatch(
          collection: collection, firestoreInstance: firestore);
      wrapper.commit();
    });
    test('props', () {
      expect(
          FirebaseWriteBatch(
                  collection: collection, firestoreInstance: firestore)
              .props,
          ['']);
    });
  });
}
