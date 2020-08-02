import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { makeStyles, IconButton, ButtonBase } from '@material-ui/core';
import Chip from '@material-ui/core/Chip';
import Checkbox from '@material-ui/core/Checkbox';
import Create from '@material-ui/icons/Create';
import DeleteOutline from '@material-ui/icons/DeleteOutline';
import { red } from '@material-ui/core/colors';

import { LateChip, DueSoonChip } from '../../home/status-chips';
import TodoAddEditForm from './add_edit_form';
import { deleteTodo } from '../../_slices';

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
    padding: theme.spacing(1),
  },
  status: {
    backgroundColor: red[400],
    marginTop: 'auto',
    marginBottom: 'auto',
  },
  todoDescription: {
    marginTop: 'auto',
    marginBottom: 'auto',
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
  },
  todoName: {
    fontSize: '1.25rem',
    fontWeight: '500',
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
  },
  dueMileage: {
    fontSize: '1.1rem',
    fontWeight: '500',
  },
  buttons: {
    marginLeft: 'auto',
  },
}));

const CarTag = () => {
  return (
    <ButtonBase>
      <Chip color="primary" label="2009 Passat" />
    </ButtonBase>
  );
};

const DueText = ({ todo }) => {
  const classes = useStyles();

  if (todo.dueMileage && !todo.dueDate) {
    return (
      <>
        Due at <span className={classes.dueMileage}>{todo.dueMileage}</span> mi
      </>
    );
  } else if (todo.dueDate && !todo.dueMileage) {
    return (
      <>
        Due on <span className={classes.dueMileage}>{todo.dueDate}</span>
      </>
    );
  } else {
    return (
      <>
        Due at <span className={classes.dueMileage}>{todo.dueMileage}</span> mi
        or on
        <span className={classes.dueMileage}>{todo.dueDate}</span>
      </>
    );
  }
};

export default function TodoItem({ todo }) {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [open, setOpen] = useState(false);

  if (!todo) {
    todo = {}; // TODO: hack, use prop types or something
  }

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const onDelete = () => {
    dispatch(deleteTodo(todo));
  };

  let chip = <div />;
  if (todo.dueState === 'late') {
    chip = <LateChip />;
  } else if (todo.dueState === 'dueSoon') {
    chip = <DueSoonChip />;
  }

  return (
    <div className={classes.root}>
      <Checkbox />
      {chip}
      <div className={classes.todoDescription}>
        <span className={classes.todoName}>{todo.name}</span>{' '}
        <DueText todo={todo} />
      </div>
      <div className={classes.buttons}>
        <CarTag />
        <IconButton onClick={handleClickOpen}>
          <Create />
        </IconButton>
        <IconButton onClick={onDelete}>
          <DeleteOutline />
        </IconButton>
        <TodoAddEditForm todo={todo} open={open} handleClose={handleClose} />
      </div>
    </div>
  );
}
