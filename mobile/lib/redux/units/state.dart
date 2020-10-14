import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../units/units.dart';

class UnitsState extends Equatable {
  const UnitsState(
      {@required this.distance,
      @required this.efficiency,
      @required this.volume,
      @required this.currency});

  final Distance distance;

  final Efficiency efficiency;

  final Volume volume;

  final Currency currency;

  UnitsState copyWith(
          {DistanceUnit distance,
          EfficiencyUnit efficiency,
          VolumeUnit volume,
          String currency}) =>
      UnitsState(
          distance: distance ?? this.distance,
          efficiency: efficiency ?? this.efficiency,
          volume: volume ?? this.volume,
          currency: currency ?? this.currency);

  @override
  List get props => [distance, efficiency, volume, currency];
}
