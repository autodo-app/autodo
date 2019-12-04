import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {
  const StatsState();
}

class InitialStatsState extends StatsState {
  @override
  List<Object> get props => [];
}
