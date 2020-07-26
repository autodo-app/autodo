import React, { useEffect } from 'react'
import { useSelector, useDispatch } from 'react-redux'
// import { Link } from 'react-router-dom';
import { selectAllTodos, fetchTodos } from './todos_slice';

export const TodosList = () => {
  const dispatch = useDispatch();
  const todos = useSelector(selectAllTodos);

  const todoStatus = useSelector(state => state.todos.status);
  const error = useSelector(state => state.todos.error);

  useEffect(() => {
    if (todoStatus === 'idle') {
      dispatch(fetchTodos());
    }
  }, [todoStatus, dispatch]);

  let content;
  if (todoStatus === 'loading') {
    content = <div className="loader">Loading...</div>
  } else if (todoStatus === 'succeeded') {
    content = <div>hello</div>
    // content = todos.map(t => (
    //   // <TodoExcerpt key={t.id} todo={t} />
    //   <div key={t.id}>{t}</div>
    // ));
  } else if (todoStatus === 'error') {
    content = <div>{error}</div>
  }

  return (
    <section>
      <h2>Todos</h2>
      {content}
    </section>
  )
}