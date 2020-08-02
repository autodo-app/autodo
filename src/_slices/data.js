import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import {
  fetchTodos,
  fetchRefuelings,
  fetchCars,
  apiPostTodo,
  apiPatchTodo,
  apiDeleteTodo,
  apiPostOdomSnapshot,
  apiDeleteOdomSnapshot,
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
  const [todos, refuelings, cars] = await Promise.all([
    fetchTodos(),
    fetchRefuelings(),
    fetchCars(),
  ]);
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

export const completeTodo = createAsyncThunk(
  'data/completeTodo',
  async (initialTodo, thunkApi) => {
    const car = thunkApi
      .getState()
      .data.cars.find((c) => Number(c.id) === Number(initialTodo.car));
    const curMileage = car.odom;
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
    return response;
  },
);

export const undoCompleteTodo = createAsyncThunk(
  'data/undoCompleteTodo',
  async (initialTodo) => {
    await apiDeleteOdomSnapshot(initialTodo.completionOdomSnapshot);
    const response = await fetchTodos();
    return response;
  },
);

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
    [completeTodo.fulfilled]: (state, action) => {
      const todoId = action.payload.id;
      const idx = state.todos.findIndex((t) => Number(t.id) === Number(todoId));
      state.todos[idx] = action.payload;
    },
    [undoCompleteTodo.fulfilled]: (state, action) => {
      state.todos = action.payload;
    },
  },
});

export default dataSlice.reducer;
export const { todoAdded, todoUpdated } = dataSlice.actions;

export const selectAllTodos = (state) => state.data.todos;

export const selectAllCars = (state) => state.data.cars;

export const selectTodoById = (state, todoId) =>
  state.data.todos.find((todo) => Number(todo.id) === Number(todoId));
