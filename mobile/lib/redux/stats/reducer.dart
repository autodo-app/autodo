import 'package:redux/redux.dart';

import '../app/state.dart';
import 'actions.dart';
import 'status.dart';

final statsReducer = combineReducers<AppState>([
  TypedReducer<AppState, FetchStatsLoadingAction>(_fetchStatsPending),
  TypedReducer<AppState, FetchStatsSuccessAction>(_fetchStatsSuccess),
  TypedReducer<AppState, FetchStatsFailureAction>(_fetchStatsFailed),
]);

AppState _fetchStatsPending(AppState state, FetchStatsLoadingAction action) {
  return state.copyWith(
      statsState: state.statsState.copyWith(status: StatsStatus.LOADING));
}

AppState _fetchStatsSuccess(AppState state, FetchStatsSuccessAction action) {
  return state.copyWith(statsState: action.data);
}

AppState _fetchStatsFailed(AppState state, FetchStatsFailureAction action) {
  return state.copyWith(
      statsState: state.statsState
          .copyWith(status: StatsStatus.ERROR, error: action.error));
}
