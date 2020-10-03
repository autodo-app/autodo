import { Todo, Refueling, Car, OdomSnapshot } from '../../_models';
import * as types from './types';
import * as api from '../../_services';
import { createAsyncThunk } from '@reduxjs/toolkit';

import { RootState } from '../../store';
import { AUTODO_GREEN } from '../../../theme';

export const fetchData = createAsyncThunk<types.FetchDataAction, void>(
  types.FETCH_DATA,
  async () => {
    const [todos, refuelings, cars] = await Promise.all([
      api.fetchTodos(),
      api.fetchRefuelings(),
      api.fetchCars(),
    ]);
    return {
      type: types.FETCH_DATA,
      payload: {
        todos: todos,
        refuelings: refuelings,
        cars: cars,
        defaultTodos: [],
        status: '',
        error: '',
      },
    } as types.FetchDataAction;
  },
);

export const createTodo = createAsyncThunk<types.CreateTodoAction, Todo>(
  types.CREATE_TODO,
  async (initialTodo) => {
    const response = await api.postTodo(initialTodo);
    return {
      type: types.CREATE_TODO,
      payload: response,
    } as types.CreateTodoAction;
  },
);

export const updateTodo = createAsyncThunk<types.UpdateTodoAction, Todo>(
  types.UPDATE_TODO,
  async (initialTodo) => {
    const response = await api.patchTodo(initialTodo);
    return {
      type: types.UPDATE_TODO,
      payload: response,
    } as types.UpdateTodoAction;
  },
);

export const deleteTodo = createAsyncThunk<types.DeleteTodoAction, Todo>(
  types.DELETE_TODO,
  async (todo) => {
    const response = await api.deleteTodo(todo);
    return {
      type: types.DELETE_TODO,
      payload: response,
    } as types.DeleteTodoAction;
  },
);

export const completeTodo = createAsyncThunk<
  types.CompleteTodoAction,
  Todo,
  { state: RootState }
>(types.COMPLETE_TODO, async (initialTodo, thunkApi) => {
  const car = thunkApi
    .getState()
    .data.cars.find((c) => Number(c.id) === Number(initialTodo.car));
  if (!car) {
    return {
      type: types.COMPLETE_TODO,
    } as types.CompleteTodoAction;
  }
  const curMileage = car.odom ?? 0;
  const initialSnapshot = {
    car: initialTodo.car,
    date: new Date().toJSON(),
    mileage: curMileage,
  };
  const odomSnapshot = await api.postOdomSnapshot(initialSnapshot);
  const updatedTodo = {
    ...initialTodo,
    completionOdomSnapshot: odomSnapshot,
  };
  const response = await api.patchTodo(updatedTodo);
  return {
    type: types.COMPLETE_TODO,
    payload: response,
  } as types.CompleteTodoAction;
});

export const undoCompleteTodo = createAsyncThunk<
  types.UnCompleteTodoAction,
  Todo
>(types.UNCOMPLETE_TODO, async (initialTodo) => {
  if (!initialTodo.completionOdomSnapshot?.id) {
    // there is not a valid odomSnapshot on the todo to undo
    return {
      type: types.UNCOMPLETE_TODO,
    } as types.UnCompleteTodoAction;
  }
  await api.deleteOdomSnapshot(initialTodo.completionOdomSnapshot.id);
  const response = await api.fetchTodos();
  return {
    type: types.UNCOMPLETE_TODO,
    payload: response,
  } as types.UnCompleteTodoAction;
});

export const createRefueling = createAsyncThunk<
  types.CreateRefuelingAction,
  { refueling: Refueling; snap: OdomSnapshot }
>(types.CREATE_REFUELING, async ({ refueling, snap }) => {
  const odomSnapshot = await api.postOdomSnapshot(snap);
  refueling.odomSnapshot = odomSnapshot;
  const response = await api.postRefueling(refueling);
  return {
    type: types.CREATE_REFUELING,
    payload: response,
  } as types.CreateRefuelingAction;
});

export const updateRefueling = createAsyncThunk<
  types.UpdateRefuelingAction,
  { refueling: Refueling; snap: OdomSnapshot }
>(types.UPDATE_REFUELING, async ({ refueling, snap }) => {
  const response = await api.patchRefueling(refueling);
  return {
    type: types.UPDATE_REFUELING,
    payload: response,
  } as types.UpdateRefuelingAction;
});

export const deleteRefueling = createAsyncThunk<
  types.DeleteRefuelingAction,
  Refueling
>(types.DELETE_REFUELING, async (initialRefueling) => {
  const response = await api.deleteRefueling(initialRefueling);
  return {
    type: types.DELETE_REFUELING,
    payload: response,
  } as types.DeleteRefuelingAction;
});

export const createCar = createAsyncThunk<types.CreateCarAction, Car>(
  types.CREATE_CAR,
  async (car) => {
    const response = await api.postCar(car);
    if (!response.id) {
      // throw an exception?
    }
    const [todos, refuelings, cars] = await Promise.all([
      api.fetchTodos(),
      api.fetchRefuelings(),
      api.fetchCars(),
    ]);
    return {
      type: types.CREATE_CAR,
      payload: {
        todos: todos,
        refuelings: refuelings,
        cars: cars,
        defaultTodos: [],
        status: '',
        error: '',
      },
    } as types.CreateCarAction;
  },
);

export const updateCar = createAsyncThunk<types.UpdateCarAction, Car>(
  types.UPDATE_CAR,
  async (initialCar) => {
    const response = await api.patchCar(initialCar);
    return {
      type: types.UPDATE_CAR,
      payload: response,
    } as types.UpdateCarAction;
  },
);

export const deleteCar = createAsyncThunk<types.DeleteCarAction, Car>(
  types.DELETE_CAR,
  async (initialCar) => {
    const response = await api.deleteCar(initialCar);
    return {
      type: types.DELETE_CAR,
      payload: response,
    } as types.DeleteCarAction;
  },
);

export const createOdomSnapshot = createAsyncThunk<
  types.CreateOdomSnapshotAction,
  OdomSnapshot
>(types.CREATE_ODOM_SNAPSHOT, async (initialOdomSnapshot) => {
  const response = await api.postOdomSnapshot(initialOdomSnapshot);
  return {
    type: types.CREATE_ODOM_SNAPSHOT,
    payload: response,
  } as types.CreateOdomSnapshotAction;
});

export const updateOdomSnapshot = createAsyncThunk<
  types.UpdateOdomSnapshotAction,
  OdomSnapshot
>(types.UPDATE_ODOM_SNAPSHOT, async (initialOdomSnapshot) => {
  const response = await api.patchOdomSnapshot(initialOdomSnapshot);
  return {
    type: types.UPDATE_ODOM_SNAPSHOT,
    payload: response,
  } as types.UpdateOdomSnapshotAction;
});
