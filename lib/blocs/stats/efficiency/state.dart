import 'package:equatable/equatable.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/models/barrel.dart';

abstract class EfficiencyStatsState extends Equatable {
  const EfficiencyStatsState();

  @override
  List<Object> get props => [];
}

class EfficiencyStatsLoading extends EfficiencyStatsState {}

class EfficiencyStatsLoaded extends EfficiencyStatsState {
  final List<Series<FuelMileagePoint, DateTime>> fuelEfficiencyData;

  const EfficiencyStatsLoaded(this.fuelEfficiencyData);

  @override
  List<Object> get props => [fuelEfficiencyData];

  @override
  String toString() {
    return 'StatsLoaded { fuelEfficiencyData: $fuelEfficiencyData }';
  }
}