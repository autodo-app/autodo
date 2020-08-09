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

interface StyleProps {
  root: React.CSSProperties;
  status: React.CSSProperties;
  refuelingDescription: React.CSSProperties;
  refuelingDate: React.CSSProperties;
  refuelingMileage: React.CSSProperties;
  refuelingData: React.CSSProperties;
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
  refueling: Refueling;
}

export default function RefuelingItem(props: RefuelingItemProps): JSX.Element {
  const { refueling } = props;
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

  return (
    <div className={classes.root}>
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
