import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { unwrapResult } from '@reduxjs/toolkit';

import { addNewTodo } from '../../_slices';

export const AddTodoForm = () => {
  const [name, setName] = useState('');
  const [car, setCar] = useState(0);
  const [dueMileage, setDueMileage] = useState(0);
  const [addRequestStatus, setAddRequestStatus] = useState('idle');

  const dispatch = useDispatch();

  const onNameChanged = (e) => setName(e.target.value);
  const onCarChanged = (e) => setCar(Number(e.target.value));
  const onDueMileageChanged = (e) => setDueMileage(Number(e.target.value));

  const canSave = [name, car].every(Boolean) && addRequestStatus === 'idle';

  const onSaveTodoClicked = async () => {
    if (canSave) {
      try {
        setAddRequestStatus('pending');
        const resultAction = await dispatch(
          addNewTodo({
            name: name,
            car: car,
            dueMileage: dueMileage,
          }),
        );
        unwrapResult(resultAction);
        setName('');
        setCar(0);
        setDueMileage(0);
      } catch (err) {
        console.error('Failed to save the post: ', err);
      } finally {
        setAddRequestStatus('idle');
      }
    }
  };

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
        <label htmlFor="carId">Car ID:</label>
        <input
          type="number"
          id="carId"
          name="carId"
          value={car}
          onChange={onCarChanged}
        />
        <label htmlFor="dueMileage">Due Mileage:</label>
        <input
          type="text"
          id="dueMileage"
          name="dueMileage"
          value={dueMileage}
          onChange={onDueMileageChanged}
        />
        <button type="button" onClick={onSaveTodoClicked}>
          Save Todo
        </button>
      </form>
    </section>
  );
};
