import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

abstract class DrivingDistanceStatsEvent extends Equatable {
  const DrivingDistanceStatsEvent();

  @override 
  List<Object> get props => [];
}

class LoadDrivingDistanceStats extends DrivingDistanceStatsEvent {}

class UpdateDrivingDistanceData extends DrivingDistanceStatsEvent {
  final List<Refueling> cars;

  const UpdateDrivingDistanceData(this.cars);

  @override 
  List<Object> get props => [cars];
}