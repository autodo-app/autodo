import 'package:autodo/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockRecordSnapshot extends Mock implements RecordSnapshot {}

void main() {
  group('RefuelingEntity', () {
    final refueling = Refueling(
        id: '',
        carName: '',
        mileage: 0,
        date: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        amount: 0.0,
        cost: 0.0,
        carColor: Color(0),
        efficiency: 0.0,
        efficiencyColor: Color(0));
    test('props', () {
      expect(refueling.props, [
        '',
        '',
        0.0,
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        0.0,
        0.0,
        0,
        0.0,
        0
      ]);
    });
    test('toString', () {
      expect(
          refueling.toString(),
          'Refueling { carName: , carColor: ${Color(0)}, '
          'id: , mileage: 0.0, date: '
          '${DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)}, amount: 0.0, '
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
      final DocumentSnapshot snap = MockDocumentSnapshot();
      when(snap.documentID).thenReturn(docID);
      when(snap.data).thenReturn(doc);
      final refueling = Refueling(
          id: docID,
          carName: 'name',
          mileage: 0,
          date: DateTime.fromMillisecondsSinceEpoch(0),
          amount: 0.0,
          cost: 0.0,
          carColor: Color(0),
          efficiency: 0.0,
          efficiencyColor: Color(0));
      expect(Refueling.fromSnapshot(snap), refueling);
    });
    test('fromRecord', () {
      final doc = {
        'carName': 'name',
        'mileage': 0.0,
        'date': 0,
        'amount': 0.0,
        'cost': 0.0,
        'carColor': 0,
        'efficiency': 0.0,
        'efficiencyColor': 0
      };
      final docID = '0';
      final RecordSnapshot snap = MockRecordSnapshot();
      when(snap.key).thenReturn(docID);
      when(snap.value).thenReturn(doc);
      final refueling = Refueling(
          id: docID,
          carName: 'name',
          mileage: 0,
          date: DateTime.fromMillisecondsSinceEpoch(0),
          amount: 0.0,
          cost: 0.0,
          carColor: Color(0),
          efficiency: 0.0,
          efficiencyColor: Color(0));
      expect(Refueling.fromRecord(snap), refueling);
    });
  });
}
