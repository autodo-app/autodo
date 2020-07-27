import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
// import { Link } from 'react-router-dom';
import { selectAllTodos, fetchData } from '../../_slices';

export const TodosList = () => {
  const dispatch = useDispatch();
  const todos = useSelector(selectAllTodos);

  const todoStatus = useSelector((state) => state.data.status);
  const error = useSelector((state) => state.data.error);

  useEffect(() => {
    if (todoStatus === 'idle') {
      dispatch(fetchData());
    }
  }, [todoStatus, dispatch]);

  let content;
  if (todoStatus === 'loading') {
    content = <div className="loader">Loading...</div>;
  } else if (todoStatus === 'succeeded') {
    content = todos.map((t) => (
      // <TodoExcerpt key={t.id} todo={t} />
      <div key={t.id}>
        {t.name}/{t.car}
      </div>
    ));
  } else if (todoStatus === 'error') {
    content = <div>{error}</div>;
  }

  return (
    <section>
      <h2>Todos</h2>
      {content}
    </section>
  );
};
