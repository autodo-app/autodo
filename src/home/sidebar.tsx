import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core';
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
import { deepOrange } from '@material-ui/core/colors';

export const drawerWidth = 220;

interface StyleProps {
  drawerPaper: React.CSSProperties;
  titleButton: React.CSSProperties;
  highlightedButtonContainer: React.CSSProperties;
  highlightedButton: React.CSSProperties;
  highlightedButtonText: React.CSSProperties;
  iconButton: React.CSSProperties;
  userIconRoot: React.CSSProperties;
  avatarSpacer: React.CSSProperties;
  orange: React.CSSProperties;
  bottomListItems: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
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
      highlightedButtonContainer: {
        justifyContent: 'flex-start',
        padding: theme.spacing(1),
      },
      highlightedButton: {
        justifyContent: 'flex-start',
        backgroundColor: '#89d8d3',
        backgroundImage: `linear-gradient(45deg, ${AUTODO_GREEN} 0%, #03c8a8 74%)`,
        boxShadow: '0 3px 5px 2px rgba(5, 5, 5, .3)',
        borderRadius: 5,
      },
      highlightedButtonText: {
        color: theme.palette.getContrastText(AUTODO_GREEN),
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
        width: 'inherit',
      },
    } as any),
);

const UserIcon: React.FC<{}> = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);

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

const Tabs: React.FC<{}> = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);

  return (
    <div>
      <div className={classes.highlightedButtonContainer}>
        <ListItem button className={classes.highlightedButton}>
          <ListItemIcon>
            <HomeIcon className={classes.highlightedButtonText} />
          </ListItemIcon>
          <ListItemText
            primary="Home"
            className={classes.highlightedButtonText}
          />
        </ListItem>
      </div>
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

const Footer: React.FC<{}> = (): JSX.Element => {
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

export default function SideBar(): JSX.Element {
  const classes: StyleClasses = useStyles({} as StyleProps);

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
