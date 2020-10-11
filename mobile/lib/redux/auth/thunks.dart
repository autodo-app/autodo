import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

ThunkAction logInAsync(String username, String password, bool rememberMe) {
  return (Store store) async {
    store.dispatch(LoginPendingAction());
    try {
      final token = await store.state.api.fetchToken();
      store.dispatch(LoginSuccessAction(token: token));
    } catch (e) {
      store.dispatch(LoginFailedAction(error: e));
    }
  };
}

ThunkAction signUpAsync(String username, String password, bool rememberMe) {
  return (Store store) async {
    store.dispatch(SignupPendingAction());
    try {
      await store.state.api.registerUser(username, password);
      final token = await store.state.api.fetchToken();
      // set the access and refresh tokens
      store.dispatch(SignupSuccessAction(token: token));
    } catch (e) {
      store.dispatch(SignupFailedAction(error: e));
    }
  };
}

ThunkAction logOut() {
  return (Store store) async {
    try {
      await store.state.api.logOut();
      store.dispatch(LogOutSuccessAction());
    } catch (e) {
      print(e);
    }
  };
}

ThunkAction deleteAccount() {
  return (Store store) async {
    try {
      await store.state.api.deleteAccount();
      store.dispatch(LogOutSuccessAction());
    } catch (e) {
      print(e);
    }
  };
}

ThunkAction sendPasswordReset(String email) {
  return (Store store) async {
    try {
      await store.state.api.sendPasswordReset(email);
    } catch (e) {
      print(e);
    }
  };
}
