import 'package:redux/redux.dart';

import '../app/state.dart';
import 'actions.dart';

final authReducer = combineReducers<AppState>([
  TypedReducer<AppState, LoginSuccessAction>(_loginSuccess),
]);

AppState _loginPending(AppState state, LoginPendingAction action) {
  return state.copyWith(authState: state.authState.copyWith(status: 'loading'));
}

AppState _loginSuccess(AppState state, LoginSuccessAction action) {
  return state.copyWith(
      authState:
          state.authState.copyWith(token: action.token, status: 'loggedIn'));
}

AppState _loginFailure(AppState state, LoginFailedAction action) {
  return state.copyWith(
      authState:
          state.authState.copyWith(status: 'failed', error: action.error));
}
