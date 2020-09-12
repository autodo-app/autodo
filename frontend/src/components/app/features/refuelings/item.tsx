import * as React from 'react';
import { useState } from 'react';
import { useDispatch } from 'react-redux';
import { makeStyles, IconButton, ButtonBase, Theme } from '@material-ui/core';
import Chip from '@material-ui/core/Chip';
import Create from '@material-ui/icons/Create';
import DeleteOutline from '@material-ui/icons/DeleteOutline';
import { red } from '@material-ui/core/colors';

import RefuelingAddEditForm from './add_edit_form';
import { Refueling } from '../../_models';
import { deleteRefueling } from '../../_store/data';
import { AUTODO_GREEN, BACKGROUND_DARK, GRAY } from '../../theme';

interface StyleProps {
  root: React.CSSProperties;
  status: React.CSSProperties;
  refuelingDescription: React.CSSProperties;
  refuelingDate: React.CSSProperties;
  refuelingMileage: React.CSSProperties;
  refuelingData: React.CSSProperties;
  buttons: React.CSSProperties;
  dot: React.CSSProperties;
  dotFirst: React.CSSProperties;
  dotContainer: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      root: {
        display: 'flex',
        paddingLeft: theme.spacing(1),
        paddingRight: theme.spacing(1),
        paddingBottom: 0,
        paddingTop: 0,
      },
      status: {
        backgroundColor: red[400],
        marginTop: 'auto',
        marginBottom: 'auto',
      },
      refuelingDescription: {
        marginTop: 'auto',
        marginBottom: 'auto',
        marginLeft: theme.spacing(1),
        marginRight: theme.spacing(1),
      },
      refuelingDate: {
        fontSize: '1.25rem',
        fontWeight: '500',
        marginLeft: theme.spacing(1),
        marginRight: theme.spacing(1),
      },
      refuelingData: {
        justifyContent: 'center',
        margin: 'auto',
      },
      refuelingMileage: {
        fontSize: '1.1rem',
        fontWeight: '300',
      },
      buttons: {
        margin: 0,
      },
      dot: {
        height: '1rem',
        width: '1rem',
        backgroundColor: GRAY,
        borderRadius: '50%',
        margin: 'auto',
      },
      dotFirst: {
        marginTop: 'auto',
        marginBottom: 'auto',
        backgroundColor: AUTODO_GREEN,
        width: '1.5rem',
        height: '1.5rem',
        borderRadius: '50%',
        boxShadow: `inset 0 0 0 4px ${AUTODO_GREEN}, inset 0 0 0 9px ${BACKGROUND_DARK}`,
        '&::after': {
          content: '""',
          width: '6px',
          backgroundColor: 'white',
          top: 0,
          bottom: 0,
          marginLeft: '-3px',
        },
      },
      dotContainer: {
        display: 'flex',
        alignItems: 'center',
        marginTop: 'auto',
        marginBottom: 'auto',
        width: '1.5rem',
        height: '1.5rem',
      },
    } as any),
);

const CarTag: React.FC<{}> = (): JSX.Element => {
  return (
    <ButtonBase>
      <Chip color="primary" label="2009 Passat" />
    </ButtonBase>
  );
};

export interface RefuelingItemProps {
  first: boolean;
  refueling: Refueling;
}

export default function RefuelingItem(props: RefuelingItemProps): JSX.Element {
  const { first, refueling } = props;
  const classes: StyleClasses = useStyles({} as StyleProps);
  const dispatch = useDispatch();
  const [open, setOpen] = useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const onDelete = () => {
    dispatch(deleteRefueling(refueling));
  };

  const dotClass = first ? classes.dotFirst : classes.dot;

  return (
    <div className={classes.root}>
      <div className={classes.dotContainer}>
        <div className={dotClass}></div>
      </div>
      <div className={classes.refuelingDescription}>
        <span className={classes.refuelingDate}>
          {new Date(refueling?.odomSnapshot?.date ?? '').toLocaleDateString()}
        </span>{' '}
        <span className={classes.refuelingMileage}>
          {`${refueling?.odomSnapshot?.mileage} mi`}
        </span>
      </div>
      <div className={classes.refuelingData}>
        <span className={classes.refuelingMileage}>{`$${refueling.cost.toFixed(
          2,
        )} | ${refueling.amount} gal`}</span>
      </div>
      <div className={classes.buttons}>
        <CarTag />
        <IconButton onClick={handleClickOpen}>
          <Create />
        </IconButton>
        <IconButton onClick={onDelete}>
          <DeleteOutline />
        </IconButton>
        <RefuelingAddEditForm
          refueling={refueling}
          open={open}
          handleClose={handleClose}
        />
      </div>
    </div>
  );
}
