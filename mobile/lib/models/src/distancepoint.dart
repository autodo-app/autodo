import 'package:equatable/equatable.dart';

class DistancePoint extends Equatable {
  const DistancePoint(this.date, this.distance);

  final DateTime date;

  final double distance;

  @override
  List<Object> get props => [date?.toUtc(), distance];

  @override
  String toString() =>
      'DistancePoint { date: ${date?.toUtc()}, distance: $distance }';
}
