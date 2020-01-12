import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:autodo/entities/entities.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockRecordSnapshot extends Mock implements RecordSnapshot {}

void main() {
  group('RefuelingEntity', () {
    final refueling = RefuelingEntity(
        '',
        '',
        0,
        DateTime.fromMillisecondsSinceEpoch(0),
        0.0,
        0.0,
        Color(0),
        0.0,
        Color(0));
    test('props', () {
      expect(refueling.props, [
        '',
        '',
        0,
        DateTime.fromMillisecondsSinceEpoch(0),
        0.0,
        0.0,
        Color(0),
        0.0,
        Color(0)
      ]);
    });
    test('toString', () {
      expect(
          refueling.toString(),
          'RefuelingEntity { id: , name: , carColor: '
          '${Color(0)}, mileage: 0, date: '
          '${DateTime.fromMillisecondsSinceEpoch(0)}, amount: 0.0, '
          'cost: 0.0, efficiency: 0.0, efficiencyColor: ${Color(0)} }');
    });
    test('fromSnapshot', () {
      final doc = {
        'carName': 'name',
        'mileage': 0,
        'date': 0,
        'amount': 0.0,
        'cost': 0.0,
        'carColor': 0,
        'efficiency': 0.0,
        'efficiencyColor': 0
      };
      final docID = '0';
      DocumentSnapshot snap = MockDocumentSnapshot();
      when(snap.documentID).thenReturn(docID);
      when(snap.data).thenReturn(doc);
      final refueling = RefuelingEntity(
          docID,
          'name',
          0,
          DateTime.fromMillisecondsSinceEpoch(0),
          0.0,
          0.0,
          Color(0),
          0.0,
          Color(0));
      expect(RefuelingEntity.fromSnapshot(snap), refueling);
    });
    test('fromRecord', () {
      final doc = {
        'carName': 'name',
        'mileage': 0,
        'date': 0,
        'amount': 0.0,
        'cost': 0.0,
        'carColor': 0,
        'efficiency': 0.0,
        'efficiencyColor': 0
      };
      final docID = '0';
      RecordSnapshot snap = MockRecordSnapshot();
      when(snap.key).thenReturn(docID);
      when(snap.value).thenReturn(doc);
      final refueling = RefuelingEntity(
          docID,
          'name',
          0,
          DateTime.fromMillisecondsSinceEpoch(0),
          0.0,
          0.0,
          Color(0),
          0.0,
          Color(0));
      expect(RefuelingEntity.fromRecord(snap), refueling);
    });
  });
}
