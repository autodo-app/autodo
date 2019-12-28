import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class EfficiencyStatsEvent extends Equatable {
  const EfficiencyStatsEvent();

  @override
  List<Object> get props => [];
}

class LoadEfficiencyStats extends EfficiencyStatsEvent {}

class UpdateEfficiencyData extends EfficiencyStatsEvent {
  final List<Refueling> refuelings;

  const UpdateEfficiencyData(this.refuelings);

  @override
  List<Object> get props => [refuelings];

  @override
  toString() => 'UpdateEfficiencyData { refuelings: $refuelings }';
}
