import { Todo } from '../../_slices';
import {
  FETCH_DATA,
  CREATE_TODO,
  UPDATE_TODO,
  DELETE_TODO,
  COMPLETE_TODO,
  UNCOMPLETE_TODO,
  FetchDataAction,
  CompleteTodoAction,
  UnCompleteTodoAction,
  DeleteTodoAction,
  UpdateTodoAction,
  CreateTodoAction,
} from './types';
import {
  fetchTodos,
  fetchRefuelings,
  fetchCars,
  apiPostTodo,
  apiPatchTodo,
  apiDeleteTodo,
  apiPostOdomSnapshot,
  apiDeleteOdomSnapshot,
} from '../../_services';
import { createAsyncThunk } from '@reduxjs/toolkit';

import { RootState } from '../../app/store';

export const fetchData = createAsyncThunk<FetchDataAction, void>(
  FETCH_DATA,
  async () => {
    const [todos, refuelings, cars] = await Promise.all([
      fetchTodos(),
      fetchRefuelings(),
      fetchCars(),
    ]);
    return {
      type: FETCH_DATA,
      payload: {
        todos: todos,
        refuelings: refuelings,
        cars: cars,
        defaultTodos: [],
        status: '',
        error: '',
      },
    } as FetchDataAction;
  },
);

export const createTodo = createAsyncThunk<CreateTodoAction, Todo>(
  CREATE_TODO,
  async (initialTodo) => {
    const response = await apiPostTodo(initialTodo);
    return {
      type: CREATE_TODO,
      payload: response,
    } as CreateTodoAction;
  },
);

export const updateTodo = createAsyncThunk<UpdateTodoAction, Todo>(
  UPDATE_TODO,
  async (initialTodo) => {
    const response = await apiPatchTodo(initialTodo);
    return {
      type: UPDATE_TODO,
      payload: response,
    } as UpdateTodoAction;
  },
);

export const deleteTodo = createAsyncThunk<DeleteTodoAction, Todo>(
  DELETE_TODO,
  async (todo) => {
    const response = await apiDeleteTodo(todo);
    return {
      type: DELETE_TODO,
      payload: response,
    } as DeleteTodoAction;
  },
);

export const completeTodo = createAsyncThunk<
  CompleteTodoAction,
  Todo,
  { state: RootState }
>(COMPLETE_TODO, async (initialTodo, thunkApi) => {
  const car = thunkApi
    .getState()
    .data.cars.find((c) => Number(c.id) === Number(initialTodo.car));
  const curMileage = car?.odom;
  const initialSnapshot = {
    car: initialTodo.car,
    date: new Date(),
    mileage: curMileage,
  };
  const odomSnapshot = await apiPostOdomSnapshot(initialSnapshot);
  const updatedTodo = {
    ...initialTodo,
    completionOdomSnapshot: odomSnapshot.id,
  };
  const response = await apiPatchTodo(updatedTodo);
  return {
    type: COMPLETE_TODO,
    payload: response,
  } as CompleteTodoAction;
});

export const undoCompleteTodo = createAsyncThunk<UnCompleteTodoAction, Todo>(
  UNCOMPLETE_TODO,
  async (initialTodo) => {
    await apiDeleteOdomSnapshot(initialTodo.completionOdomSnapshot);
    const response = await fetchTodos();
    return {
      type: UNCOMPLETE_TODO,
      payload: response,
    } as UnCompleteTodoAction;
  },
);
