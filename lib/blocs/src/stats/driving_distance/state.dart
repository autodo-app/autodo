import 'package:equatable/equatable.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/models/models.dart';

abstract class DrivingDistanceStatsState extends Equatable {
  const DrivingDistanceStatsState();

  @override
  List<Object> get props => [];
}

class DrivingDistanceStatsLoading extends DrivingDistanceStatsState {}

class DrivingDistanceStatsLoaded extends DrivingDistanceStatsState {
  const DrivingDistanceStatsLoaded(this.drivingDistanceData);

  final List<Series<DistanceRatePoint, DateTime>> drivingDistanceData;

  @override
  List<Object> get props => [
        (drivingDistanceData.isNotEmpty)
            ? drivingDistanceData
                ?.map((r) => r.id)
                ?.reduce((val, id) => val + id)
            : null
      ];

  @override
  String toString() {
    return 'StatsLoaded { drivingDistanceData: $drivingDistanceData }';
  }
}
