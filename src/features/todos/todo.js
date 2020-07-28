import React from 'react';
import { useSelector } from 'react-redux';
import { Link } from 'react-router-dom';
import { selectTodoById } from '../../_slices';

export const SingleTodoPage = ({ todoId }) => {
  const todo = useSelector((state) => selectTodoById(state, todoId));

  if (!todo) {
    return (
      <section>
        <h2>Todo not found!</h2>
      </section>
    );
  }
  return (
    <section>
      <article className="todo">
        <h2>{todo.name}</h2>
        <Link to={`/editTodo/${todo.id}`} className="button">
          Edit Todo
        </Link>
      </article>
    </section>
  );
};
