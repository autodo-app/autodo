import 'package:redux/redux.dart';

import '../app/state.dart';
import 'actions.dart';
import 'state.dart';
import 'status.dart';

final paidVersionReducer = combineReducers<AppState>([
  TypedReducer<AppState, PaidVersionLoadingAction>(_setLoading),
  TypedReducer<AppState, SetPaidVersionAction>(_loadPaidVersion),
]);

AppState _setLoading(AppState state, PaidVersionLoadingAction action) {
  return state.copyWith(
      paidVersionState:
          state.paidVersionState.copyWith(status: PaidVersionStatus.LOADING));
}

AppState _loadPaidVersion(AppState state, SetPaidVersionAction action) {
  return state.copyWith(
      paidVersionState: PaidVersionState(
          isPaid: action.isPaid, status: PaidVersionStatus.LOADED));
}
