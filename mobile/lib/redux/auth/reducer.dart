import 'package:redux/redux.dart';

import '../app/state.dart';
import 'actions.dart';
import 'status.dart';

final authReducer = combineReducers<AppState>([
  TypedReducer<AppState, LoginSuccessAction>(_loginSuccess),
  TypedReducer<AppState, LoginPendingAction>(_loginPending),
  TypedReducer<AppState, LoginFailedAction>(_loginFailure),
  TypedReducer<AppState, SignupSuccessAction>(_signupSuccess),
  TypedReducer<AppState, SignupPendingAction>(_signupPending),
  TypedReducer<AppState, SignupFailedAction>(_signupFailure),
  TypedReducer<AppState, LogOutSuccessAction>(_logOutSuccess),
]);

AppState _loginPending(AppState state, LoginPendingAction action) {
  return state.copyWith(
      authState: state.authState.copyWith(status: AuthStatus.LOADING));
}

AppState _loginSuccess(AppState state, LoginSuccessAction action) {
  return state.copyWith(
      authState: state.authState
          .copyWith(token: action.token, status: AuthStatus.LOGGED_IN));
}

AppState _loginFailure(AppState state, LoginFailedAction action) {
  return state.copyWith(
      authState: state.authState
          .copyWith(status: AuthStatus.FAILED, error: action.error));
}

AppState _signupPending(AppState state, SignupPendingAction action) {
  return state.copyWith(
      authState: state.authState.copyWith(status: AuthStatus.LOADING));
}

AppState _signupSuccess(AppState state, SignupSuccessAction action) {
  return state.copyWith(
      authState: state.authState
          .copyWith(token: action.token, status: AuthStatus.LOGGED_IN));
}

AppState _signupFailure(AppState state, SignupFailedAction action) {
  return state.copyWith(
      authState: state.authState
          .copyWith(status: AuthStatus.FAILED, error: action.error));
}

AppState _logOutSuccess(AppState state, LogOutSuccessAction action) {
  return state.copyWith(
      authState: state.authState.copyWith(status: AuthStatus.LOGGED_OUT));
}
