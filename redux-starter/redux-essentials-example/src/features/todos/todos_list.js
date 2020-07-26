import React from 'react'
import { useSelector } from 'react-redux'
import { Link } from 'react-router-dom';

export const TodosList = () => {
  const todos = useSelector(state => state.todos);

  const renderedTodos = todos.map(todo => (
    <article className="post-excerpt" key={todo.name}>
      <h3>{todo.name}</h3>
      <p>{todo.content.substring(0, 100)}</p>
      <Link to={`/todos/${todo.id}`} className="button muted-button">
          View Todo
      </Link>
    </article>
  ))

  return (
    <section>
      <h2>Todos</h2>
      {renderedTodos}
    </section>
  )
}