import 'package:autodo/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockRecordSnapshot extends Mock implements RecordSnapshot {}

void main() {
  group('RepeatEntity', () {
    final repeat = Repeat(
      id: '',
      name: '',
      mileageInterval: 0,
      dateInterval: Duration(hours: 0),
      cars: [''],
    );
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
          'Repeat { id: , name: , mileage'
          'Interval: 0.0, dateInterval: ${Duration(hours: 0)}, cars: '
          '[] }');
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
      final repeat = Repeat(
        id: '0',
        name: 'name',
        mileageInterval: 0,
        dateInterval: Duration(days: 0),
        cars: ['test'],
      );
      expect(Repeat.fromSnapshot(snap), repeat);
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
      final repeat = Repeat(
        id: '0',
        name: 'name',
        mileageInterval: 0,
        dateInterval: Duration(days: 0),
        cars: ['test'],
      );
      expect(Repeat.fromRecord(snap), repeat);
    });
  });
}
