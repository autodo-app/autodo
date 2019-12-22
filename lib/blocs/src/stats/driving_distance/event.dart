import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class DrivingDistanceStatsEvent extends Equatable {
  const DrivingDistanceStatsEvent();

  @override 
  List<Object> get props => [];
}

class LoadDrivingDistanceStats extends DrivingDistanceStatsEvent {}

class UpdateDrivingDistanceData extends DrivingDistanceStatsEvent {
  final List<Car> cars;

  const UpdateDrivingDistanceData(this.cars);

  @override 
  List<Object> get props => [cars];

  @override 
  toString() => "UpdateDrivingDistanceData { cars: $cars }";
}