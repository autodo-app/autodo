import * as React from 'react';
import { useState } from 'react';
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

import { CarList } from '../cars';
import { GRAY } from '../../../theme';

interface StyleProps {
  button: React.CSSProperties;
}

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      button: {
        backgroundColor: GRAY,
      },
    } as any),
);

export const GaragePage = () => {
  const classes = useStyles({} as StyleProps);
  const [open, setOpen] = useState(false);

  const onButtonPressed = () => setOpen(true);
  const onClose = () => setOpen(false);

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
