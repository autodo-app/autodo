import 'package:equatable/equatable.dart';

class DistanceRatePoint extends Equatable {
  const DistanceRatePoint(this.date, this.distanceRate);

  final DateTime date;

  final double distanceRate;

  @override
  List<Object> get props => [date?.toUtc(), distanceRate];

  @override
  String toString() =>
      'DistanceRatePoint { date: ${date?.toUtc()}, distanceRate: $distanceRate }';
}
