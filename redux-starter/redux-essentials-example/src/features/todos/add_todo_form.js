import React, { useState } from 'react'
import { useDispatch } from 'react-redux'
import { unwrapResult } from '@reduxjs/toolkit'

import { addNewTodo } from './todos_slice'

export const AddTodoForm = () => {
  const [name, setName] = useState('');
  const [content, setContent] = useState('');
  const [addRequestStatus, setAddRequestStatus] = useState('idle');

  const dispatch = useDispatch();

  const onNameChanged = e => setName(e.target.value);
  const onContentChanged = e => setContent(e.target.value);

  const canSave =
    [name, content].every(Boolean) && addRequestStatus === 'idle'

  const onSaveTodoClicked = async () => {
    if (canSave) {
      try {
        setAddRequestStatus('pending')
        const resultAction = await dispatch(
          addNewTodo({ name, content })
        )
        unwrapResult(resultAction)
        setName('')
        setContent('')
        // setUserId('')
      } catch (err) {
        console.error('Failed to save the post: ', err)
      } finally {
        setAddRequestStatus('idle')
      }
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