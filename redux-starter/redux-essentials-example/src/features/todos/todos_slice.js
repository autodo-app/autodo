import { createSlice } from '@reduxjs/toolkit'

const initialState = [
  { id: '1', name: 'Change Oil', content: 'Hello!' },
  { id: '2', name: 'Rotate Tires', content: 'More text' }
]

const todosSlice = createSlice({
  name: 'todos',
  initialState,
  reducers: {
      todoAdded(state, action) {
          state.push(action.payload);
      },
      todoUpdated(state, action) {
        const { id, name, content } = action.payload
        const existingTodo = state.find(todo => todo.id === id)
        if (existingTodo) {
          existingTodo.name = name
          existingTodo.content = content
        }
      }
  }
})

export default todosSlice.reducer;
export const { todoAdded, todoUpdated } = todosSlice.actions;