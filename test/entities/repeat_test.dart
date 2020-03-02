import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/entities/entities.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockRecordSnapshot extends Mock implements RecordSnapshot {}

void main() {
  group('RepeatEntity', () {
    final repeat = RepeatEntity('', '', 0, Duration(hours: 0), ['']);
    test('props', () {
      expect(repeat.props, [
        '',
        '',
        0,
        Duration(hours: 0),
        ['']
      ]);
    });
    test('toString', () {
      expect(
          repeat.toString(),
          'RepeatEntity { id: , name: , mileage'
          'Interval: 0.0, dateInterval: ${Duration(hours: 0)}, cars: '
          '[]}');
    });
    test('fromSnapshot', () {
      final doc = {
        'name': 'name',
        'mileageInterval': 0,
        'dateInterval': 0,
        'cars': ['test']
      };
      final docID = '0';
      final DocumentSnapshot snap = MockDocumentSnapshot();
      when(snap.documentID).thenReturn(docID);
      when(snap.data).thenReturn(doc);
      final repeat = RepeatEntity('0', 'name', 0, Duration(days: 0), ['test']);
      expect(RepeatEntity.fromSnapshot(snap), repeat);
    });
    test('fromRecord', () {
      final doc = {
        'name': 'name',
        'mileageInterval': 0.0,
        'dateInterval': 0,
        'cars': ['test']
      };
      final docID = '0';
      final RecordSnapshot snap = MockRecordSnapshot();
      when(snap.key).thenReturn(docID);
      when(snap.value).thenReturn(doc);
      final repeat = RepeatEntity('0', 'name', 0, Duration(days: 0), ['test']);
      expect(RepeatEntity.fromRecord(snap), repeat);
    });
  });
}
