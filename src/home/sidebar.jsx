import React from 'react';
import { makeStyles } from '@material-ui/core';
import Drawer from '@material-ui/core/Drawer';
import Button from '@material-ui/core/Button';
import List from '@material-ui/core/List';
import Divider from '@material-ui/core/Divider';
import Avatar from '@material-ui/core/Avatar';
import ButtonBase from '@material-ui/core/ButtonBase';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import HomeIcon from '@material-ui/icons/Home';
import LocalGasStation from '@material-ui/icons/LocalGasStation';
import ShowChart from '@material-ui/icons/ShowChart';
import DirectionsCar from '@material-ui/icons/DirectionsCar';
import Settings from '@material-ui/icons/Settings';
import ExitToApp from '@material-ui/icons/ExitToApp';

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
  iconButton: {
    justifyContent: 'flex-start',
  },
  userIconRoot: {
    display: 'flex',
    overflow: 'auto',
    justifyContent: 'flex-start',
  },
  avatarSpacer: {
    height: '1rem',
  },
  orange: {
    color: theme.palette.getContrastText(deepOrange[500]),
    backgroundColor: deepOrange[500],
    marginLeft: theme.spacing(2),
    marginRight: theme.spacing(2),
    marginTop: 'auto',
    marginBottom: 'auto',
  },
  bottomListItems: {
    position: 'fixed',
    bottom: 0,
  },
}));

const UserIcon = () => {
  const classes = useStyles();

  return (
    // TODO: implement the onClick function
    <ButtonBase focusRipple className={classes.iconButton}>
      <div className={classes.userIconRoot}>
        <Avatar className={classes.orange}>JB</Avatar>
        <h4>Jonathan Bayless</h4>
      </div>
    </ButtonBase>
  );
};

const Tabs = () => {
  const classes = useStyles();

  return (
    <div>
      <ListItem button>
        <ListItemIcon>
          <HomeIcon />
        </ListItemIcon>
        <ListItemText primary="Home" />
      </ListItem>
      <ListItem button>
        <ListItemIcon>
          <LocalGasStation />
        </ListItemIcon>
        <ListItemText primary="Refuelings" />
      </ListItem>
      <ListItem button>
        <ListItemIcon>
          <ShowChart />
        </ListItemIcon>
        <ListItemText primary="Stats" />
      </ListItem>
      <ListItem button>
        <ListItemIcon>
          <DirectionsCar />
        </ListItemIcon>
        <ListItemText primary="Garage" />
      </ListItem>
    </div>
  );
};

const Footer = () => {
  const classes = useStyles();

  return (
    <div>
      <ListItem button>
        <ListItemIcon>
          <Settings />
        </ListItemIcon>
        <ListItemText primary="Settings" />
      </ListItem>
      <ListItem button>
        <ListItemIcon>
          <ExitToApp />
        </ListItemIcon>
        <ListItemText primary="Log Out" />
      </ListItem>
    </div>
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
      <div className={classes.avatarSpacer} />
      <Divider />
      <List>
        <Tabs />
      </List>
      <List className={classes.bottomListItems}>
        <Footer />
      </List>
    </Drawer>
  );
}
