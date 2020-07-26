import { createSlice, createAsyncThunk } from '@reduxjs/toolkit'

const initialState = {
  todos: [],
  status: 'idle',
  error: null,
}

export const fetchTodos = createAsyncThunk('todos/fetchTodos', async () => {
  // TODO: return data from axios
})

export const addNewTodo = createAsyncThunk(
  'todos/addNewTodo', 
  async initialTodo => {
    // const response = await client.post('fakeApi/todos', { todo: initialTodo });
    // return response.todo;
  }
);

const todosSlice = createSlice({
  name: 'todos',
  initialState,
  reducers: {
      todoAdded(state, action) {
          state.todos.push(action.payload);
      },
      todoUpdated(state, action) {
        const { id, name, content } = action.payload
        const existingTodo = state.todos.find(todo => todo.id === id)
        if (existingTodo) {
          existingTodo.name = name
          existingTodo.content = content
        }
      }
  },
  extraReducers: {
    [fetchTodos.pending]: (state, action) => {
      state.status = 'loading';
    },
    [fetchTodos.fulfilled]: (state, action) => {
      state.status = 'succeeded';
      state.todos = state.todos.concat(action.payload);
    },
    [fetchTodos.rejected]: (state, action) => {
      state.status = 'failed';
      state.error = action.payload;
    },
    [addNewTodo.fulfilled]: (state, action) => {
      state.todos.push(action.payload);
    }
  }
})

export default todosSlice.reducer;
export const { todoAdded, todoUpdated } = todosSlice.actions;

export const selectAllTodos = state => state.todos

export const selectTodoById = (state, todoId) =>
  state.todos.todos.find(todo => todo.id === todoId)