import React, { useEffect } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
import Box from '@material-ui/core/Box';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import Link from '@material-ui/core/Link';
import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';
import { useSelector, useDispatch } from 'react-redux';

import { BACKGROUND_LIGHT } from '../theme';
import SearchBar from './searchbar';
import SideBar from './sidebar';
import TodoItem from '../features/todos/todoItem';
import { Divider } from '@material-ui/core';
import { selectAllTodos, fetchData } from '../_slices';
import TodoAddEditForm from '../features/todos/add_edit_form';

function Copyright() {
  return (
    <Typography variant="body2" color="textSecondary" align="center">
      {'Copyright © '}
      <Link color="inherit" href="https://material-ui.com/">
        auToDo
      </Link>{' '}
      {new Date().getFullYear()}
      {'.'}
    </Typography>
  );
}

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
  },
  toolbar: {
    paddingRight: 24, // keep right padding when drawer closed
  },
  toolbarIcon: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'flex-end',
    padding: '0 8px',
    ...theme.mixins.toolbar,
  },
  menuButton: {
    marginRight: 36,
  },
  menuButtonHidden: {
    display: 'none',
  },
  title: {
    flexGrow: 1,
  },

  appBarSpacer: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    height: '100vh',
    overflow: 'auto',
  },
  container: {
    paddingTop: theme.spacing(4),
    paddingBottom: theme.spacing(4),
  },
  paper: {
    padding: theme.spacing(2),
    display: 'flex',
    overflow: 'auto',
    flexDirection: 'column',
    background: BACKGROUND_LIGHT,
  },
  fixedHeight: {
    height: 240,
  },
  fab: {
    margin: 0,
    top: 'auto',
    right: theme.spacing(6),
    bottom: theme.spacing(4),
    left: 'auto',
    position: 'fixed',
  },
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
}));

const TodoList = () => {
  const classes = useStyles();
  const dispatch = useDispatch();

  const todos = useSelector(selectAllTodos);
  const todoStatus = useSelector((state) => state.data.status);
  const error = useSelector((state) => state.data.error);

  useEffect(() => {
    if (todoStatus === 'idle') {
      dispatch(fetchData());
    }
  }, [todoStatus, dispatch]);

  const highPriorityTodos = todos
    .filter((t) => t.dueState === 'late' || t.dueState === 'dueSoon')
    .map((t) => <TodoItem key={t.id} todo={t} />);
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
  if (completedTodos?.length && upcomingTodos?.length) {
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

export default function Dashboard() {
  const classes = useStyles();
  const [open, setOpen] = React.useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <div className={classes.root}>
      <CssBaseline />
      <SideBar />
      <Fab
        color="primary"
        aria-label="add"
        className={classes.fab}
        onClick={handleClickOpen}
      >
        <AddIcon />
      </Fab>
      <main className={classes.content}>
        <Container maxWidth="lg" className={classes.container}>
          <SearchBar />
          <TodoList />
          <Box pt={4}>
            <Copyright />
          </Box>
        </Container>
      </main>
      <TodoAddEditForm open={open} handleClose={handleClose} />
    </div>
  );
}
