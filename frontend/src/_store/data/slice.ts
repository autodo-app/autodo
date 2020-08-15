import { createSlice } from '@reduxjs/toolkit';

import { Todo, Refueling, Car } from '../../_models';
import * as actions from './actions';
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
      .addCase(actions.fetchData.pending, (state: DataState) => {
        state.status = 'loading';
      })
      .addCase(actions.fetchData.fulfilled, (state: DataState, { payload }) => {
        state.status = 'succeeded';
        state.todos = payload.payload.todos;
        state.refuelings = payload.payload.refuelings;
        state.cars = payload.payload.cars;
      })
      .addCase(actions.fetchData.rejected, (state: DataState, action) => {
        state.status = 'failed';
        state.error = action.error as string;
      })
      .addCase(
        actions.createTodo.fulfilled,
        (state: DataState, { payload }) => {
          state.todos.push(payload.payload);
        },
      )
      .addCase(
        actions.updateTodo.fulfilled,
        (state: DataState, { payload }) => {
          const todoId = payload.payload.id;
          const idx = state.todos.findIndex(
            (t) => Number(t.id) === Number(todoId),
          );
          state.todos[idx] = payload.payload as Todo;
        },
      )
      .addCase(
        actions.deleteTodo.fulfilled,
        (state: DataState, { payload }) => {
          const todoId = payload.payload.id;
          const idx = state.todos.findIndex(
            (t) => Number(t.id) === Number(todoId),
          );
          if (idx > -1) {
            state.todos.splice(idx, 1); // remove todo at position
          }
        },
      )
      .addCase(
        actions.completeTodo.fulfilled,
        (state: DataState, { payload }) => {
          const todoId = payload.payload.id;
          const idx = state.todos.findIndex(
            (t) => Number(t.id) === Number(todoId),
          );
          state.todos[idx] = payload.payload;
        },
      )
      .addCase(
        actions.undoCompleteTodo.fulfilled,
        (state: DataState, { payload }) => {
          state.todos = payload.payload;
        },
      )
      .addCase(
        actions.createRefueling.fulfilled,
        (state: DataState, { payload }) => {
          state.refuelings.push(payload.payload);
        },
      )
      .addCase(
        actions.updateRefueling.fulfilled,
        (state: DataState, { payload }) => {
          const refuelingId = payload.payload.id;
          const idx = state.refuelings.findIndex(
            (r) => Number(r.id) === Number(refuelingId),
          );
          state.refuelings[idx] = payload.payload as Refueling;
        },
      )
      .addCase(
        actions.deleteRefueling.fulfilled,
        (state: DataState, { payload }) => {
          const refuelingId = payload.payload.id;
          const idx = state.refuelings.findIndex(
            (r) => Number(r.id) === Number(refuelingId),
          );
          if (idx > -1) {
            state.refuelings.splice(idx, 1); // remove todo at position
          }
        },
      )
      .addCase(actions.createCar.fulfilled, (state: DataState, { payload }) => {
        state.cars.push(payload.payload);
      })
      .addCase(actions.updateCar.fulfilled, (state: DataState, { payload }) => {
        const carId = payload.payload.id;
        const idx = state.cars.findIndex((c) => Number(c.id) === Number(carId));
        state.cars[idx] = payload.payload as Car;
      })
      .addCase(actions.deleteCar.fulfilled, (state: DataState, { payload }) => {
        const carId = payload.payload.id;
        const idx = state.refuelings.findIndex(
          (c) => Number(c.id) === Number(carId),
        );
        if (idx > -1) {
          state.cars.splice(idx, 1); // remove todo at position
        }
      }),
});

export default dataSlice.reducer;

export const selectAllTodos = (state: RootState) => state.data.todos;

export const selectAllRefuelings = (state: RootState) => state.data.refuelings;

export const selectAllCars = (state: RootState) => state.data.cars;

export const selectTodoById = (state: RootState, todoId: Number) =>
  state.data.todos.find((todo) => Number(todo.id) === todoId);

export const selectRefuelingById = (state: RootState, refuelingId: Number) =>
  state.data.refuelings.find((r) => Number(r.id) === refuelingId);

export const selectCarById = (state: RootState, carId: Number) =>
  state.data.cars.find((c) => Number(c.id) === carId);
