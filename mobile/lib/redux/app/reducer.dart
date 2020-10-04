import 'package:redux/redux.dart';

import '../auth/reducer.dart';
import '../data/reducer.dart';
import '../stats/reducer.dart';
import 'state.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, dynamic>(authReducer),
  TypedReducer<AppState, dynamic>(dataReducer),
  TypedReducer<AppState, dynamic>(statsReducer),
]);
