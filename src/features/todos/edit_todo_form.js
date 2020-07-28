import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import { fetchData, todoUpdated, selectTodoById } from '../../_slices';

export const EditTodoForm = ({ match }) => {
  const { todoId } = match.params;

  let todo = useSelector((state) => {
    console.log(state);
    return selectTodoById(state, todoId);
  });
  if (!todo) {
    todo = {};
  }

  console.log(todo);

  const [name, setName] = useState(todo.name);
  // const [content, setContent] = useState(todo.content);

  const onNameChanged = (e) => setName(e.target.value);
  // const onContentChanged = (e) => setContent(e.target.value);

  // const onSaveTodoClicked = () => {
  //   if (name && content) {
  //     dispatch(todoUpdated({ id: todoId, name, content }));
  //     history.push(`/todos/${todoId}`);
  //   }
  // };

  return (
    <section>
      <h2>Edit Post</h2>
      <form>
        <label htmlFor="todoName">Todo Name:</label>
        <input
          type="text"
          id="todoName"
          name="todoName"
          placeholder="What's on your mind?"
          value={name}
          onChange={onNameChanged}
        />
        {/* <label htmlFor="todoContent">Content:</label>
        <textarea
          id="todoContent"
          name="todoContent"
          value={content}
          onChange={onContentChanged}
        /> */}
      </form>
      {/* <button type="button" onClick={onSaveTodoClicked}>
        Save Todo
      </button> */}
    </section>
  );
};
