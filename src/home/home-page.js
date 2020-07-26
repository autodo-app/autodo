import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';

import { fetchData, selectAllTodos } from '../_slices';

export function DataPage() {
  const todos = useSelector(selectAllTodos);
  const dispatch = useDispatch();

  useEffect(() => {
    if (!todos || todos.length === 0) {
      dispatch(fetchData()).then((res) => {
        console.log(res);
      });
    }
  });
  
  return (
    <p>
      {todos}
    </p>
  );
}