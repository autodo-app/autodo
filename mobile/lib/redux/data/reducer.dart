import 'package:redux/redux.dart';

import '../app/state.dart';
import 'actions.dart';
import 'status.dart';

final dataReducer = combineReducers<AppState>([
  TypedReducer<AppState, LoadingDataAction>(_dataLoading),
  TypedReducer<AppState, DataFailedAction>(_dataFailed),
  TypedReducer<AppState, FetchDataSuccessAction>(_fetchDataSuccess),
  TypedReducer<AppState, CreateTodoAction>(_createTodo),
  TypedReducer<AppState, UpdateTodoAction>(_updateTodo),
  TypedReducer<AppState, DeleteTodoAction>(_deleteTodo),
  TypedReducer<AppState, CreateRefuelingAction>(_createRefueling),
  TypedReducer<AppState, UpdateRefuelingAction>(_updateRefueling),
  TypedReducer<AppState, DeleteRefuelingAction>(_deleteRefueling),
  TypedReducer<AppState, CreateCarAction>(_createCar),
  TypedReducer<AppState, UpdateCarAction>(_updateCar),
  TypedReducer<AppState, DeleteCarAction>(_deleteCar),
]);

AppState _dataLoading(AppState state, LoadingDataAction action) {
  print('loading');
  return state.copyWith(
      dataState: state.dataState.copyWith(status: DataStatus.LOADING));
}

AppState _dataFailed(AppState state, DataFailedAction action) {
  return state.copyWith(
      dataState: state.dataState
          .copyWith(status: DataStatus.FAILED, error: action.error));
}

AppState _fetchDataSuccess(AppState state, FetchDataSuccessAction action) {
  return state.copyWith(dataState: action.data);
}

AppState _createTodo(AppState state, CreateTodoAction action) {
  final curDataState = state.dataState;
  final newTodos = List.from(curDataState.todos);
  newTodos.add(action.todo);
  return state.copyWith(dataState: curDataState.copyWith(todos: newTodos));
}

AppState _updateTodo(AppState state, UpdateTodoAction action) {
  final curDataState = state.dataState;
  final updatedTodos = List.from(curDataState.todos)
      .map((t) => (t.id == action.todo.id) ? action.todo : t);
  return state.copyWith(dataState: curDataState.copyWith(todos: updatedTodos));
}

AppState _deleteTodo(AppState state, DeleteTodoAction action) {
  final curDataState = state.dataState;
  final updatedTodos = List.from(curDataState.todos);
  updatedTodos.remove(action.todo);
  return state.copyWith(dataState: curDataState.copyWith(todos: updatedTodos));
}

AppState _createRefueling(AppState state, CreateRefuelingAction action) {
  final curDataState = state.dataState;
  final newRefuelings = List.from(curDataState.refuelings);
  newRefuelings.add(action.refueling);
  return state.copyWith(
      dataState: curDataState.copyWith(refuelings: newRefuelings));
}

AppState _updateRefueling(AppState state, UpdateRefuelingAction action) {
  final curDataState = state.dataState;
  final updatedRefuelings = List.from(curDataState.refuelings)
      .map((r) => (r.id == action.refueling.id) ? action.refueling : r);
  return state.copyWith(
      dataState: curDataState.copyWith(refuelings: updatedRefuelings));
}

AppState _deleteRefueling(AppState state, DeleteRefuelingAction action) {
  final curDataState = state.dataState;
  final updatedRefuelings = List.from(curDataState.refuelings);
  updatedRefuelings.remove(action.refueling);
  return state.copyWith(
      dataState: curDataState.copyWith(refuelings: updatedRefuelings));
}

AppState _createCar(AppState state, CreateCarAction action) {
  final curDataState = state.dataState;
  final newCars = List.from(curDataState.cars);
  newCars.add(action.car);
  return state.copyWith(dataState: curDataState.copyWith(cars: newCars));
}

AppState _updateCar(AppState state, UpdateCarAction action) {
  final curDataState = state.dataState;
  final updatedCars = List.from(curDataState.cars)
      .map((c) => (c.id == action.car.id) ? action.car : c);
  return state.copyWith(dataState: curDataState.copyWith(cars: updatedCars));
}

AppState _deleteCar(AppState state, DeleteCarAction action) {
  final curDataState = state.dataState;
  final updatedCars = List.from(curDataState.cars);
  updatedCars.remove(action.car);
  return state.copyWith(dataState: curDataState.copyWith(cars: updatedCars));
}
