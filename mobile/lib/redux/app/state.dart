import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repositories/repositories.dart';
import '../auth/state.dart';
import '../data/state.dart';
import '../filters/state.dart';
import '../intl/state.dart';
import '../paid_version/state.dart';
import '../stats/state.dart';
import '../units/state.dart';

class AppState extends Equatable {
  const AppState(
      {@required this.api,
      @required this.authState,
      @required this.filterState,
      @required this.dataState,
      @required this.intlState,
      @required this.statsState,
      @required this.paidVersionState,
      @required this.unitsState});

  final AutodoApi api;
  final AuthState authState;
  final FilterState filterState;
  final IntlState intlState;
  final DataState dataState;
  final StatsState statsState;
  final PaidVersionState paidVersionState;
  final UnitsState unitsState;

  AppState copyWith(
      {AutodoApi api,
      AuthState authState,
      FilterState filterState,
      DataState dataState,
      IntlState intlState,
      StatsState statsState,
      PaidVersionState paidVersionState,
      UnitsState unitsState}) {
    return AppState(
      api: api ?? this.api,
      authState: authState ?? this.authState,
      filterState: filterState ?? this.filterState,
      dataState: dataState ?? this.dataState,
      intlState: intlState ?? this.intlState,
      statsState: statsState ?? this.statsState,
      paidVersionState: paidVersionState ?? this.paidVersionState,
      unitsState: unitsState ?? this.unitsState,
    );
  }

  @override
  List<Object> get props => [
        api,
        authState,
        filterState,
        dataState,
        intlState,
        statsState,
        paidVersionState,
        unitsState
      ];

  @override
  String toString() =>
      'AppState { api: $api, authState: $authState, filterState: $filterState, dataState: $dataState, intlState: $intlState, statsState: $statsState, paidVersionState: $paidVersionState }';
}
