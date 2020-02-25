import 'package:equatable/equatable.dart';

class DistancePoint extends Equatable {
  final DateTime date;
  final int distance;

  DistancePoint(this.date, this.distance);

  @override
  List<Object> get props => [date?.toUtc(), distance];

  @override
  toString() =>
      "DistancePoint { date: ${date?.toUtc()}, distance: $distance }";
}