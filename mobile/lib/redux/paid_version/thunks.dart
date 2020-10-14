import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

ThunkAction fetchPaidVersionStatus() {
  return (Store store) async {
    store.dispatch(PaidVersionLoadingAction());
    store.dispatch(SetPaidVersionAction(isPaid: true));
  };
}
