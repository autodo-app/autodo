import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

class StatsState extends Equatable {
  const StatsState(
      {@required this.fuelEfficiency,
      @required this.fuelUsageByCar,
      @required this.drivingRate,
      @required this.fuelUsageByMonth,
      @required this.status,
      @required this.error});

  final FuelEfficiencyData fuelEfficiency;
  final FuelUsageCarData fuelUsageByCar;
  final DrivingRateData drivingRate;
  final FuelUsageMonthData fuelUsageByMonth;
  final StatsStatus status;
  final String error;

  StatsState copyWith(
          {FuelEfficiencyData fuelEfficiency,
          FuelUsageCarData fuelUsageByCar,
          DrivingRateData drivingRate,
          FuelUsageMonthData fuelUsageByMonth,
          StatsStatus status,
          String error}) =>
      StatsState(
          fuelEfficiency: fuelEfficiency ?? this.fuelEfficiency,
          fuelUsageByCar: fuelUsageByCar ?? this.fuelUsageByCar,
          drivingRate: drivingRate ?? this.drivingRate,
          fuelUsageByMonth: fuelUsageByMonth ?? this.fuelUsageByMonth,
          status: status ?? this.status,
          error: error ?? this.error);

  @override
  List<Object> get props => [
        fuelEfficiency,
        fuelUsageByCar,
        drivingRate,
        fuelUsageByMonth,
        status,
        error
      ];
}
