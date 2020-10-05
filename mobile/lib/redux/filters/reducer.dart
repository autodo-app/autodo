import 'package:redux/redux.dart';

import '../app/state.dart';
import 'actions.dart';

final filterReducer = combineReducers<AppState>([
  TypedReducer<AppState, SetRefuelingsFilterAction>(_setRefuelingsFilter),
  TypedReducer<AppState, SetTodosFilterAction>(_setTodosFilter),
]);

AppState _setRefuelingsFilter(
        AppState state, SetRefuelingsFilterAction action) =>
    state.copyWith(
        filterState:
            state.filterState.copyWith(refuelingsFilter: action.filter));

AppState _setTodosFilter(AppState state, SetTodosFilterAction action) =>
    state.copyWith(
        filterState:
            state.filterState.copyWith(refuelingsFilter: action.filter));
