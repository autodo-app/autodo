import React, { useState } from 'react';
import { makeStyles, IconButton, ButtonBase } from '@material-ui/core';
import Chip from '@material-ui/core/Chip';
import Checkbox from '@material-ui/core/Checkbox';
import Create from '@material-ui/icons/Create';
import DeleteOutline from '@material-ui/icons/DeleteOutline';
import { red } from '@material-ui/core/colors';
import { LateChip, DueSoonChip } from '../../home/status-chips';
import TodoAddEditForm from './add_edit_form';

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

export default function TodoItem({ todo, dueState }) {
  const classes = useStyles();
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

  let chip = <div />;
  if (dueState === 'late') {
    chip = <LateChip />;
  } else if (dueState === 'dueSoon') {
    chip = <DueSoonChip />;
  }

  let dueText = <div />;
  if (todo.dueMileage && !todo.dueDate) {
    dueText = (
      <>
        Due at <span className={classes.dueMileage}>{todo.dueMileage}</span> mi
      </>
    );
  } else if (todo.dueDate && !todo.dueMileage) {
    dueText = (
      <>
        Due on <span className={classes.dueMileage}>{todo.dueDate}</span>
      </>
    );
  } else {
    dueText = (
      <>
        Due at <span className={classes.dueMileage}>{todo.dueMileage}</span> mi
        or on
        <span className={classes.dueMileage}>{todo.dueDate}</span>
      </>
    );
  }

  return (
    <div className={classes.root}>
      <Checkbox />
      {chip}
      <div className={classes.todoDescription}>
        <span className={classes.todoName}>{todo.name}</span> {dueText}
      </div>
      <div className={classes.buttons}>
        <CarTag />
        <IconButton onClick={handleClickOpen}>
          <Create />
        </IconButton>
        <IconButton>
          <DeleteOutline />
        </IconButton>
        <TodoAddEditForm todo={todo} open={open} handleClose={handleClose} />
      </div>
    </div>
  );
}
