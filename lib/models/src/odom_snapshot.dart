import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repositories/src/write_batch_wrapper.dart';

@immutable
class OdomSnapshot extends Equatable implements WriteBatchDocument {
  const OdomSnapshot({
    this.id,
    this.car,
    @required this.date,
    @required this.mileage,
  })  : assert(date != null),
        assert(mileage != null);

  factory OdomSnapshot.fromMap(String id, Map<String, String> value) =>
      OdomSnapshot(
        id: id,
        car: value['car'],
        date: DateTime.parse(value['date']),
        mileage: double.parse(value['mileage']),
      );

  final String id;

  final String car;

  final DateTime date;

  final double mileage;

  OdomSnapshot copyWith({String id, int car, DateTime date, double mileage}) =>
      OdomSnapshot(
          id: id ?? this.id,
          car: car ?? this.car,
          date: date ?? this.date,
          mileage: mileage ?? this.mileage);

  @override
  Map<String, String> toDocument() => {
        'car': car,
        'date': date?.toUtc()?.toIso8601String(),
        'mileage': mileage.toString(),
      };

  @override
  String toString() =>
      '$runtimeType { id: $id, car: $car, date: $date, mileage: $mileage';

  @override
  List<Object> get props => [id, car, date?.toUtc(), mileage];
}
