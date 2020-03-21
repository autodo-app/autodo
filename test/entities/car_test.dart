import 'package:autodo/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockRecordSnapshot extends Mock implements RecordSnapshot {}

void main() {
  group('CarEntity', () {
    final car = Car(
      id: '',
      name: '',
      lastMileageUpdate: DateTime.fromMillisecondsSinceEpoch(0),
    );
    test('props', () {
      expect(car.props, [
        '',
        '',
        0.0,
        0,
        0.0,
        0.0,
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        []
      ]);
    });
    test('toString', () {
      expect(
          car.toString(),
          'Car { id: , name: , mileage: 0.0, '
          'numRefuelings: 0, averageEfficiency: 0.0, distanceRate: '
          '0.0, lastMileageUpdate: ${DateTime.fromMillisecondsSinceEpoch(0)}, distanceRateHistory: [] }');
    });
    test('fromSnapshot', () {
      final doc = {
        'name': 'name',
        'mileage': 0,
        'numRefuelings': 0,
        'averageEfficiency': 0.0,
        'distanceRate': 0.0,
        'lastMileageUpdate': 0,
        'distanceRateHistory': [
          {'date': 0, 'distanceRate': 0.0}
        ],
      };
      final docID = '0';
      final DocumentSnapshot snap = MockDocumentSnapshot();
      when(snap.documentID).thenReturn(docID);
      when(snap.data).thenReturn(doc);
      final car = Car(
          id: '0',
          name: 'name',
          lastMileageUpdate: DateTime.fromMillisecondsSinceEpoch(0),
          distanceRateHistory: [
            DistanceRatePoint(DateTime.fromMillisecondsSinceEpoch(0), 0.0)
          ]);
      expect(Car.fromSnapshot(snap), car);
    });
    test('fromRecord', () {
      final doc = {
        'name': 'name',
        'mileage': 0.0,
        'numRefuelings': 0,
        'averageEfficiency': 0.0,
        'distanceRate': 0.0,
        'lastMileageUpdate': 0,
        'distanceRateHistory': [
          {'date': 0, 'distanceRate': 0.0}
        ],
      };
      final docID = '0';
      final RecordSnapshot snap = MockRecordSnapshot();
      when(snap.key).thenReturn(docID);
      when(snap.value).thenReturn(doc);
      final car = Car(
          id: '0',
          name: 'name',
          lastMileageUpdate: DateTime.fromMillisecondsSinceEpoch(0),
          distanceRateHistory: [
            DistanceRatePoint(DateTime.fromMillisecondsSinceEpoch(0), 0.0)
          ]);
      expect(Car.fromRecord(snap), car);
    });
  });
}
