import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repositories/repositories.dart';
import '../auth/state.dart';
import '../data/state.dart';
import '../filters/state.dart';
import '../stats/state.dart';

class AppState extends Equatable {
  const AppState(
      {@required this.api,
      @required this.authState,
      @required this.filterState,
      @required this.dataState,
      @required this.statsState});

  final AutodoApi api;
  final AuthState authState;
  final FilterState filterState;
  final DataState dataState;
  final StatsState statsState;

  AppState copyWith(
      {AutodoApi api,
      AuthState authState,
      FilterState filterState,
      DataState dataState,
      StatsState statsState}) {
    return AppState(
        api: api ?? this.api,
        authState: authState ?? this.authState,
        filterState: filterState ?? this.filterState,
        dataState: dataState ?? this.dataState,
        statsState: statsState ?? this.statsState);
  }

  @override
  List<Object> get props =>
      [api, authState, filterState, dataState, statsState];

  @override
  String toString() =>
      'AppState { api: $api, authState: $authState, filterState: $filterState, dataState: $dataState, statsState: $statsState }';
}
