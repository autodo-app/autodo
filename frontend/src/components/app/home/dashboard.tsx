import * as React from 'react';
import { useState } from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import CssBaseline from '@material-ui/core/CssBaseline';
import Box from '@material-ui/core/Box';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';
import Link from '@material-ui/core/Link';
import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';

import { BACKGROUND_LIGHT } from '../theme';
import SearchBar from './searchbar';
import SideBar from './sidebar';
import { TodoList, RefuelingList, StatsPage } from '../features';
import { TabState } from './types';
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

interface StyleProps {
  root: React.CSSProperties;
  toolbar: React.CSSProperties;
  toolbarIcon: React.CSSProperties;
  menuButton: React.CSSProperties;
  menuButtonHidden: React.CSSProperties;
  title: React.CSSProperties;
  appBarSpacer: React.CSSProperties;
  content: React.CSSProperties;
  container: React.CSSProperties;
  paper: React.CSSProperties;
  fixedHeight: React.CSSProperties;
  fab: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
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
    } as any),
);

export default function Dashboard(): JSX.Element {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const [open, setOpen] = useState(false);
  const [tab, setTab] = useState<TabState>('stats');

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  let tabContent;
  if (tab === 'home') {
    tabContent = <TodoList />;
  } else if (tab === 'refuelings') {
    tabContent = <RefuelingList />;
  } else if (tab === 'stats') {
    tabContent = <StatsPage />;
  }

  return (
    <div className={classes.root}>
      <CssBaseline />
      <SideBar tab={tab} setTab={setTab} />
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
          {tabContent}
          <Box pt={4}>
            <Copyright />
          </Box>
        </Container>
      </main>
      <TodoAddEditForm open={open} handleClose={handleClose} />
    </div>
  );
}
