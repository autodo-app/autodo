import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@immutable
class OdomSnapshot extends Equatable {
  const OdomSnapshot({
    this.id,
    this.car,
    @required this.date,
    @required this.mileage,
  });

  factory OdomSnapshot.fromMap(String id, Map<String, String> value) =>
      OdomSnapshot(
        id: id,
        car: value['car'],
        date: DateTime.parse(value['date']),
        mileage: double.parse(value['mileage']),
      );

  /// The UID for the OdomSnapshot object on the server.
  final String id;

  /// The UID for the associated Car object on the server.
  final String car;

  /// The date and time when this odometer reading was logged.
  final DateTime date;

  /// The odometer reading.
  final double mileage;

  OdomSnapshot copyWith({String id, int car, DateTime date, double mileage}) =>
      OdomSnapshot(
          id: id ?? this.id,
          car: car ?? this.car,
          date: date ?? this.date,
          mileage: mileage ?? this.mileage);

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
