import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repositories/repositories.dart';
import '../auth/state.dart';
import '../data/state.dart';
import '../stats/state.dart';

class AppState extends Equatable {
  const AppState(
      {@required this.api,
      @required this.authState,
      @required this.dataState,
      @required this.statsState});

  final AutodoApi api;
  final AuthState authState;
  final DataState dataState;
  final StatsState statsState;

  AppState copyWith(
      {AutodoApi api,
      AuthState authState,
      DataState dataState,
      StatsState statsState}) {
    return AppState(
        api: api ?? this.api,
        authState: authState ?? this.authState,
        dataState: dataState ?? this.dataState,
        statsState: statsState ?? this.statsState);
  }

  @override
  List<Object> get props => [authState, dataState, statsState];

  @override
  String toString() =>
      'AppState { authState: $authState, dataState: $dataState, statsState: $statsState }';
}
