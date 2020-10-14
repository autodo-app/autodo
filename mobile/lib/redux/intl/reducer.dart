import 'package:redux/redux.dart';

import '../app/state.dart';
import 'actions.dart';
import 'state.dart';

final intlReducer = combineReducers<AppState>([
  TypedReducer<AppState, SetIntlAction>(_setIntl),
]);

AppState _setIntl(AppState state, SetIntlAction action) =>
    state.copyWith(intlState: IntlState(intl: action.intl));
