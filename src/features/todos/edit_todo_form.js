import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import { updateTodo, selectTodoById } from '../../_slices';
import { useHistory } from 'react-router-dom';

export const EditTodoForm = ({ match }) => {
  const { todoId } = match.params;
  const dispatch = useDispatch();
  const history = useHistory();

  let todo = useSelector((state) => selectTodoById(state, todoId));
  if (!todo) {
    todo = {};
  }

  const [name, setName] = useState(todo.name);
  const [car, setCar] = useState(todo.car);
  const [dueMileage, setDueMileage] = useState(todo.dueMileage ?? '');

  const onNameChanged = (e) => setName(e.target.value);
  const onCarChanged = (e) => setCar(e.target.value);
  const onDueMileageChanged = (e) => setDueMileage(e.target.value);

  const onSaveTodoClicked = () => {
    if (name && car) {
      dispatch(
        updateTodo({
          id: todoId,
          name: name,
          carId: car,
          dueMileage: Number(dueMileage),
        }),
      );
      history.push(`/`);
    }
  };

  return (
    <section>
      <h2>Edit Post</h2>
      <form>
        <label htmlFor="todoName">Todo Name:</label>
        <input
          type="text"
          id="todoName"
          name="todoName"
          value={name}
          onChange={onNameChanged}
        />
        <label htmlFor="todoName">Car ID:</label>
        <input
          type="number"
          id="carId"
          name="carId"
          value={car}
          onChange={onCarChanged}
        />
        <label htmlFor="todoName">Due Mileage:</label>
        <input
          type="number"
          id="dueMileage"
          name="dueMileage"
          value={dueMileage}
          onChange={onDueMileageChanged}
        />
      </form>
      <button type="button" onClick={onSaveTodoClicked}>
        Save Todo
      </button>
    </section>
  );
};
