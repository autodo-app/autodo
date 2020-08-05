import { createSlice } from '@reduxjs/toolkit';

import { Todo } from '../../_slices';
import {
  fetchData,
  createTodo,
  updateTodo,
  deleteTodo,
  completeTodo,
  undoCompleteTodo,
} from './actions';
import { DataState } from './state';
import { RootState } from '../../app/store';

const initialState: DataState = {
  todos: [],
  refuelings: [],
  cars: [],
  defaultTodos: [],
  status: 'idle',
  error: null,
};

const dataSlice = createSlice({
  name: 'data',
  initialState: initialState,
  reducers: {},
  extraReducers: (builder) =>
    builder
      .addCase(fetchData.pending, (state: DataState) => {
        state.status = 'loading';
      })
      .addCase(fetchData.fulfilled, (state: DataState, { payload }) => {
        state.status = 'succeeded';
        state.todos = payload.payload.todos;
        state.refuelings = payload.payload.refuelings;
        state.cars = payload.payload.cars;
      })
      .addCase(fetchData.rejected, (state: DataState, action) => {
        state.status = 'failed';
        state.error = action.error as string;
      })
      .addCase(createTodo.fulfilled, (state: DataState, { payload }) => {
        state.todos.push(payload.payload);
      })
      .addCase(updateTodo.fulfilled, (state: DataState, { payload }) => {
        const todoId = payload.payload.id;
        const idx = state.todos.findIndex(
          (t) => Number(t.id) === Number(todoId),
        );
        state.todos[idx] = payload.payload as Todo;
      })
      .addCase(deleteTodo.fulfilled, (state: DataState, { payload }) => {
        const todoId = payload.payload.id;
        const idx = state.todos.findIndex(
          (t) => Number(t.id) === Number(todoId),
        );
        if (idx > -1) {
          state.todos.splice(idx, 1); // remove todo at position
        }
      })
      .addCase(completeTodo.fulfilled, (state: DataState, { payload }) => {
        const todoId = payload.payload.id;
        const idx = state.todos.findIndex(
          (t) => Number(t.id) === Number(todoId),
        );
        state.todos[idx] = payload.payload;
      })
      .addCase(undoCompleteTodo.fulfilled, (state: DataState, { payload }) => {
        state.todos = payload.payload;
      }),
});

export default dataSlice.reducer;

export const selectAllTodos = (state: RootState) => state.data.todos;

export const selectAllCars = (state: RootState) => state.data.cars;

export const selectTodoById = (state: RootState, todoId: Number) =>
  state.data.todos.find((todo) => Number(todo.id) === todoId);
