import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class _FuelUsageMonth extends Equatable {
  const _FuelUsageMonth({@required this.date, @required this.amount});

  final DateTime date;
  final double amount;

  @override
  List<Object> get props => [date, amount];
}

class FuelUsageMonthData extends Equatable {
  const FuelUsageMonthData(this.data);

  /// Typedefs and aliases aren't supported in dartlang yet so this is used as
  /// a wrapper for this type definition.
  final Map<String, List<_FuelUsageMonth>> data;

  @override
  List<Object> get props => [data];
}

class FuelUsageCarData extends Equatable {
  const FuelUsageCarData(this.data);

  /// Also used in place of a typedef.
  final Map<String, double> data;

  @override
  List<Object> get props => [data];
}

class FuelEfficiencyDataPoint extends Equatable {
  const FuelEfficiencyDataPoint(
      {@required this.time, @required this.raw, @required this.filtered});

  final DateTime time;
  final double raw;
  final double filtered;

  @override
  List<Object> get props => [time, raw, filtered];
}

class FuelEfficiencyData extends Equatable {
  const FuelEfficiencyData(this.data);

  /// also used in place of a typedef
  final Map<String, List<FuelEfficiencyDataPoint>> data;

  @override
  List<Object> get props => [data];
}

class DrivingRatePoint extends Equatable {
  const DrivingRatePoint({@required this.time, @required this.rate});

  final DateTime time;
  final double rate;

  @override
  List<Object> get props => [time, rate];
}

class DrivingRateData extends Equatable {
  const DrivingRateData(this.data);

  /// also used in place of a typedef
  final Map<String, List<DrivingRatePoint>> data;

  @override
  List<Object> get props => [data];
}
