import { Todo } from '../../_slices';
import {
  FETCH_DATA,
  CREATE_TODO,
  UPDATE_TODO,
  DELETE_TODO,
  COMPLETE_TODO,
  DataActionTypes,
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

export const fetchData = createAsyncThunk(
  FETCH_DATA,
  async (): Promise<DataActionTypes> => {
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
    };
  },
);

export const createTodo = createAsyncThunk(
  CREATE_TODO,
  async (initialTodo: Todo): Promise<DataActionTypes> => {
    const response = await apiPostTodo(initialTodo);
    return {
      type: CREATE_TODO,
      payload: response,
    };
  },
);

export const updateTodo = createAsyncThunk(
  UPDATE_TODO,
  async (initialTodo: Todo): Promise<DataActionTypes> => {
    const response = await apiPatchTodo(initialTodo);
    return {
      type: UPDATE_TODO,
      payload: response,
    };
  },
);

export const deleteTodo = createAsyncThunk(
  DELETE_TODO,
  async (todo: Todo): Promise<DataActionTypes> => {
    const response = await apiDeleteTodo(todo);
    return {
      type: UPDATE_TODO,
      payload: response,
    };
  },
);
