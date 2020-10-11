import 'package:meta/meta.dart';

import 'state.dart';

class FetchStatsSuccessAction {
  const FetchStatsSuccessAction({@required this.data});

  final StatsState data;
}

class FetchStatsLoadingAction {}

class FetchStatsFailureAction {
  const FetchStatsFailureAction({@required this.error});

  final String error;
}
