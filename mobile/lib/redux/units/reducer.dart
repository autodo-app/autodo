import 'package:redux/redux.dart';

import '../../units/units.dart';
import '../app/state.dart';
import 'actions.dart';

final unitsReducer = combineReducers<AppState>([
  TypedReducer<AppState, SetUnitsFromLocaleAction>(_setUnitsFromLocale),
]);

AppState _setUnitsFromLocale(AppState state, SetUnitsFromLocaleAction action) =>
    state.copyWith(
        unitsState: state.unitsState.copyWith(
      distance: Distance.getDefault(action.locale),
      volume: Volume.getDefault(action.locale),
      efficiency: Efficiency.getDefault(action.locale),
      currency: Currency.getDefault(action.locale),
    ));
