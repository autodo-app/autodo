import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class DrivingDistanceStatsEvent extends Equatable {
  const DrivingDistanceStatsEvent();

  @override
  List<Object> get props => [];
}

class LoadDrivingDistanceStats extends DrivingDistanceStatsEvent {}

class UpdateDrivingDistanceData extends DrivingDistanceStatsEvent {
  const UpdateDrivingDistanceData(this.cars);

  final List<Car> cars;

  @override
  List<Object> get props => [cars];

  @override
  String toString() => 'UpdateDrivingDistanceData { cars: $cars }';
}
