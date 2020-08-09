import * as React from 'react';
import { useEffect } from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import { Divider } from '@material-ui/core';
import { useSelector, useDispatch } from 'react-redux';

import TodoItem from './todo_item';
import { selectAllTodos, fetchData } from '../../_store';
import { RootState } from '../../app/store';

interface StyleProps {
  header: React.CSSProperties;
  dashboard: React.CSSProperties;
  date: React.CSSProperties;
  dateNumber: React.CSSProperties;
  upcoming: React.CSSProperties;
  statusMessage: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      header: {
        display: 'flex',
        justifyContent: 'space-between',
      },
      dashboard: {
        marginTop: '1.5rem',
        marginBottom: '.25rem',
      },
      date: {
        marginTop: '1.5rem',
        marginBottom: '.25rem',
        fontWeight: '400',
        letterSpacing: 0.8,
      },
      dateNumber: {
        fontWeight: '600',
        letterSpacing: 0.8,
      },
      upcoming: {
        fontWeight: '400',
        letterSpacing: 0.8,
        marginBottom: '.25rem',
      },
      statusMessage: {
        display: 'flex',
        margin: theme.spacing(2),
        alignContent: 'center',
        justifyContent: 'center',
      },
    } as any),
);

export const TodoList: React.FC<{}> = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const dispatch = useDispatch();

  const todos = useSelector(selectAllTodos);
  const todoStatus = useSelector((state: RootState) => state.data.status);
  const error = useSelector((state: RootState) => state.data.error);

  useEffect(() => {
    if (todoStatus === 'idle') {
      dispatch(fetchData());
    }
  }, [todoStatus, dispatch]);

  const highPriorityTodos = todos
    .filter((t) => t.dueState === 'late' || t.dueState === 'dueSoon')
    .map((t) => <TodoItem key={t?.id} todo={t} />);
  const upcomingTodos = todos
    .filter((t) => t.dueState === 'upcoming')
    .map((t) => <TodoItem key={t.id} todo={t} />);
  const completedTodos = todos
    .filter((t) => t.dueState === 'completed')
    .map((t) => <TodoItem key={t.id} todo={t} />);

  if (todoStatus === 'loading') {
    return <div className={classes.statusMessage}>Loading...</div>;
  } else if (todoStatus === 'error') {
    return <div className={classes.statusMessage}>{error}</div>;
  }

  let upcomingHeader = <></>;
  if (highPriorityTodos?.length && upcomingTodos?.length) {
    upcomingHeader = (
      <>
        <h3 className={classes.upcoming}>Upcoming</h3>
        <Divider />
      </>
    );
  }

  let completedHeader = <></>;
  if (
    completedTodos?.length &&
    (upcomingTodos?.length || highPriorityTodos?.length)
  ) {
    upcomingHeader = (
      <>
        <h3 className={classes.upcoming}>Completed</h3>
        <Divider />
      </>
    );
  }

  return (
    <>
      <div className={classes.header}>
        <h2 className={classes.dashboard}>Dashboard</h2>
        <h4 className={classes.date}>
          Wednesday, <span className={classes.dateNumber}>July 29th</span>
        </h4>
      </div>
      <Divider />

      {highPriorityTodos}
      {upcomingHeader}
      {upcomingTodos}
      {completedHeader}
      {completedTodos}
    </>
  );
};
