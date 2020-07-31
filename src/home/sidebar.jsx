import React from 'react';
import { makeStyles } from '@material-ui/core';
import Drawer from '@material-ui/core/Drawer';
import Button from '@material-ui/core/Button';
import List from '@material-ui/core/List';
import Divider from '@material-ui/core/Divider';
import Avatar from '@material-ui/core/Avatar';
import ButtonBase from '@material-ui/core/ButtonBase';
import { AUTODO_GREEN, BACKGROUND_LIGHT } from '../theme';
import { mainListItems, secondaryListItems } from './listItems';
import { deepOrange } from '@material-ui/core/colors';

export const drawerWidth = 240;

const useStyles = makeStyles((theme) => ({
  drawerPaper: {
    position: 'relative',
    whiteSpace: 'nowrap',
    width: drawerWidth,
    transition: theme.transitions.create('width', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
    background: BACKGROUND_LIGHT,
  },
  titleButton: {
    color: AUTODO_GREEN,
    textTransform: 'none',
    fontSize: '2.25rem',
    fontWeight: '800',
  },
  userIconRoot: {
    paddingLeft: theme.spacing(2),
    paddingRight: theme.spacing(2),
    display: 'flex',
    overflow: 'auto',
  },
  orange: {
    color: theme.palette.getContrastText(deepOrange[500]),
    backgroundColor: deepOrange[500],
    marginLeft: theme.spacing(2),
    marginRight: theme.spacing(2),
    marginTop: 'auto',
    marginBottom: 'auto',
  },
}));

const UserIcon = () => {
  const classes = useStyles();

  return (
    // TODO: implement the onClick function
    <ButtonBase focusRipple>
      <div className={classes.userIconRoot}>
        <Avatar className={classes.orange}>JB</Avatar>
        <h4>Jonathan Bayless</h4>
      </div>
    </ButtonBase>
  );
};

export default function SideBar() {
  const classes = useStyles();

  return (
    <Drawer
      variant="permanent"
      classes={{
        paper: classes.drawerPaper,
      }}
    >
      <Button className={classes.titleButton}>auToDo</Button>
      <UserIcon />
      <List>{mainListItems}</List>
      <Divider />
      <List>{secondaryListItems}</List>
    </Drawer>
  );
}
