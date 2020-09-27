import * as React from 'react';
import { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, IconButton, ButtonBase, Theme } from '@material-ui/core';
import Chip from '@material-ui/core/Chip';
import Checkbox from '@material-ui/core/Checkbox';
import Create from '@material-ui/icons/Create';
import DeleteOutline from '@material-ui/icons/DeleteOutline';
import { red } from '@material-ui/core/colors';

import { LateChip, DueSoonChip } from '../../home/status-chips';
import TodoAddEditForm from './add_edit_form';
import { Car, Todo } from '../../_models';
import { RootState } from '../../store';
import {
  deleteTodo,
  completeTodo,
  undoCompleteTodo,
  selectCarById,
} from '../../_store/data';

interface StyleProps {
  root: React.CSSProperties;
  status: React.CSSProperties;
  todoDescription: React.CSSProperties;
  todoName: React.CSSProperties;
  dueMileage: React.CSSProperties;
  buttons: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
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
    } as any),
);

interface CarTagProps {
  car: Car;
}
const CarTag: React.FC<CarTagProps> = (props): JSX.Element => {
  const { car } = props;
  return (
    <ButtonBase>
      <Chip color="primary" label={car.name} />
    </ButtonBase>
  );
};

type Props = {
  todo: Todo;
};

const DueText: React.FC<Props> = (props): JSX.Element => {
  const { todo } = props;
  const classes: StyleClasses = useStyles({} as StyleProps);

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

export interface TodoItemProps {
  todo: Todo;
}

export default function TodoItem(props: TodoItemProps): JSX.Element {
  const { todo } = props;
  const classes: StyleClasses = useStyles({} as StyleProps);
  const dispatch = useDispatch();
  const [open, setOpen] = useState(false);
  const car = useSelector((state: RootState) => selectCarById(state, todo.car));

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const onDelete = () => {
    dispatch(deleteTodo(todo));
  };

  const onComplete = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.checked) {
      dispatch(completeTodo(todo));
    } else {
      dispatch(undoCompleteTodo(todo));
    }
  };

  let chip = <div />;
  if (todo.dueState === 'late') {
    chip = <LateChip />;
  } else if (todo.dueState === 'dueSoon') {
    chip = <DueSoonChip />;
  }

  const completed = Boolean(todo.completionOdomSnapshot);

  return (
    <div className={classes.root}>
      <Checkbox onChange={onComplete} checked={completed} />
      {chip}
      <div className={classes.todoDescription}>
        <span className={classes.todoName}>{todo.name}</span>{' '}
        <DueText todo={todo} />
      </div>
      <div className={classes.buttons}>
        <CarTag car={car} />
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
