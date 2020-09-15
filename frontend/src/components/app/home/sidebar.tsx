import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import { useDispatch } from 'react-redux';
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
import { deepOrange } from '@material-ui/core/colors';

import { AUTODO_GREEN, BACKGROUND_LIGHT } from '../../theme';
import { logOut } from '../_store';
import { TabState } from './types';

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

interface TabProps {
  tab: string;
  onHomeClick: () => void;
  onRefuelingsClick: () => void;
  onStatsClick: () => void;
  onGarageClick: () => void;
}

const Tabs: React.FC<TabProps> = (props): JSX.Element => {
  const {
    tab,
    onHomeClick,
    onRefuelingsClick,
    onStatsClick,
    onGarageClick,
  } = props;
  const classes: StyleClasses = useStyles({} as StyleProps);

  const homeButtonContainerClass =
    tab === 'home' ? classes.highlightedButtonContainer : '';
  const homeItemClass = tab === 'home' ? classes.highlightedButton : '';
  const homeTextClass = tab === 'home' ? classes.highlightedButtonText : '';

  const refuelingsButtonContainerClass =
    tab === 'refuelings' ? classes.highlightedButtonContainer : '';
  const refuelingsItemClass =
    tab === 'refuelings' ? classes.highlightedButton : '';
  const refuelingsTextClass =
    tab === 'refuelings' ? classes.highlightedButtonText : '';

  const statsButtonContainerClass =
    tab === 'stats' ? classes.highlightedButtonContainer : '';
  const statsItemClass = tab === 'stats' ? classes.highlightedButton : '';
  const statsTextClass = tab === 'stats' ? classes.highlightedButtonText : '';

  const garageButtonContainerClass =
    tab === 'garage' ? classes.highlightedButtonContainer : '';
  const garageItemClass = tab === 'garage' ? classes.highlightedButton : '';
  const garageTextClass = tab === 'garage' ? classes.highlightedButtonText : '';

  return (
    <div>
      <div className={homeButtonContainerClass}>
        <ListItem button onClick={onHomeClick} className={homeItemClass}>
          <ListItemIcon>
            <HomeIcon className={homeTextClass} />
          </ListItemIcon>
          <ListItemText primary="Home" className={homeTextClass} />
        </ListItem>
      </div>
      <div className={refuelingsButtonContainerClass}>
        <ListItem
          button
          onClick={onRefuelingsClick}
          className={refuelingsItemClass}
        >
          <ListItemIcon>
            <LocalGasStation className={refuelingsTextClass} />
          </ListItemIcon>
          <ListItemText primary="Refuelings" className={refuelingsTextClass} />
        </ListItem>
      </div>
      <div className={statsButtonContainerClass}>
        <ListItem button onClick={onStatsClick} className={statsItemClass}>
          <ListItemIcon className={statsTextClass}>
            <ShowChart />
          </ListItemIcon>
          <ListItemText primary="Stats" className={statsTextClass} />
        </ListItem>
      </div>
      <div className={garageButtonContainerClass}>
        <ListItem button onClick={onGarageClick} className={garageItemClass}>
          <ListItemIcon className={garageTextClass}>
            <DirectionsCar />
          </ListItemIcon>
          <ListItemText primary="Garage" className={garageTextClass} />
        </ListItem>
      </div>
    </div>
  );
};

const Footer: React.FC<{}> = (): JSX.Element => {
  const dispatch = useDispatch();
  const onLogOutClick = () => {
    dispatch(logOut());
  };
  return (
    <div>
      <ListItem button>
        <ListItemIcon>
          <Settings />
        </ListItemIcon>
        <ListItemText primary="Settings" />
      </ListItem>
      <ListItem button onClick={onLogOutClick}>
        <ListItemIcon>
          <ExitToApp />
        </ListItemIcon>
        <ListItemText primary="Log Out" />
      </ListItem>
    </div>
  );
};

export interface SideBarProps {
  tab: string;
  setTab: React.Dispatch<React.SetStateAction<TabState>>;
}

export default function SideBar(props: SideBarProps): JSX.Element {
  const { tab, setTab } = props;
  const classes: StyleClasses = useStyles({} as StyleProps);

  const onHomeClick = () => setTab('home');
  const onRefuelingsClick = () => setTab('refuelings');
  const onStatsClick = () => setTab('stats');
  const onGarageClick = () => setTab('garage');

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
        <Tabs
          tab={tab}
          onHomeClick={onHomeClick}
          onRefuelingsClick={onRefuelingsClick}
          onStatsClick={onStatsClick}
          onGarageClick={onGarageClick}
        />
      </List>
      <List className={classes.bottomListItems}>
        <Footer />
      </List>
    </Drawer>
  );
}
