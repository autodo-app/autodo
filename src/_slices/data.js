import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import {
  fetchTodos,
  fetchRefuelings,
  fetchCars,
  apiPostTodo,
  apiPatchTodo,
  apiDeleteTodo,
} from '../_services';

const initialState = {
  todos: [],
  refuelings: [],
  cars: [],
  defaultTodos: [],
  status: 'idle',
  error: null,
};

export const fetchData = createAsyncThunk('data/fetchData', async () => {
  const todos = await fetchTodos();
  const refuelings = await fetchRefuelings();
  const cars = await fetchCars();
  return {
    todos: todos,
    refuelings: refuelings,
    cars: cars,
  };
});

export const addNewTodo = createAsyncThunk(
  'data/addNewTodo',
  async (initialTodo) => {
    const response = await apiPostTodo(initialTodo);
    return response;
  },
);

export const updateTodo = createAsyncThunk(
  'data/updateTodo',
  async (initialTodo) => {
    const response = await apiPatchTodo(initialTodo);
    return response;
  },
);

export const deleteTodo = createAsyncThunk('data/deleteTodo', async (todo) => {
  const response = await apiDeleteTodo(todo);
  return response;
});

const dataSlice = createSlice({
  name: 'data',
  initialState,
  reducers: {},
  extraReducers: {
    [fetchData.pending]: (state) => {
      state.status = 'loading';
    },
    [fetchData.fulfilled]: (state, action) => {
      state.status = 'succeeded';
      state.todos = action.payload.todos;
      state.refuelings = action.payload.refuelings;
      state.cars = action.payload.cars;
    },
    [fetchData.rejected]: (state, action) => {
      state.status = 'failed';
      state.error = action.payload;
    },
    [addNewTodo.fulfilled]: (state, action) => {
      state.todos.push(action.payload);
    },
    [updateTodo.fulfilled]: (state, action) => {
      const todoId = action.payload.id;
      const idx = state.todos.findIndex((t) => Number(t.id) === Number(todoId));
      state.todos[idx] = action.payload;
    },
    [deleteTodo.fulfilled]: (state, action) => {
      const todoId = action.payload.id;
      const idx = state.todos.findIndex((t) => Number(t.id) === Number(todoId));
      if (idx > -1) {
        state.todos.splice(idx, 1); // remove todo at position
      }
    },
  },
});

export default dataSlice.reducer;
export const { todoAdded, todoUpdated } = dataSlice.actions;

export const selectAllTodos = (state) => state.data.todos;

export const selectTodoById = (state, todoId) =>
  state.data.todos.find((todo) => Number(todo.id) === Number(todoId));
