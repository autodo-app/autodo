import { createSlice } from '@reduxjs/toolkit';
import {
  fetchData,
  createTodo,
  updateTodo,
  deleteTodo,
  completeTodo,
  undoCompleteTodo,
} from './actions';

const initialState = {
  todos: [],
  refuelings: [],
  cars: [],
  defaultTodos: [],
  status: 'idle',
  error: null,
};

const dataSlice = createSlice({
  name: 'data',
  initialState,
  reducers: {},
  extraReducers: (builder) =>
    builder
      .addCase(fetchData.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(fetchData.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.todos = action.payload.todos;
        state.refuelings = action.payload.refuelings;
        state.cars = action.payload.cars;
      })
      .addCase(fetchData.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.payload;
      })
      .addCase(createTodo.fulfilled, (state, action) => {
        state.todos.push(action.payload);
      })
      .addCase(updateTodo.fulfilled, (state, action) => {
        const todoId = action.payload.id;
        const idx = state.todos.findIndex(
          (t) => Number(t.id) === Number(todoId),
        );
        state.todos[idx] = action.payload;
      })
      .addCase(deleteTodo.fulfilled, (state, action) => {
        const todoId = action.payload.id;
        const idx = state.todos.findIndex(
          (t) => Number(t.id) === Number(todoId),
        );
        if (idx > -1) {
          state.todos.splice(idx, 1); // remove todo at position
        }
      })
      .addCase(completeTodo.fulfilled, (state, action) => {
        const todoId = action.payload.id;
        const idx = state.todos.findIndex(
          (t) => Number(t.id) === Number(todoId),
        );
        state.todos[idx] = action.payload;
      })
      .addCase(undoCompleteTodo.fulfilled, (state, action) => {
        state.todos = action.payload;
      }),
});

export default dataSlice.reducer;

export const selectAllTodos = (state) => state.data.todos;

export const selectAllCars = (state) => state.data.cars;

export const selectTodoById = (state, todoId) =>
  state.data.todos.find((todo) => Number(todo.id) === Number(todoId));
