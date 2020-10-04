import './state.dart';

AppState appReducer(AppState state, dynamic action) {
  return state;
  // if (action is UserLogout) {
  //   return AppState(prefState: state.prefState).rebuild((b) => b
  //     ..authState.replace(state.authState.rebuild((b) => b
  //       ..isAuthenticated = false
  //       ..lastEnteredPasswordAt = 0))
  //     ..isTesting = state.isTesting);
  // } else if (action is LoadStateSuccess) {
  //   return action.state.rebuild((b) => b
  //     ..isLoading = false
  //     ..isSaving = false);
  // } else if (action is ClearData) {
  //   return state.rebuild((b) => b
  //     ..userCompanyStates.replace(BuiltList<UserCompanyState>(
  //         List<int>.generate(kMaxNumberOfCompanies, (i) => i + 1)
  //             .map((index) => UserCompanyState())
  //             .toList())));
  // }

  // return state.rebuild((b) => b
  //   ..isLoading = loadingReducer(state.isLoading, action)
  //   ..isSaving = savingReducer(state.isSaving, action)
  //   ..lastError = lastErrorReducer(state.lastError, action)
  //   ..authState.replace(authReducer(state.authState, action))
  //   ..staticState.replace(staticReducer(state.staticState, action))
  //   ..userCompanyStates[state.uiState.selectedCompanyIndex] = companyReducer(
  //       state.userCompanyStates[state.uiState.selectedCompanyIndex], action)
  //   ..uiState.replace(uiReducer(state.uiState, action))
  //   ..prefState
  //       .replace(prefReducer(state.prefState, action, state.company.id)));
}
