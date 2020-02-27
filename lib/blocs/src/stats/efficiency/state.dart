import 'package:equatable/equatable.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/models/models.dart';

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
  List<Object> get props => [
        fuelEfficiencyData
            ?.map((r) => r.id)
            ?.fold('', (val, id) => (val as String) + id),
        fuelEfficiencyData
            ?.map((r) => r.data)
            ?.fold([], (val, data) => (val as List)..addAll(data))
      ];

  @override
  String toString() {
    final data = fuelEfficiencyData
        .map((p) => p.data.toString())
        .fold('', (val, str) => val + str);
    return 'EfficiencyStatsLoaded { fuelEfficiencyData: $data }';
  }
}
