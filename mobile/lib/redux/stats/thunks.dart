import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

import 'actions.dart';
import 'state.dart';
import 'status.dart';

ThunkAction fetchStats() {
  return (Store store) async {
    store.dispatch(FetchStatsLoadingAction());
    try {
      final data = await Future.wait(<Future>[
        store.state.api.fetchFuelEfficiency(),
        store.state.api.fetchFuelUsageByCar(),
        store.state.api.fetchDrivingRate(),
        store.state.api.fetchFuelUsageByMonth()
      ]);
      store.dispatch(FetchStatsSuccessAction(
          data: StatsState(
              fuelEfficiency: data[0],
              fuelUsageByCar: data[1],
              drivingRate: data[2],
              fuelUsageByMonth: data[3],
              status: StatsStatus.LOADED,
              error: null)));
    } catch (e) {
      store.dispatch(FetchStatsFailureAction(error: e));
    }
  };
}
