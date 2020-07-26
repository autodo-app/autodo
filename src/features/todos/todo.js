import React from 'react';
import { useSelector } from 'react-redux';
import { Link } from 'react-router-dom';

export const SingleTodoPage = ({ match }) => {
    const { todoId } = match.params;
    const todo = useSelector(state => 
        state.todos.find(todo => todo.id === todoId)
    );

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
}