import { configureStore } from '@reduxjs/toolkit';
import todosReducer from '../features/todos/todos_slice';

export default configureStore({
  reducer: {
    todos: todosReducer
  },
});
