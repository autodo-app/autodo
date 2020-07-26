import React, { useState } from 'react'
import { useDispatch } from 'react-redux'
import { nanoid } from '@reduxjs/toolkit'

import { todoAdded } from './todos_slice'

export const AddTodoForm = () => {
  const [name, setName] = useState('');
  const [content, setContent] = useState('');

  const dispatch = useDispatch();

  const onNameChanged = e => setName(e.target.value);
  const onContentChanged = e => setContent(e.target.value);

  const onSaveTodoClicked = () => {
    if (name && content) {
        dispatch(  
            todoAdded({
                id: nanoid(),
                name,
                content
            })
        )

        setName('')
        setContent('')
    }
  }

  return (
    <section>
      <h2>Add a New Post</h2>
      <form>
        <label htmlFor="todoName">Todo Name:</label>
        <input
          type="text"
          id="todoName"
          name="todoName"
          value={name}
          onChange={onNameChanged}
        />
        <label htmlFor="postContent">Content:</label>
        <textarea
          id="postContent"
          name="postContent"
          value={content}
          onChange={onContentChanged}
        />
        <button type="button" onClick={onSaveTodoClicked}>
            Save Todo
        </button>
      </form>
    </section>
  )
}