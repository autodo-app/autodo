import 'package:redux/redux.dart';

import '../auth/reducer.dart';
import '../data/reducer.dart';
import '../filters/reducer.dart';
import '../paid_version/reducer.dart';
import '../stats/reducer.dart';
import 'state.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, dynamic>(authReducer),
  TypedReducer<AppState, dynamic>(dataReducer),
  TypedReducer<AppState, dynamic>(filterReducer),
  TypedReducer<AppState, dynamic>(paidVersionReducer),
  TypedReducer<AppState, dynamic>(statsReducer),
]);
