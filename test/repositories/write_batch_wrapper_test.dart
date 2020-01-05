import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';

import 'package:autodo/repositories/repositories.dart';

class MockCollection extends Mock implements CollectionReference {}

class MockFirestore extends Mock implements Firestore {}

class MockBatch extends Mock implements WriteBatch {}

void main() {
  group('WriteBatchWrapper', () {
    final firestore = MockFirestore();
    final batch = MockBatch();
    when(firestore.batch()).thenAnswer((_) => batch);
    final collection = MockCollection();
    when(collection.path).thenAnswer((_) => '');

    test('Null collection', () {
      expect(
          () =>
              WriteBatchWrapper(firestoreInstance: firestore, collection: null),
          throwsAssertionError);
    });
    test('update', () {
      when(batch.updateData(collection.document(''), {'test': ''}))
          .thenAnswer((_) {});
      final wrapper = WriteBatchWrapper(
          collection: collection, firestoreInstance: firestore);
      expect(wrapper.updateData('', {'test': ''}), null);
    });
    test('set', () {
      when(batch.setData(collection.document(), {'test': ''}))
          .thenAnswer((_) {});
      final wrapper = WriteBatchWrapper(
          collection: collection, firestoreInstance: firestore);
      expect(wrapper.setData({'test': ''}), null);
    });
    test('commit', () {
      when(batch.commit()).thenAnswer((_) async {});
      final wrapper = WriteBatchWrapper(
          collection: collection, firestoreInstance: firestore);
      expect(wrapper.commit(), null);
    });
    test('commit exception', () {
      when(batch.commit()).thenThrow(PlatformException(
          code: "Error performing commit",
          message: "PERMISSION_DENIED: Missing or insufficient permissions."));
      final wrapper = WriteBatchWrapper(
          collection: collection, firestoreInstance: firestore);
      expect(wrapper.commit(), null);
    });
    test('props', () {
      expect(
          WriteBatchWrapper(
                  collection: collection, firestoreInstance: firestore)
              .props,
          ['']);
    });
  });
}
