import 'package:equatable/equatable.dart';

class DistanceRatePoint extends Equatable {
  final DateTime date;
  final double distanceRate;

  DistanceRatePoint(this.date, this.distanceRate);

  @override
  List<Object> get props => [date?.toUtc(), distanceRate];

  @override
  toString() =>
      "DistanceRatePoint { date: ${date?.toUtc()}, distanceRate: $distanceRate }";
}