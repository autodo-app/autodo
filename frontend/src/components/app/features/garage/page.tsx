import * as React from 'react';
import { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
  makeStyles,
  Theme,
  Button,
  Grid,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogContentText,
  DialogActions,
} from '@material-ui/core';
import { Search, Build } from '@material-ui/icons';

import { selectAllCars, fetchData } from '../../_store';
import { RootState } from '../../store';
import { CarList } from '../cars';
import { GRAY } from '../../../theme';

interface StyleProps {
  button: React.CSSProperties;
  statusMessage: React.CSSProperties;
}

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      button: {
        backgroundColor: GRAY,
      },
      statusMessage: {
        display: 'flex',
        margin: theme.spacing(2),
        alignContent: 'center',
        justifyContent: 'center',
      },
    } as any),
);

export const GaragePage = () => {
  const classes = useStyles({} as StyleProps);
  const [open, setOpen] = useState(false);
  const dispatch = useDispatch();

  const dataStatus = useSelector((state: RootState) => state.data.status);

  const onButtonPressed = () => setOpen(true);
  const onClose = () => setOpen(false);
  const cars = useSelector(selectAllCars);

  useEffect(() => {
    if (dataStatus === 'idle') {
      dispatch(fetchData());
    }
  }, [dataStatus, dispatch]);

  if (!cars?.length) {
    return (
      <div className={classes.statusMessage}>Cannot reach auToDo API.</div>
    );
  }

  return (
    <>
      <CarList />
      <Grid
        container
        spacing={4}
        alignItems="center"
        alignContent="center"
        justify="center"
      >
        <Grid item sm={4}>
          <Button
            fullWidth={true}
            variant="contained"
            size="large"
            color="primary"
            startIcon={<Search />}
            className={classes.button}
            onClick={onButtonPressed}
          >
            FIND A MECHANIC
          </Button>
        </Grid>
        <Grid item sm={4}>
          <Button
            fullWidth={true}
            variant="contained"
            size="large"
            color="primary"
            startIcon={<Build />}
            className={classes.button}
            onClick={onButtonPressed}
          >
            LEARN TO D.I.Y.
          </Button>
        </Grid>
        <Grid item sm={4}>
          <Button
            variant="contained"
            fullWidth={true}
            size="large"
            color="primary"
            startIcon={<Search />}
            className={classes.button}
            onClick={onButtonPressed}
          >
            FIND PARTS
          </Button>
        </Grid>
      </Grid>
      <Dialog open={open} onClose={onClose}>
        <DialogTitle id="form-dialog-title">TBD</DialogTitle>
        <DialogContent>
          <DialogContentText>This content is coming soon.</DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose}>Okay</Button>
        </DialogActions>
      </Dialog>
    </>
  );
};
