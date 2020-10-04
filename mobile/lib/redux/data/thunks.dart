import 'dart:async';

import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

import '../../models/models.dart';
import 'actions.dart';
import 'state.dart';

/// Retrieves all of the user's core data from the API.
ThunkAction fetchData() {
  return (Store store) async {
    store.dispatch(LoadingDataAction());
    try {
      final data = await Future.wait(<Future>[
        store.state.api.fetchTodos(),
        store.state.api.fetchRefuelings(),
        store.state.api.fetchCars()
      ]);
      store.dispatch(FetchDataSuccessAction(
          data: DataState(
              todos: data[0],
              refuelings: data[1],
              cars: data[2],
              status: DataStatus.LOADED,
              error: null)));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

/// Creates a new Todo object on the server.
ThunkAction createTodo(Todo todo) {
  return (Store store) async {
    try {
      final res = await store.state.api.createTodo(todo);
      store.dispatch(CreateTodoAction(todo: Todo.fromMap(res.id, res)));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

/// Updates the Todo object on the server.
ThunkAction updateTodo(Todo todo) {
  return (Store store) async {
    try {
      final res = await store.state.api.updateTodo(todo);
      store.dispatch(UpdateTodoAction(todo: Todo.fromMap(res.id, res)));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

/// Removes a Todo object from the server.
ThunkAction deleteTodo(Todo todo) {
  return (Store store) async {
    try {
      await store.state.api.deleteTodo(todo);
      store.dispatch(DeleteTodoAction(todo: todo));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

// TODO: deal with complete/uncomplete later. can probably handle a bit of that
// with nested serializers

ThunkAction completeTodo(Todo todo) {
  return (Store store) async {};
}

ThunkAction unCompleteTodo(Todo todo) {
  return (Store store) async {};
}

/// Creates a new Refueling object on the server.
ThunkAction createRefueling(Refueling refueling) {
  return (Store store) async {
    try {
      final res = await store.state.api.createRefueling(refueling);
      store.dispatch(
          CreateRefuelingAction(refueling: Refueling.fromMap(res.id, res)));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

/// Updates the Refueling object on the server.
ThunkAction updateRefueling(Refueling refueling) {
  return (Store store) async {
    try {
      final res = await store.state.api.updateRefueling(refueling);
      store.dispatch(
          UpdateRefuelingAction(refueling: Refueling.fromMap(res.id, res)));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

/// Removes a Refueling object from the server.
ThunkAction deleteRefueling(Refueling refueling) {
  return (Store store) async {
    try {
      await store.state.api.deleteRefueling(refueling);
      store.dispatch(DeleteRefuelingAction(refueling: refueling));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

/// Creates a new Car object on the server.
ThunkAction createCar(Car car) {
  return (Store store) async {
    try {
      final res = await store.state.api.createCar(car);
      store.dispatch(CreateCarAction(car: Car.fromMap(res.id, res)));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

/// Updates the Car object on the server.
ThunkAction updateCar(Car car) {
  return (Store store) async {
    try {
      final res = await store.state.api.updateCar(car);
      store.dispatch(UpdateCarAction(car: Car.fromMap(res.id, res)));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}

/// Removes a Car object from the server.
ThunkAction deleteCar(Car car) {
  return (Store store) async {
    try {
      await store.state.api.deleteCar(car);
      store.dispatch(DeleteCarAction(car: car));
    } catch (e) {
      store.dispatch(DataFailedAction(error: e));
    }
  };
}