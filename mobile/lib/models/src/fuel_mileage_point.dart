import 'package:equatable/equatable.dart';

class FuelMileagePoint extends Equatable {
  const FuelMileagePoint(this.date, this.efficiency);

  final DateTime date;

  final double efficiency;

  @override
  List<Object> get props => [date?.toUtc(), efficiency];

  @override
  String toString() =>
      'FuelMileagePoint { date: ${date?.toUtc()}, efficiency: $efficiency }';
}
