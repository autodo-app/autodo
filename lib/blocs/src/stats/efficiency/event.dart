import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class EfficiencyStatsEvent extends Equatable {
  const EfficiencyStatsEvent();

  @override
  List<Object> get props => [];
}

class LoadEfficiencyStats extends EfficiencyStatsEvent {}

class UpdateEfficiencyData extends EfficiencyStatsEvent {
  const UpdateEfficiencyData(this.refuelings);

  final List<Refueling> refuelings;

  @override
  List<Object> get props => [refuelings];

  @override
  String toString() => 'UpdateEfficiencyData { refuelings: $refuelings }';
}
